package com.foodadditive.admin.controller;

import com.foodadditive.admin.entity.FoodAdditive;
import com.foodadditive.admin.service.FoodAdditiveService;
import com.foodadditive.admin.common.Result;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.List;

/**
 * 食品添加剂Controller
 * 
 * @author 系统
 * @since 2025-01-01
 */
@RestController
@RequestMapping("/foodAdditives")
public class FoodAdditiveController {

    @Autowired
    private FoodAdditiveService foodAdditiveService;

    /**
     * 查询食品添加剂列表
     */
    @GetMapping
    public Result<List<FoodAdditive>> list() {
        List<FoodAdditive> list = foodAdditiveService.list();
        return Result.success(list);
    }

    /**
     * 根据ID查询食品添加剂
     */
    @GetMapping("/{id}")
    public Result<FoodAdditive> getById(@PathVariable Long id) {
        FoodAdditive entity = foodAdditiveService.getById(id);
        return Result.success(entity);
    }

    /**
     * 新增食品添加剂
     */
    @PostMapping
    public Result<Boolean> save(@RequestBody FoodAdditive entity) {
        boolean result = foodAdditiveService.save(entity);
        return Result.success(result);
    }

    /**
     * 更新食品添加剂
     */
    @PutMapping
    public Result<Boolean> update(@RequestBody FoodAdditive entity) {
        boolean result = foodAdditiveService.updateById(entity);
        return Result.success(result);
    }

    /**
     * 删除食品添加剂
     */
    @DeleteMapping("/{id}")
    public Result<Boolean> delete(@PathVariable Long id) {
        boolean result = foodAdditiveService.removeById(id);
        return Result.success(result);
    }

}
