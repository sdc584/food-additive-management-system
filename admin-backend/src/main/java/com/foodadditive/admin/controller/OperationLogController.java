package com.foodadditive.admin.controller;

import com.foodadditive.admin.entity.OperationLog;
import com.foodadditive.admin.service.OperationLogService;
import com.foodadditive.admin.common.Result;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.List;

/**
 * 操作日志Controller
 * 
 * @author 系统
 * @since 2025-01-01
 */
@RestController
@RequestMapping("/api/admin/operationLogs")
public class OperationLogController {

    @Autowired
    private OperationLogService operationLogService;

    /**
     * 查询操作日志列表
     */
    @GetMapping
    public Result<List<OperationLog>> list() {
        List<OperationLog> list = operationLogService.list();
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
