package com.foodadditive.admin.controller;

import com.foodadditive.admin.entity.Warning;
import com.foodadditive.admin.service.WarningService;
import com.foodadditive.admin.common.Result;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.List;

/**
 * 预警Controller
 * 
 * @author 系统
 * @since 2025-01-01
 */
@RestController
@RequestMapping("/api/admin/warnings")
public class WarningController {

    @Autowired
    private WarningService warningService;

    /**
     * 查询预警列表
     */
    @GetMapping
    public Result<List<Warning>> list() {
        List<Warning> list = warningService.list();
        return Result.success(list);
    }

    /**
     * 根据ID查询预警
     */
    @GetMapping("/{id}")
    public Result<Warning> getById(@PathVariable Long id) {
        Warning entity = warningService.getById(id);
        return Result.success(entity);
    }

    /**
     * 新增预警
     */
    @PostMapping
    public Result<Boolean> save(@RequestBody Warning entity) {
        boolean result = warningService.save(entity);
        return Result.success(result);
    }

    /**
     * 更新预警
     */
    @PutMapping
    public Result<Boolean> update(@RequestBody Warning entity) {
        boolean result = warningService.updateById(entity);
        return Result.success(result);
    }

    /**
     * 删除预警
     */
    @DeleteMapping("/{id}")
    public Result<Boolean> delete(@PathVariable Long id) {
        boolean result = warningService.removeById(id);
        return Result.success(result);
    }

}
