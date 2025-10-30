package com.foodadditive.user.controller;

import com.foodadditive.user.entity.AdditiveCategory;
import com.foodadditive.user.service.AdditiveCategoryService;
import com.foodadditive.user.common.Result;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.List;

/**
 * 添加剂分类Controller
 * 
 * @author 系统
 * @since 2025-01-01
 */
@RestController
@RequestMapping("/additiveCategories")
public class AdditiveCategoryController {

    @Autowired
    private AdditiveCategoryService additiveCategoryService;

    /**
     * 查询添加剂分类列表
     */
    @GetMapping
    public Result<List<AdditiveCategory>> list() {
        List<AdditiveCategory> list = additiveCategoryService.list();
        return Result.success(list);
    }

    /**
     * 根据ID查询添加剂分类
     */
    @GetMapping("/{id}")
    public Result<AdditiveCategory> getById(@PathVariable Long id) {
        AdditiveCategory entity = additiveCategoryService.getById(id);
        return Result.success(entity);
    }

}
