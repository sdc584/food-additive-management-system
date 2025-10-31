package com.foodadditive.admin.controller;

import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.foodadditive.admin.annotation.OperationLog;
import com.foodadditive.admin.entity.FoodAdditive;
import com.foodadditive.admin.entity.Inventory;
import com.foodadditive.admin.entity.Warning;
import com.foodadditive.admin.service.FoodAdditiveService;
import com.foodadditive.admin.service.InventoryService;
import com.foodadditive.admin.service.OperationLogService;
import com.foodadditive.admin.service.WarningService;
import com.foodadditive.admin.common.Result;
import com.foodadditive.admin.util.JwtUtil;
import io.jsonwebtoken.Claims;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.util.StringUtils;
import org.springframework.web.bind.annotation.*;

import java.math.BigDecimal;
import java.util.Date;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

/**
 * 预警Controller
 * 
 * @author 系统
 * @since 2025-01-01
 */
@RestController
@RequestMapping("/warnings")
public class WarningController {

    @Autowired
    private WarningService warningService;

    @Autowired
    private FoodAdditiveService foodAdditiveService;

    @Autowired
    private InventoryService inventoryService;

    /**
     * 查询预警列表
     * 支持按预警类型、预警级别、状态查询
     */
    @GetMapping
    public Result<List<Warning>> list(
            @RequestParam(required = false) String warningType,
            @RequestParam(required = false) String warningLevel,
            @RequestParam(required = false) String status) {

        QueryWrapper<Warning> queryWrapper = new QueryWrapper<>();

        // 预警类型查询
        if (StringUtils.hasText(warningType)) {
            queryWrapper.eq("warning_type", warningType);
        }

        // 预警级别查询
        if (StringUtils.hasText(warningLevel)) {
            queryWrapper.eq("warning_level", warningLevel);
        }

        // 状态查询
        if (StringUtils.hasText(status)) {
            queryWrapper.eq("status", status);
        }

        // 按预警日期倒序排列
        queryWrapper.orderByDesc("warning_date");

        List<Warning> list = warningService.list(queryWrapper);

        // 填充添加剂名称
        if (!list.isEmpty()) {
            // 获取所有添加剂信息
            List<FoodAdditive> additives = foodAdditiveService.list();
            Map<Long, String> additiveMap = additives.stream()
                    .collect(Collectors.toMap(FoodAdditive::getAdditiveId, FoodAdditive::getAdditiveName));

            // 为每个预警记录设置添加剂名称
            list.forEach(warning -> {
                if (warning.getAdditiveId() != null) {
                    warning.setAdditiveName(additiveMap.get(warning.getAdditiveId()));
                }
            });
        }

        return Result.success(list);
    }

    /**
     * 根据ID查询预警
     */
    @GetMapping("/{id}")
    public Result<Warning> getById(@PathVariable Long id) {
        Warning entity = warningService.getById(id);
        return Result.success(entity);
    }

    /**
     * 新增预警
     */
    @PostMapping
    public Result<Boolean> save(@RequestBody Warning entity) {
        boolean result = warningService.save(entity);
        return Result.success(result);
    }

    /**
     * 通用更新预警（保留原有接口）
     */
    @PutMapping
    public Result<Boolean> update(@RequestBody Warning entity) {
        // 根据状态变化判断操作类型
        Warning oldWarning = warningService.getById(entity.getWarningId());
        if (oldWarning != null) {
            // 如果状态从PENDING变为RESOLVED，记录为"处理预警"
            if ("PENDING".equals(oldWarning.getStatus()) && "RESOLVED".equals(entity.getStatus())) {
                return handleWarning(entity);
            }
            // 如果状态从RESOLVED变为PENDING，记录为"取消处理预警"
            else if ("RESOLVED".equals(oldWarning.getStatus()) && "PENDING".equals(entity.getStatus())) {
                return cancelHandleWarning(entity);
            }
        }
        // 其他情况直接更新
        boolean result = warningService.updateById(entity);
        return Result.success(result);
    }

