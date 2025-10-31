package com.foodadditive.admin.controller;

import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.foodadditive.admin.annotation.OperationLog;
import com.foodadditive.admin.entity.AdditiveCategory;
import com.foodadditive.admin.entity.FoodAdditive;
import com.foodadditive.admin.service.AdditiveCategoryService;
import com.foodadditive.admin.service.FoodAdditiveService;
import com.foodadditive.admin.common.Result;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.util.StringUtils;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

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

    @Autowired
    private AdditiveCategoryService additiveCategoryService;

    /**
     * 查询食品添加剂列表
     * 支持按添加剂名称、添加剂编号、分类ID、状态查询
     */
    @GetMapping
    public Result<List<FoodAdditive>> list(
            @RequestParam(required = false) String additiveName,
            @RequestParam(required = false) String additiveCode,
            @RequestParam(required = false) Long categoryId,
            @RequestParam(required = false) Integer status) {

        QueryWrapper<FoodAdditive> queryWrapper = new QueryWrapper<>();

        // 添加剂名称模糊查询
        if (StringUtils.hasText(additiveName)) {
            queryWrapper.like("additive_name", additiveName);
        }

        // 添加剂编号模糊查询
        if (StringUtils.hasText(additiveCode)) {
            queryWrapper.like("additive_code", additiveCode);
        }

        // 分类ID精确查询
        if (categoryId != null) {
            queryWrapper.eq("category_id", categoryId);
        }

        // 状态精确查询
        if (status != null) {
            queryWrapper.eq("status", status);
        }

        List<FoodAdditive> list = foodAdditiveService.list(queryWrapper);

        // 填充分类名称
        if (!list.isEmpty()) {
            // 获取所有分类信息
            List<AdditiveCategory> categories = additiveCategoryService.list();
            Map<Long, String> categoryMap = categories.stream()
                    .collect(Collectors.toMap(AdditiveCategory::getCategoryId, AdditiveCategory::getCategoryName));

            // 为每个添加剂设置分类名称
            list.forEach(additive -> {
                if (additive.getCategoryId() != null) {
                    additive.setCategoryName(categoryMap.get(additive.getCategoryId()));
                }
            });
        }

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
    @OperationLog(operation = "新增食品添加剂")
    @PostMapping
    public Result<Boolean> save(@RequestBody FoodAdditive entity) {
        boolean result = foodAdditiveService.save(entity);
        return Result.success(result);
    }

    /**
     * 更新食品添加剂
     */
    @OperationLog(operation = "更新食品添加剂")
    @PutMapping
    public Result<Boolean> update(@RequestBody FoodAdditive entity) {
        boolean result = foodAdditiveService.updateById(entity);
        return Result.success(result);
    }

    /**
     * 删除食品添加剂
     */
    @OperationLog(operation = "删除食品添加剂")
    @DeleteMapping("/{id}")
    public Result<Boolean> delete(@PathVariable Long id) {
        boolean result = foodAdditiveService.removeById(id);
        return Result.success(result);
    }

}
