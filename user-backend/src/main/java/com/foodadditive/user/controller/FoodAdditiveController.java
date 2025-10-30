package com.foodadditive.user.controller;

import com.foodadditive.user.entity.FoodAdditive;
import com.foodadditive.user.service.FoodAdditiveService;
import com.foodadditive.user.common.Result;
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

}
