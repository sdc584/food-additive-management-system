package com.foodadditive.user.controller;

import com.foodadditive.user.common.Result;
import com.foodadditive.user.service.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.HashMap;
import java.util.Map;

/**
 * 仪表盘统计Controller
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
    private WarningService warningService;

    @Autowired
    private UsageRecordService usageRecordService;

    /**
     * 获取统计数据
     */
    @GetMapping("/stats")
    public Result<Map<String, Object>> getStats() {
        Map<String, Object> stats = new HashMap<>();
        
        // 添加剂种类数量
        long additiveCount = foodAdditiveService.count();
        stats.put("additiveCount", additiveCount);
        
        // 库存总量（所有库存的数量总和）
        Double totalInventory = inventoryService.getTotalQuantity();
        stats.put("inventoryTotal", totalInventory != null ? totalInventory : 0.0);
        
        // 预警信息数量
        long warningCount = warningService.count();
        stats.put("warningCount", warningCount);
        
        // 本月使用记录数量
        long usageCount = usageRecordService.getCurrentMonthCount();
        stats.put("usageCount", usageCount);
        
        return Result.success(stats);
    }
}

