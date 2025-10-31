package com.foodadditive.admin.controller;

import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.foodadditive.admin.annotation.OperationLog;
import com.foodadditive.admin.common.Result;
import com.foodadditive.admin.entity.FoodAdditive;
import com.foodadditive.admin.entity.Inventory;
import com.foodadditive.admin.entity.Supplier;
import com.foodadditive.admin.entity.Warning;
import com.foodadditive.admin.service.FoodAdditiveService;
import com.foodadditive.admin.service.InventoryService;
import com.foodadditive.admin.service.OperationLogService;
import com.foodadditive.admin.service.SupplierService;
import com.foodadditive.admin.service.WarningService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.time.YearMonth;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * 仪表盘Controller
 * 
 * @author 系统
 * @since 2025-10-31
 */
@RestController
@RequestMapping("/dashboard")
public class DashboardController {

    @Autowired
    private FoodAdditiveService foodAdditiveService;

    @Autowired
    private InventoryService inventoryService;

    @Autowired
    private SupplierService supplierService;

    @Autowired
    private WarningService warningService;

    @Autowired
    private OperationLogService operationLogService;

    /**
     * 获取统计数据
     */
    @GetMapping("/stats")
    public Result<Map<String, Object>> getStats() {
        Map<String, Object> stats = new HashMap<>();
        
        // 添加剂种类数量
        long additiveCount = foodAdditiveService.count();
        stats.put("additiveCount", additiveCount);
        
        // 库存总量（所有库存的当前库存总和）
        List<Inventory> inventories = inventoryService.list();
        BigDecimal totalInventory = inventories.stream()
                .map(Inventory::getCurrentStock)
                .filter(stock -> stock != null)
                .reduce(BigDecimal.ZERO, BigDecimal::add);
        stats.put("inventoryTotal", totalInventory);
        
        // 供应商数量
        long supplierCount = supplierService.count();
        stats.put("supplierCount", supplierCount);
        
        // 本月操作数量
        YearMonth currentMonth = YearMonth.now();
        LocalDateTime startOfMonth = currentMonth.atDay(1).atStartOfDay();
        LocalDateTime endOfMonth = currentMonth.atEndOfMonth().atTime(23, 59, 59);
        
        QueryWrapper<com.foodadditive.admin.entity.OperationLog> queryWrapper = new QueryWrapper<>();
        queryWrapper.between("operation_time", startOfMonth, endOfMonth);
        long operationCount = operationLogService.count(queryWrapper);
        stats.put("operationCount", operationCount);
        
        return Result.success(stats);
    }

    /**
     * 获取最近的操作日志
     */
    @GetMapping("/recent-logs")
    public Result<List<com.foodadditive.admin.entity.OperationLog>> getRecentLogs(
            @RequestParam(required = false, defaultValue = "5") Integer limit) {
        List<com.foodadditive.admin.entity.OperationLog> logs = operationLogService.getRecentLogs(limit);
        return Result.success(logs);
    }
}

