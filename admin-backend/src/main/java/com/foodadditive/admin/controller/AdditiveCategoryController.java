package com.foodadditive.admin.controller;

import com.foodadditive.admin.annotation.OperationLog;
import com.foodadditive.admin.entity.AdditiveCategory;
import com.foodadditive.admin.service.AdditiveCategoryService;
import com.foodadditive.admin.common.Result;
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

    /**
     * 新增添加剂分类
     */
    @OperationLog(operation = "新增添加剂分类")
    @PostMapping
    public Result<Boolean> save(@RequestBody AdditiveCategory entity) {
        boolean result = additiveCategoryService.save(entity);
        return Result.success(result);
    }

    /**
     * 更新添加剂分类
     */
    @OperationLog(operation = "更新添加剂分类")
    @PutMapping
    public Result<Boolean> update(@RequestBody AdditiveCategory entity) {
        boolean result = additiveCategoryService.updateById(entity);
        return Result.success(result);
    }

    /**
     * 删除添加剂分类
     */
    @OperationLog(operation = "删除添加剂分类")
    @DeleteMapping("/{id}")
    public Result<Boolean> delete(@PathVariable Long id) {
        boolean result = additiveCategoryService.removeById(id);
        return Result.success(result);
    }

}
