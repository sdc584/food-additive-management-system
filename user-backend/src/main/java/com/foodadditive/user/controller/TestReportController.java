package com.foodadditive.user.controller;

import com.foodadditive.user.entity.TestReport;
import com.foodadditive.user.service.TestReportService;
import com.foodadditive.user.common.Result;
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

}
