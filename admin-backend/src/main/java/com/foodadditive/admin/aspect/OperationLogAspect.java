package com.foodadditive.admin.aspect;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.foodadditive.admin.entity.OperationLog;
import com.foodadditive.admin.service.OperationLogService;
import com.foodadditive.admin.util.JwtUtil;
import io.jsonwebtoken.Claims;
import org.aspectj.lang.ProceedingJoinPoint;
import org.aspectj.lang.annotation.Around;
import org.aspectj.lang.annotation.Aspect;
import org.aspectj.lang.annotation.Pointcut;
import org.aspectj.lang.reflect.MethodSignature;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import org.springframework.web.context.request.RequestContextHolder;
import org.springframework.web.context.request.ServletRequestAttributes;

import javax.servlet.http.HttpServletRequest;
import java.lang.reflect.Method;
import java.util.Date;

/**
 * 操作日志切面
 * 自动记录所有Controller的操作
 *
 * @author 系统
 * @since 2025-01-01
 */
@Aspect
@Component
public class OperationLogAspect {

    @Autowired
    private OperationLogService operationLogService;

    private final ObjectMapper objectMapper = new ObjectMapper();

    /**
     * 定义切点：只拦截有@OperationLog注解的方法
     */
    @Pointcut("@annotation(com.foodadditive.admin.annotation.OperationLog)")
    public void operationLogPointcut() {
    }

    /**
     * 环绕通知：记录操作日志
     */
    @Around("operationLogPointcut()")
    public Object around(ProceedingJoinPoint joinPoint) throws Throwable {
        long startTime = System.currentTimeMillis();
        
        // 获取请求信息
        ServletRequestAttributes attributes = (ServletRequestAttributes) RequestContextHolder.getRequestAttributes();
        HttpServletRequest request = attributes != null ? attributes.getRequest() : null;
        
        // 执行方法
        Object result = null;
        Exception exception = null;
        try {
            result = joinPoint.proceed();
            return result;
        } catch (Exception e) {
            exception = e;
            throw e;
        } finally {
            // 记录日志
            try {
                saveLog(joinPoint, request, startTime, exception);
            } catch (Exception e) {
                // 记录日志失败不影响业务
                e.printStackTrace();
            }
        }
    }

    /**
     * 保存操作日志
     */
    private void saveLog(ProceedingJoinPoint joinPoint, HttpServletRequest request, long startTime, Exception exception) {
        if (request == null) {
            return;
        }

        OperationLog log = new OperationLog();

        // 获取方法信息
        MethodSignature signature = (MethodSignature) joinPoint.getSignature();
        Method method = signature.getMethod();
        
        // 获取注解信息
        com.foodadditive.admin.annotation.OperationLog annotation = method.getAnnotation(com.foodadditive.admin.annotation.OperationLog.class);
        if (annotation != null) {
            log.setOperation(annotation.operation());
        } else {
            // 如果没有注解，使用方法名
            log.setOperation(method.getName());
        }

        // 获取用户信息
        String token = request.getHeader("Authorization");
        if (token != null && token.startsWith("Bearer ")) {
            token = token.substring(7);
            try {
                Claims claims = JwtUtil.getClaimsFromToken(token);
                if (claims != null) {
                    Long userId = Long.valueOf(claims.get("userId").toString());
                    String username = claims.getSubject();
                    log.setUserId(userId);
                    log.setUsername(username);
                } else {
                    // Token无效，不记录日志
                    return;
                }
            } catch (Exception e) {
                // Token解析失败，不记录日志
                return;
            }
        } else {
            // 没有Token，不记录日志
            return;
        }

        // 设置请求信息
        String requestMethod = request.getMethod();
        String requestUri = request.getRequestURI();
        log.setMethod(requestMethod + " " + requestUri);

        // 获取请求参数
        try {
            Object[] args = joinPoint.getArgs();
            if (args != null && args.length > 0) {
                // 过滤掉HttpServletRequest等不需要记录的参数
                StringBuilder params = new StringBuilder();
                for (Object arg : args) {
                    if (arg != null && 
                        !(arg instanceof HttpServletRequest) && 
                        !(arg instanceof javax.servlet.http.HttpServletResponse)) {
                        if (params.length() > 0) {
                            params.append(", ");
                        }
                        params.append(objectMapper.writeValueAsString(arg));
                    }
                }
                if (params.length() > 0) {
                    log.setParams(params.toString());
                }
            }
        } catch (Exception e) {
            log.setParams("参数解析失败");
        }

        // 设置IP地址
        log.setIp(getIpAddress(request));

        // 设置操作时间
        log.setOperationTime(new Date());

        // 设置执行时长
        long executionTime = System.currentTimeMillis() - startTime;
        log.setExecutionTime(executionTime);

        // 设置状态
        if (exception == null) {
            log.setStatus(1); // 成功
        } else {
            log.setStatus(0); // 失败
            log.setErrorMsg(exception.getMessage());
        }

        // 保存日志
        operationLogService.save(log);
    }

    /**
     * 获取客户端IP地址
     */
    private String getIpAddress(HttpServletRequest request) {
        String ip = request.getHeader("X-Forwarded-For");
        if (ip == null || ip.length() == 0 || "unknown".equalsIgnoreCase(ip)) {
            ip = request.getHeader("Proxy-Client-IP");
        }
        if (ip == null || ip.length() == 0 || "unknown".equalsIgnoreCase(ip)) {
            ip = request.getHeader("WX-Forwarded-For");
        }
        if (ip == null || ip.length() == 0 || "unknown".equalsIgnoreCase(ip)) {
            ip = request.getRemoteAddr();
        }
        if (ip != null && ip.contains(",")) {
            ip = ip.split(",")[0];
        }
        return ip;
    }
}

