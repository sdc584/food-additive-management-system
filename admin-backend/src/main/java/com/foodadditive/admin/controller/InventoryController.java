package com.foodadditive.admin.controller;

import com.foodadditive.admin.entity.Inventory;
import com.foodadditive.admin.service.InventoryService;
import com.foodadditive.admin.common.Result;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.List;

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

    /**
     * 查询库存列表
     */
    @GetMapping
    public Result<List<Inventory>> list() {
        List<Inventory> list = inventoryService.list();
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
    @PostMapping
    public Result<Boolean> save(@RequestBody Inventory entity) {
        boolean result = inventoryService.save(entity);
        return Result.success(result);
    }

    /**
     * 更新库存
     */
    @PutMapping
    public Result<Boolean> update(@RequestBody Inventory entity) {
        boolean result = inventoryService.updateById(entity);
        return Result.success(result);
    }

    /**
     * 删除库存
     */
    @DeleteMapping("/{id}")
    public Result<Boolean> delete(@PathVariable Long id) {
        boolean result = inventoryService.removeById(id);
        return Result.success(result);
    }

}
