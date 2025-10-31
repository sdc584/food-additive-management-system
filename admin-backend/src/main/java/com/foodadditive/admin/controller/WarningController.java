package com.foodadditive.admin.controller;

import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.foodadditive.admin.annotation.OperationLog;
import com.foodadditive.admin.entity.FoodAdditive;
import com.foodadditive.admin.entity.Warning;
import com.foodadditive.admin.service.FoodAdditiveService;
import com.foodadditive.admin.service.WarningService;
import com.foodadditive.admin.common.Result;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.util.StringUtils;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

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

    @Autowired
    private FoodAdditiveService foodAdditiveService;

    /**
     * 查询预警列表
     * 支持按预警类型、预警级别、状态查询
     */
    @GetMapping
    public Result<List<Warning>> list(
            @RequestParam(required = false) String warningType,
            @RequestParam(required = false) String warningLevel,
            @RequestParam(required = false) String status) {

        QueryWrapper<Warning> queryWrapper = new QueryWrapper<>();

        // 预警类型查询
        if (StringUtils.hasText(warningType)) {
            queryWrapper.eq("warning_type", warningType);
        }

        // 预警级别查询
        if (StringUtils.hasText(warningLevel)) {
            queryWrapper.eq("warning_level", warningLevel);
        }

        // 状态查询
        if (StringUtils.hasText(status)) {
            queryWrapper.eq("status", status);
        }

        // 按预警日期倒序排列
        queryWrapper.orderByDesc("warning_date");

        List<Warning> list = warningService.list(queryWrapper);

        // 填充添加剂名称
        if (!list.isEmpty()) {
            // 获取所有添加剂信息
            List<FoodAdditive> additives = foodAdditiveService.list();
            Map<Long, String> additiveMap = additives.stream()
                    .collect(Collectors.toMap(FoodAdditive::getAdditiveId, FoodAdditive::getAdditiveName));

            // 为每个预警记录设置添加剂名称
            list.forEach(warning -> {
                if (warning.getAdditiveId() != null) {
                    warning.setAdditiveName(additiveMap.get(warning.getAdditiveId()));
                }
            });
        }

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
     * 通用更新预警（保留原有接口）
     */
    @PutMapping
    public Result<Boolean> update(@RequestBody Warning entity) {
        // 根据状态变化判断操作类型
        Warning oldWarning = warningService.getById(entity.getWarningId());
        if (oldWarning != null) {
            // 如果状态从PENDING变为RESOLVED，记录为"处理预警"
            if ("PENDING".equals(oldWarning.getStatus()) && "RESOLVED".equals(entity.getStatus())) {
                return handleWarning(entity);
            }
            // 如果状态从RESOLVED变为PENDING，记录为"取消处理预警"
            else if ("RESOLVED".equals(oldWarning.getStatus()) && "PENDING".equals(entity.getStatus())) {
                return cancelHandleWarning(entity);
            }
        }
        // 其他情况直接更新
        boolean result = warningService.updateById(entity);
        return Result.success(result);
    }

    /**
     * 处理预警（标记为已解决）
     */
    @OperationLog(operation = "处理预警")
    @PutMapping("/handle")
    public Result<Boolean> handleWarning(@RequestBody Warning entity) {
        entity.setStatus("RESOLVED");
        boolean result = warningService.updateById(entity);
        return Result.success(result);
    }

    /**
     * 取消处理预警（恢复为未处理）
     */
    @OperationLog(operation = "取消处理预警")
    @PutMapping("/cancel-handle")
    public Result<Boolean> cancelHandleWarning(@RequestBody Warning entity) {
        entity.setStatus("PENDING");
        entity.setHandleTime(null);
        boolean result = warningService.updateById(entity);
        return Result.success(result);
    }

    /**
     * 删除预警（关闭预警）
     */
    @OperationLog(operation = "关闭预警")
    @DeleteMapping("/{id}")
    public Result<Boolean> delete(@PathVariable Long id) {
        boolean result = warningService.removeById(id);
        return Result.success(result);
    }

}