    /**
     * 处理预警（标记为已解决，并增加库存）
     */
    @OperationLog(operation = "处理预警")
    @PutMapping("/handle")
    @Transactional(rollbackFor = Exception.class)
    public Result<Boolean> handleWarning(@RequestBody Warning entity) {
        try {
            // 1. 获取预警信息
            Warning warning = warningService.getById(entity.getWarningId());
            if (warning == null) {
                return Result.error("预警不存在");
            }

            // 2. 检查是否已处理
            if ("RESOLVED".equals(warning.getStatus())) {
                return Result.error("该预警已处理");
            }

            // 3. 检查添加数量
            if (entity.getAddQuantity() == null || entity.getAddQuantity().compareTo(BigDecimal.ZERO) < 0) {
                return Result.error("添加数量不能小于0");
            }

            // 获取添加剂名称用于日志
            String additiveName = "";
            if (warning.getAdditiveId() != null) {
                FoodAdditive additive = foodAdditiveService.getById(warning.getAdditiveId());
                if (additive != null) {
                    additiveName = additive.getAdditiveName();
                }
            }

            // 4. 增加库存（如果添加数量大于0）
            BigDecimal oldStock = BigDecimal.ZERO;
            BigDecimal newStock = BigDecimal.ZERO;
            if (entity.getAddQuantity().compareTo(BigDecimal.ZERO) > 0) {
                if (entity.getInventoryId() != null) {
                    Inventory inventory = inventoryService.getById(entity.getInventoryId());
                    if (inventory != null) {
                        // 增加库存数量
                        oldStock = inventory.getCurrentStock();
                        newStock = oldStock.add(entity.getAddQuantity());
                        inventory.setCurrentStock(newStock);
                        inventoryService.updateById(inventory);

                        System.out.println("处理预警：库存ID=" + inventory.getInventoryId() +
                                         "，添加数量=" + entity.getAddQuantity() +
                                         "，新库存=" + newStock);
                    } else {
                        return Result.error("库存记录不存在");
                    }
                } else {
                    return Result.error("预警未关联库存记录");
                }
            } else {
                System.out.println("处理预警：添加数量为0，仅标记为已处理");
            }

            // 5. 更新预警状态，并记录添加的数量到备注中
            warning.setStatus("RESOLVED");
            warning.setHandleTime(entity.getHandleTime());

            // 将添加的数量记录到备注中，方便取消时恢复
            String remark = entity.getHandleRemark() != null ? entity.getHandleRemark() : "";
            if (entity.getAddQuantity().compareTo(BigDecimal.ZERO) > 0) {
                remark = "[添加库存:" + entity.getAddQuantity() + "kg] " + remark;
            } else {
                remark = "[仅标记处理，未添加库存] " + remark;
            }
            warning.setHandleRemark(remark);

            boolean result = warningService.updateById(warning);

            // 6. 输出详细日志到控制台
            if (entity.getAddQuantity().compareTo(BigDecimal.ZERO) > 0) {
                System.out.println(String.format("【操作日志】处理预警[%s]，添加库存%skg（%skg → %skg）",
                    additiveName,
                    entity.getAddQuantity(),
                    oldStock,
                    newStock));
            } else {
                System.out.println(String.format("【操作日志】处理预警[%s]，仅标记为已处理，未添加库存", additiveName));
            }

            return Result.success(result);
        } catch (Exception e) {
            e.printStackTrace();
            return Result.error("处理预警失败: " + e.getMessage());
        }
    }

    /**
     * 取消处理预警（恢复为未处理，并减少库存）
     */
    @OperationLog(operation = "取消处理预警")
    @PutMapping("/cancel-handle")
    @Transactional(rollbackFor = Exception.class)
    public Result<Boolean> cancelHandleWarning(@RequestBody Warning entity) {
        try {
            // 1. 获取预警信息
            Warning warning = warningService.getById(entity.getWarningId());
            if (warning == null) {
                return Result.error("预警不存在");
            }

            // 2. 检查是否已处理
            if (!"RESOLVED".equals(warning.getStatus())) {
                return Result.error("该预警未处理，无法取消");
            }

            // 获取添加剂名称用于日志
            String additiveName = "";
            if (warning.getAdditiveId() != null) {
                FoodAdditive additive = foodAdditiveService.getById(warning.getAdditiveId());
                if (additive != null) {
                    additiveName = additive.getAdditiveName();
                }
            }

            // 3. 从备注中提取之前添加的数量
            BigDecimal addedQuantity = extractAddedQuantityFromRemark(warning.getHandleRemark());

            // 4. 减少库存（如果之前添加了库存）
            BigDecimal oldStock = BigDecimal.ZERO;
            BigDecimal newStock = BigDecimal.ZERO;

            if (addedQuantity != null && addedQuantity.compareTo(BigDecimal.ZERO) > 0) {
                if (entity.getInventoryId() != null) {
                    Inventory inventory = inventoryService.getById(entity.getInventoryId());
                    if (inventory != null) {
                        // 检查库存是否足够
                        if (inventory.getCurrentStock().compareTo(addedQuantity) < 0) {
                            return Result.error("当前库存不足，无法取消处理");
                        }

                        // 减少库存数量
                        oldStock = inventory.getCurrentStock();
                        newStock = oldStock.subtract(addedQuantity);
                        inventory.setCurrentStock(newStock);
                        inventoryService.updateById(inventory);

                        System.out.println("取消处理预警：库存ID=" + inventory.getInventoryId() +
                                         "，减少数量=" + addedQuantity +
                                         "，新库存=" + newStock);
                    } else {
                        return Result.error("库存记录不存在");
                    }
                } else {
                    return Result.error("预警未关联库存记录");
                }
            }

            // 5. 更新预警状态
            warning.setStatus("PENDING");
            warning.setHandleTime(null);
            warning.setHandleRemark(null);

            boolean result = warningService.updateById(warning);

            // 6. 输出详细日志到控制台
            if (addedQuantity != null && addedQuantity.compareTo(BigDecimal.ZERO) > 0) {
                System.out.println(String.format("【操作日志】取消处理预警[%s]，减少库存%skg（%skg → %skg）",
                    additiveName,
                    addedQuantity,
                    oldStock,
                    newStock));
            } else {
                System.out.println(String.format("【操作日志】取消处理预警[%s]，之前未添加库存，仅恢复状态", additiveName));
            }

            return Result.success(result);
        } catch (Exception e) {
            e.printStackTrace();
            return Result.error("取消处理失败: " + e.getMessage());
        }
    }

    /**
     * 从备注中提取添加的库存数量
     */
    private BigDecimal extractAddedQuantityFromRemark(String remark) {
        if (remark == null || !remark.contains("[添加库存:")) {
            return null;
        }

        try {
            int start = remark.indexOf("[添加库存:") + 6;
            int end = remark.indexOf("kg]", start);
            if (end > start) {
                String quantityStr = remark.substring(start, end);
                return new BigDecimal(quantityStr);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return null;
    }

    /**
     * 删除预警（关闭预警）
     */
    @OperationLog(operation = "关闭预警")
    @DeleteMapping("/{id}")
    public Result<Boolean> delete(@PathVariable Long id) {
        boolean result = warningService.removeById(id);
        return Result.success(result);
    }

}
