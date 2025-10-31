package com.foodadditive.admin.controller;

import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.foodadditive.admin.annotation.OperationLog;
import com.foodadditive.admin.entity.Supplier;
import com.foodadditive.admin.service.SupplierService;
import com.foodadditive.admin.common.Result;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.util.StringUtils;
import org.springframework.web.bind.annotation.*;

import java.util.List;

/**
 * 供应商Controller
 * 
 * @author 系统
 * @since 2025-01-01
 */
@RestController
@RequestMapping("/suppliers")
public class SupplierController {

    @Autowired
    private SupplierService supplierService;

    /**
     * 查询供应商列表（支持按名称和联系人查询）
     */
    @GetMapping
    public Result<List<Supplier>> list(
            @RequestParam(required = false) String supplierName,
            @RequestParam(required = false) String contactPerson) {

        QueryWrapper<Supplier> queryWrapper = new QueryWrapper<>();

        // 按供应商名称模糊查询
        if (StringUtils.hasText(supplierName)) {
            queryWrapper.like("supplier_name", supplierName);
        }

        // 按联系人模糊查询
        if (StringUtils.hasText(contactPerson)) {
            queryWrapper.like("contact_person", contactPerson);
        }

        List<Supplier> list = supplierService.list(queryWrapper);
        return Result.success(list);
    }

    /**
     * 根据ID查询供应商
     */
    @GetMapping("/{id}")
    public Result<Supplier> getById(@PathVariable Long id) {
        Supplier entity = supplierService.getById(id);
        return Result.success(entity);
    }

    /**
     * 新增供应商
     */
    @OperationLog(operation = "新增供应商")
    @PostMapping
    public Result<Boolean> save(@RequestBody Supplier entity) {
        boolean result = supplierService.save(entity);
        return Result.success(result);
    }

    /**
     * 更新供应商
     */
    @OperationLog(operation = "更新供应商")
    @PutMapping
    public Result<Boolean> update(@RequestBody Supplier entity) {
        boolean result = supplierService.updateById(entity);
        return Result.success(result);
    }

    /**
     * 删除供应商
     */
    @OperationLog(operation = "删除供应商")
    @DeleteMapping("/{id}")
    public Result<Boolean> delete(@PathVariable Long id) {
        boolean result = supplierService.removeById(id);
        return Result.success(result);
    }

}
