package com.foodadditive.admin.controller;

import com.foodadditive.admin.entity.SysUser;
import com.foodadditive.admin.service.SysUserService;
import com.foodadditive.admin.common.Result;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.List;

/**
 * 用户Controller
 * 
 * @author 系统
 * @since 2025-01-01
 */
@RestController
@RequestMapping("/sysUsers")
public class SysUserController {

    @Autowired
    private SysUserService sysUserService;

    /**
     * 查询用户列表
     */
    @GetMapping
    public Result<List<SysUser>> list() {
        List<SysUser> list = sysUserService.list();
        return Result.success(list);
    }

    /**
     * 根据ID查询用户
     */
    @GetMapping("/{id}")
    public Result<SysUser> getById(@PathVariable Long id) {
        SysUser entity = sysUserService.getById(id);
        return Result.success(entity);
    }

    /**
     * 新增用户
     */
    @PostMapping
    public Result<Boolean> save(@RequestBody SysUser entity) {
        boolean result = sysUserService.save(entity);
        return Result.success(result);
    }

    /**
     * 更新用户
     */
    @PutMapping
    public Result<Boolean> update(@RequestBody SysUser entity) {
        boolean result = sysUserService.updateById(entity);
        return Result.success(result);
    }

    /**
     * 删除用户
     */
    @DeleteMapping("/{id}")
    public Result<Boolean> delete(@PathVariable Long id) {
        boolean result = sysUserService.removeById(id);
        return Result.success(result);
    }

}
