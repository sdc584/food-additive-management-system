package com.foodadditive.admin.controller;

import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.baomidou.mybatisplus.core.metadata.IPage;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.foodadditive.admin.annotation.OperationLog;
import com.foodadditive.admin.entity.FoodAdditive;
import com.foodadditive.admin.entity.UsageRecord;
import com.foodadditive.admin.service.FoodAdditiveService;
import com.foodadditive.admin.service.UsageRecordService;
import com.foodadditive.admin.common.Result;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.util.StringUtils;
import org.springframework.web.bind.annotation.*;

import java.util.List;

/**
 * 使用记录Controller
 * 
 * @author 系统
 * @since 2025-01-01
 */
@RestController
@RequestMapping("/usageRecords")
public class UsageRecordController {

    @Autowired
    private UsageRecordService usageRecordService;

    @Autowired
    private FoodAdditiveService foodAdditiveService;

    /**
     * 分页查询使用记录列表
     */
    @GetMapping
    public Result<IPage<UsageRecord>> list(
            @RequestParam(required = false) String additiveName,
            @RequestParam(required = false) Integer auditStatus,
            @RequestParam(defaultValue = "1") Integer page,
            @RequestParam(defaultValue = "10") Integer size) {

        // 创建分页对象
        Page<UsageRecord> pageParam = new Page<>(page, size);

        // 创建查询条件
        QueryWrapper<UsageRecord> queryWrapper = new QueryWrapper<>();

        // 如果有添加剂名称，先查询添加剂ID
        if (StringUtils.hasText(additiveName)) {
            QueryWrapper<FoodAdditive> additiveWrapper = new QueryWrapper<>();
            additiveWrapper.like("additive_name", additiveName);
            List<FoodAdditive> additives = foodAdditiveService.list(additiveWrapper);
            if (additives.isEmpty()) {
                // 没有找到匹配的添加剂，返回空结果
                return Result.success(new Page<>(page, size));
            }
            List<Long> additiveIds = additives.stream()
                    .map(FoodAdditive::getAdditiveId)
                    .collect(java.util.stream.Collectors.toList());
            queryWrapper.in("additive_id", additiveIds);
        }

        // 按创建时间倒序
        queryWrapper.orderByDesc("create_time");

        // 分页查询
        IPage<UsageRecord> result = usageRecordService.page(pageParam, queryWrapper);

        // 填充添加剂名称
        result.getRecords().forEach(record -> {
            if (record.getAdditiveId() != null) {
                FoodAdditive additive = foodAdditiveService.getById(record.getAdditiveId());
                if (additive != null) {
                    record.setAdditiveName(additive.getAdditiveName());
                }
            }
        });

        return Result.success(result);
    }

    /**
     * 根据ID查询使用记录
     */
    @GetMapping("/{id}")
    public Result<UsageRecord> getById(@PathVariable Long id) {
        UsageRecord entity = usageRecordService.getById(id);
        return Result.success(entity);
    }

    /**
     * 新增使用记录
     */
    @OperationLog(operation = "新增使用记录")
    @PostMapping
    public Result<Boolean> save(@RequestBody UsageRecord entity) {
        try {
            System.out.println("接收到的使用记录数据: " + entity);
            boolean result = usageRecordService.save(entity);
            return Result.success(result);
        } catch (Exception e) {
            e.printStackTrace();
            return Result.error("新增失败: " + e.getMessage());
        }
    }

    /**
     * 更新使用记录
     */
    @OperationLog(operation = "更新使用记录")
    @PutMapping
    public Result<Boolean> update(@RequestBody UsageRecord entity) {
        boolean result = usageRecordService.updateById(entity);
        return Result.success(result);
    }

    /**
     * 删除使用记录
     */
    @OperationLog(operation = "删除使用记录")
    @DeleteMapping("/{id}")
    public Result<Boolean> delete(@PathVariable Long id) {
        boolean result = usageRecordService.removeById(id);
        return Result.success(result);
    }

}
