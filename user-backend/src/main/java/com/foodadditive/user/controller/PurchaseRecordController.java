package com.foodadditive.user.controller;

import com.foodadditive.user.entity.PurchaseRecord;
import com.foodadditive.user.service.PurchaseRecordService;
import com.foodadditive.user.common.Result;
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
@RequestMapping("/purchaseRecords")
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

}
