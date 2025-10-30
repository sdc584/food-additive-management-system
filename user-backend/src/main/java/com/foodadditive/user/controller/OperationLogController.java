package com.foodadditive.user.controller;

import com.foodadditive.user.entity.OperationLog;
import com.foodadditive.user.service.OperationLogService;
import com.foodadditive.user.common.Result;
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
@RequestMapping("/operationLogs")
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

}
