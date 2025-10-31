package com.foodadditive.admin.controller;

import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.baomidou.mybatisplus.core.metadata.IPage;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.foodadditive.admin.entity.OperationLog;
import com.foodadditive.admin.service.OperationLogService;
import com.foodadditive.admin.common.Result;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.util.StringUtils;
import org.springframework.web.bind.annotation.*;

import java.util.List;

/**
 * 操作日志Controller
 * 
 * @author 系统
 * @since 2025-01-01
 */
@RestController
@RequestMapping("/operationLogs")
public class OperationLogController {

    @Autowired
    private OperationLogService operationLogService;

    /**
     * 分页查询操作日志列表
     */
    @GetMapping
    public Result<IPage<OperationLog>> list(
            @RequestParam(required = false) String operator,
            @RequestParam(required = false) String operationType,
            @RequestParam(required = false) String moduleName,
            @RequestParam(required = false) String startDate,
            @RequestParam(required = false) String endDate,
            @RequestParam(defaultValue = "1") Integer page,
            @RequestParam(defaultValue = "10") Integer size) {

        // 创建分页对象
        Page<OperationLog> pageParam = new Page<>(page, size);

        // 创建查询条件
        QueryWrapper<OperationLog> queryWrapper = new QueryWrapper<>();

        // 按操作人查询
        if (StringUtils.hasText(operator)) {
            queryWrapper.like("username", operator);
        }

        // 按操作类型查询（这里需要根据前端传的值映射到operation字段）
        if (StringUtils.hasText(operationType)) {
            queryWrapper.like("operation", operationType);
        }

        // 按模块名称查询
        if (StringUtils.hasText(moduleName)) {
            queryWrapper.like("method", moduleName);
        }

        // 按时间范围查询
        if (StringUtils.hasText(startDate)) {
            queryWrapper.ge("operation_time", startDate + " 00:00:00");
        }
        if (StringUtils.hasText(endDate)) {
            queryWrapper.le("operation_time", endDate + " 23:59:59");
        }

        // 按操作时间倒序
        queryWrapper.orderByDesc("operation_time");

        // 分页查询
        IPage<OperationLog> result = operationLogService.page(pageParam, queryWrapper);

        return Result.success(result);
    }

    /**
     * 获取最近的操作日志（用于首页展示）
     */
    @GetMapping("/recent")
    public Result<List<OperationLog>> getRecentLogs(@RequestParam(defaultValue = "5") Integer limit) {
        List<OperationLog> list = operationLogService.getRecentLogs(limit);
        return Result.success(list);
    }

    /**
     * 根据ID查询操作日志
     */
    @GetMapping("/{id}")
    public Result<OperationLog> getById(@PathVariable Long id) {
        OperationLog entity = operationLogService.getById(id);
        return Result.success(entity);
    }

    /**
     * 新增操作日志
     */
    @PostMapping
    public Result<Boolean> save(@RequestBody OperationLog entity) {
        boolean result = operationLogService.save(entity);
        return Result.success(result);
    }

    /**
     * 更新操作日志
     */
    @PutMapping
    public Result<Boolean> update(@RequestBody OperationLog entity) {
        boolean result = operationLogService.updateById(entity);
        return Result.success(result);
    }

    /**
     * 删除操作日志
     */
    @DeleteMapping("/{id}")
    public Result<Boolean> delete(@PathVariable Long id) {
        boolean result = operationLogService.removeById(id);
        return Result.success(result);
    }

}
