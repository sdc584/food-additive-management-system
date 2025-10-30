package com.foodadditive.admin.controller;

import com.foodadditive.admin.entity.PurchaseRecord;
import com.foodadditive.admin.service.PurchaseRecordService;
import com.foodadditive.admin.common.Result;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.List;

/**
 * 采购记录Controller
 * 
 * @author 系统
 * @since 2025-01-01
 */
@RestController
@RequestMapping("/api/admin/purchaseRecords")
public class PurchaseRecordController {

    @Autowired
    private PurchaseRecordService purchaseRecordService;

    /**
     * 查询采购记录列表
     */
    @GetMapping
    public Result<List<PurchaseRecord>> list() {
        List<PurchaseRecord> list = purchaseRecordService.list();
        return Result.success(list);
    }

    /**
     * 根据ID查询采购记录
     */
    @GetMapping("/{id}")
    public Result<PurchaseRecord> getById(@PathVariable Long id) {
        PurchaseRecord entity = purchaseRecordService.getById(id);
        return Result.success(entity);
    }

    /**
     * 新增采购记录
     */
    @PostMapping
    public Result<Boolean> save(@RequestBody PurchaseRecord entity) {
        boolean result = purchaseRecordService.save(entity);
        return Result.success(result);
    }

    /**
     * 更新采购记录
     */
    @PutMapping
    public Result<Boolean> update(@RequestBody PurchaseRecord entity) {
        boolean result = purchaseRecordService.updateById(entity);
        return Result.success(result);
    }

    /**
     * 删除采购记录
     */
    @DeleteMapping("/{id}")
    public Result<Boolean> delete(@PathVariable Long id) {
        boolean result = purchaseRecordService.removeById(id);
        return Result.success(result);
    }

}
