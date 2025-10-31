package com.foodadditive.admin.controller;

import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.foodadditive.admin.annotation.OperationLog;
import com.foodadditive.admin.entity.FoodAdditive;
import com.foodadditive.admin.entity.Inventory;
import com.foodadditive.admin.service.FoodAdditiveService;
import com.foodadditive.admin.service.InventoryService;
import com.foodadditive.admin.common.Result;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.util.StringUtils;
import org.springframework.web.bind.annotation.*;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

/**
 * 库存Controller
 * 
 * @author 系统
 * @since 2025-01-01
 */
@RestController
@RequestMapping("/inventories")
public class InventoryController {

    @Autowired
    private InventoryService inventoryService;

    @Autowired
    private FoodAdditiveService foodAdditiveService;

    /**
     * 查询库存列表
     * 支持按添加剂ID、添加剂名称、仓库位置、状态查询
     */
    @GetMapping
    public Result<List<Inventory>> list(
            @RequestParam(required = false) Long additiveId,
            @RequestParam(required = false) String additiveName,
            @RequestParam(required = false) String warehouseLocation,
            @RequestParam(required = false) Integer status) {

        QueryWrapper<Inventory> queryWrapper = new QueryWrapper<>();

        // 添加剂ID精确查询
        if (additiveId != null) {
            queryWrapper.eq("additive_id", additiveId);
        }

        // 如果有添加剂名称查询条件，先查询添加剂ID
        if (StringUtils.hasText(additiveName)) {
            QueryWrapper<FoodAdditive> additiveQuery = new QueryWrapper<>();
            additiveQuery.like("additive_name", additiveName);
            List<FoodAdditive> additives = foodAdditiveService.list(additiveQuery);

            if (additives.isEmpty()) {
                // 没有匹配的添加剂，返回空列表
                return Result.success(new ArrayList<>());
            }

            List<Long> additiveIds = additives.stream()
                    .map(FoodAdditive::getAdditiveId)
                    .collect(Collectors.toList());
            queryWrapper.in("additive_id", additiveIds);
        }

        // 仓库位置模糊查询
        if (StringUtils.hasText(warehouseLocation)) {
            queryWrapper.like("warehouse_location", warehouseLocation);
        }

        // 状态精确查询
        if (status != null) {
            queryWrapper.eq("status", status);
        }

        List<Inventory> list = inventoryService.list(queryWrapper);

        // 填充添加剂名称
        if (!list.isEmpty()) {
            // 获取所有添加剂信息
            List<FoodAdditive> additives = foodAdditiveService.list();
            Map<Long, String> additiveMap = additives.stream()
                    .collect(Collectors.toMap(FoodAdditive::getAdditiveId, FoodAdditive::getAdditiveName));

            // 为每个库存记录设置添加剂名称
            list.forEach(inventory -> {
                if (inventory.getAdditiveId() != null) {
                    inventory.setAdditiveName(additiveMap.get(inventory.getAdditiveId()));
                }
            });
        }

        return Result.success(list);
    }

    /**
     * 根据ID查询库存
     */
    @GetMapping("/{id}")
    public Result<Inventory> getById(@PathVariable Long id) {
        Inventory entity = inventoryService.getById(id);
        return Result.success(entity);
    }

    /**
     * 新增库存
     */
    @OperationLog(operation = "新增库存")
    @PostMapping
    public Result<Boolean> save(@RequestBody Inventory entity) {
        boolean result = inventoryService.save(entity);
        return Result.success(result);
    }

    /**
     * 更新库存
     */
    @OperationLog(operation = "更新库存")
    @PutMapping
    public Result<Boolean> update(@RequestBody Inventory entity) {
        boolean result = inventoryService.updateById(entity);
        return Result.success(result);
    }

    /**
     * 删除库存
     */
    @OperationLog(operation = "删除库存")
    @DeleteMapping("/{id}")
    public Result<Boolean> delete(@PathVariable Long id) {
        boolean result = inventoryService.removeById(id);
        return Result.success(result);
    }

}
