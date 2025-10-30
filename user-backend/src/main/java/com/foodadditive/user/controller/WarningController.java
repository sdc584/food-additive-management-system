package com.foodadditive.user.controller;

import com.foodadditive.user.entity.Warning;
import com.foodadditive.user.service.WarningService;
import com.foodadditive.user.common.Result;
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
@RequestMapping("/warnings")
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

}
