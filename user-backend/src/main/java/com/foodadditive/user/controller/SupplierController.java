package com.foodadditive.user.controller;

import com.foodadditive.user.entity.Supplier;
import com.foodadditive.user.service.SupplierService;
import com.foodadditive.user.common.Result;
import org.springframework.beans.factory.annotation.Autowired;
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
     * 查询供应商列表
     */
    @GetMapping
    public Result<List<Supplier>> list() {
        List<Supplier> list = supplierService.list();
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

}
