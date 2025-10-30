package com.foodadditive.user.controller;

import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.foodadditive.user.common.Result;
import com.foodadditive.user.dto.LoginRequest;
import com.foodadditive.user.dto.LoginResponse;
import com.foodadditive.user.entity.SysUser;
import com.foodadditive.user.service.SysUserService;
import com.foodadditive.user.util.JwtUtil;
import com.foodadditive.user.util.PasswordUtil;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

/**
 * 认证控制器
 * 处理登录、注册等认证相关操作
 * 
 * @author 系统
 * @since 2025-01-01
 */
@RestController
@RequestMapping("/auth")
public class AuthController {

    @Autowired
    private SysUserService sysUserService;

    /**
     * 用户登录
     * 
     * @param request 登录请求
     * @return 登录结果
     */
    @PostMapping("/login")
    public Result<LoginResponse> login(@RequestBody LoginRequest request) {
        // 参数校验
        if (request.getUsername() == null || request.getUsername().trim().isEmpty()) {
            return Result.error("用户名不能为空");
        }
        if (request.getPassword() == null || request.getPassword().trim().isEmpty()) {
            return Result.error("密码不能为空");
        }

        // 查询用户
        QueryWrapper<SysUser> queryWrapper = new QueryWrapper<>();
        queryWrapper.eq("username", request.getUsername());
        SysUser user = sysUserService.getOne(queryWrapper);

        // 用户不存在
        if (user == null) {
            return Result.error("用户名或密码错误");
        }

        // 验证密码
        if (!PasswordUtil.matches(request.getPassword(), user.getPassword())) {
            return Result.error("用户名或密码错误");
        }

        // 检查用户状态
        if (user.getStatus() == null || user.getStatus() != 1) {
            return Result.error("账号已被禁用");
        }

        // 生成JWT令牌
        String token = JwtUtil.generateToken(user.getUserId(), user.getUsername(), user.getRole());

        // 构造响应
        LoginResponse response = new LoginResponse(
                token,
                user.getUserId(),
                user.getUsername(),
                user.getRealName(),
                user.getRole()
        );

        return Result.success("登录成功", response);
    }

    /**
     * 获取当前用户信息
     * 
     * @param token JWT令牌
     * @return 用户信息
     */
    @GetMapping("/info")
    public Result<SysUser> getUserInfo(@RequestHeader("Authorization") String token) {
        // 去除Bearer前缀
        if (token.startsWith("Bearer ")) {
            token = token.substring(7);
        }

        // 验证令牌
        if (!JwtUtil.validateToken(token)) {
            return Result.error(401, "令牌无效或已过期");
        }

        // 获取用户ID
        Long userId = JwtUtil.getUserIdFromToken(token);
        if (userId == null) {
            return Result.error(401, "无法获取用户信息");
        }

        // 查询用户
        SysUser user = sysUserService.getById(userId);
        if (user == null) {
            return Result.error("用户不存在");
        }

        // 清除密码字段
        user.setPassword(null);

        return Result.success(user);
    }

    /**
     * 用户登出
     * 
     * @return 登出结果
     */
    @PostMapping("/logout")
    public Result<Void> logout() {
        // 前端清除token即可
        return Result.success("登出成功", null);
    }
}

