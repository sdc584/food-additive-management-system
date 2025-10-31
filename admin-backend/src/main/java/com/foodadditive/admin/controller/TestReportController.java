package com.foodadditive.admin.controller;

import com.foodadditive.admin.annotation.OperationLog;
import com.foodadditive.admin.entity.TestReport;
import com.foodadditive.admin.service.TestReportService;
import com.foodadditive.admin.common.Result;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.List;

/**
 * 检测报告Controller
 *
 * @author 系统
 * @since 2025-01-01
 */
@RestController
@RequestMapping("/testReports")
public class TestReportController {

    @Autowired
    private TestReportService testReportService;

    /**
     * 查询检测报告列表
     */
    @GetMapping
    public Result<List<TestReport>> list() {
        List<TestReport> list = testReportService.list();
        return Result.success(list);
    }

    /**
     * 根据ID查询检测报告
     */
    @GetMapping("/{id}")
    public Result<TestReport> getById(@PathVariable Long id) {
        TestReport entity = testReportService.getById(id);
        return Result.success(entity);
    }

    /**
     * 新增检测报告
     */
    @OperationLog(operation = "新增检测报告")
    @PostMapping
    public Result<Boolean> save(@RequestBody TestReport entity) {
        boolean result = testReportService.save(entity);
        return Result.success(result);
    }

    /**
     * 更新检测报告
     */
    @OperationLog(operation = "更新检测报告")
    @PutMapping
    public Result<Boolean> update(@RequestBody TestReport entity) {
        boolean result = testReportService.updateById(entity);
        return Result.success(result);
    }

    /**
     * 删除检测报告
     */
    @OperationLog(operation = "删除检测报告")
    @DeleteMapping("/{id}")
    public Result<Boolean> delete(@PathVariable Long id) {
        boolean result = testReportService.removeById(id);
        return Result.success(result);
    }

}
