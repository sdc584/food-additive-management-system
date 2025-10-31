package com.foodadditive.admin.controller;

import com.foodadditive.admin.annotation.OperationLog;
import com.foodadditive.admin.entity.FoodAdditive;
import com.foodadditive.admin.entity.PurchaseRecord;
import com.foodadditive.admin.entity.Supplier;
import com.foodadditive.admin.service.FoodAdditiveService;
import com.foodadditive.admin.service.PurchaseRecordService;
import com.foodadditive.admin.service.SupplierService;
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
@RequestMapping("/purchaseRecords")
public class PurchaseRecordController {

    @Autowired
    private PurchaseRecordService purchaseRecordService;

    @Autowired
    private FoodAdditiveService foodAdditiveService;

    @Autowired
    private SupplierService supplierService;

    /**
     * 查询采购记录列表
     */
    @GetMapping
    public Result<List<PurchaseRecord>> list() {
        List<PurchaseRecord> list = purchaseRecordService.list();

        // 填充添加剂名称和供应商名称
        list.forEach(record -> {
            if (record.getAdditiveId() != null) {
                FoodAdditive additive = foodAdditiveService.getById(record.getAdditiveId());
                if (additive != null) {
                    record.setAdditiveName(additive.getAdditiveName());
                }
            }
            if (record.getSupplierId() != null) {
                Supplier supplier = supplierService.getById(record.getSupplierId());
                if (supplier != null) {
                    record.setSupplierName(supplier.getSupplierName());
                }
            }
        });

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

    /**
     * 审核采购记录（通过）
     */
    @OperationLog(operation = "审核采购记录-通过")
    @PutMapping("/{id}/approve")
    public Result<Boolean> approve(@PathVariable Long id) {
        PurchaseRecord record = purchaseRecordService.getById(id);
        if (record == null) {
            return Result.error("采购记录不存在");
        }
        if (!"PENDING".equals(record.getStatus())) {
            return Result.error("该采购记录已审核");
        }
        record.setStatus("APPROVED"); // 已审核
        boolean result = purchaseRecordService.updateById(record);
        return Result.success(result);
    }

    /**
     * 审核采购记录（拒绝）
     */
    @OperationLog(operation = "审核采购记录-拒绝")
    @PutMapping("/{id}/reject")
    public Result<Boolean> reject(@PathVariable Long id, @RequestParam(required = false) String reason) {
        PurchaseRecord record = purchaseRecordService.getById(id);
        if (record == null) {
            return Result.error("采购记录不存在");
        }
        if (!"PENDING".equals(record.getStatus())) {
            return Result.error("该采购记录已审核");
        }
        // 可以在remark中记录拒绝原因
        if (reason != null && !reason.isEmpty()) {
            record.setRemark((record.getRemark() != null ? record.getRemark() + "; " : "") + "拒绝原因: " + reason);
        }
        record.setStatus("CANCELLED"); // 已取消
        boolean result = purchaseRecordService.updateById(record);
        return Result.success(result);
    }

}
