package com.foodadditive.user.controller;

import com.foodadditive.user.entity.UsageRecord;
import com.foodadditive.user.service.UsageRecordService;
import com.foodadditive.user.common.Result;
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
@RequestMapping("/usageRecords")
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

}
