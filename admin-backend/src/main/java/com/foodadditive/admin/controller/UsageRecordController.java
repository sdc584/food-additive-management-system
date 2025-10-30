package com.foodadditive.admin.controller;

import com.foodadditive.admin.entity.UsageRecord;
import com.foodadditive.admin.service.UsageRecordService;
import com.foodadditive.admin.common.Result;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.List;

/**
 * 使用记录Controller
 * 
 * @author 系统
 * @since 2025-01-01
 */
@RestController
@RequestMapping("/api/admin/usageRecords")
public class UsageRecordController {

    @Autowired
    private UsageRecordService usageRecordService;

    /**
     * 查询使用记录列表
     */
    @GetMapping
    public Result<List<UsageRecord>> list() {
        List<UsageRecord> list = usageRecordService.list();
        return Result.success(list);
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
    @PostMapping
    public Result<Boolean> save(@RequestBody UsageRecord entity) {
        boolean result = usageRecordService.save(entity);
        return Result.success(result);
    }

    /**
     * 更新使用记录
     */
    @PutMapping
    public Result<Boolean> update(@RequestBody UsageRecord entity) {
        boolean result = usageRecordService.updateById(entity);
        return Result.success(result);
    }

    /**
     * 删除使用记录
     */
    @DeleteMapping("/{id}")
    public Result<Boolean> delete(@PathVariable Long id) {
        boolean result = usageRecordService.removeById(id);
        return Result.success(result);
    }

}
