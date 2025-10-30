package com.foodadditive.user.controller;

import com.foodadditive.user.entity.Inventory;
import com.foodadditive.user.service.InventoryService;
import com.foodadditive.user.common.Result;
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

}
