#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
食品添加剂管理系统 - 完整代码生成器
自动生成用户端和管理端的所有Java代码文件
"""

import os
import sys

# 项目基础路径
BASE_PATH = os.path.dirname(os.path.abspath(__file__))

# 用户端和管理端配置
PROJECTS = {
    'user': {
        'name': '用户端',
        'path': os.path.join(BASE_PATH, 'user-backend'),
        'package': 'com.foodadditive.user',
        'port': 8081
    },
    'admin': {
        'name': '管理端',
        'path': os.path.join(BASE_PATH, 'admin-backend'),
        'package': 'com.foodadditive.admin',
        'port': 8082
    }
}

# 实体类配置
ENTITIES = [
    {
        'name': 'SysUser',
        'table': 'sys_user',
        'comment': '用户',
        'id_field': 'userId',
        'id_column': 'user_id'
    },
    {
        'name': 'AdditiveCategory',
        'table': 'additive_category',
        'comment': '添加剂分类',
        'id_field': 'categoryId',
        'id_column': 'category_id'
    },
    {
        'name': 'FoodAdditive',
        'table': 'food_additive',
        'comment': '食品添加剂',
        'id_field': 'additiveId',
        'id_column': 'additive_id'
    },
    {
        'name': 'Supplier',
        'table': 'supplier',
        'comment': '供应商',
        'id_field': 'supplierId',
        'id_column': 'supplier_id'
    },
    {
        'name': 'PurchaseRecord',
        'table': 'purchase_record',
        'comment': '采购记录',
        'id_field': 'purchaseId',
        'id_column': 'purchase_id'
    },
    {
        'name': 'Inventory',
        'table': 'inventory',
        'comment': '库存',
        'id_field': 'inventoryId',
        'id_column': 'inventory_id'
    },
    {
        'name': 'UsageRecord',
        'table': 'usage_record',
        'comment': '使用记录',
        'id_field': 'usageId',
        'id_column': 'usage_id'
    },
    {
        'name': 'TestReport',
        'table': 'test_report',
        'comment': '检测报告',
        'id_field': 'reportId',
        'id_column': 'report_id'
    },
    {
        'name': 'Warning',
        'table': 'warning',
        'comment': '预警',
        'id_field': 'warningId',
        'id_column': 'warning_id'
    },
    {
        'name': 'OperationLog',
        'table': 'operation_log',
        'comment': '操作日志',
        'id_field': 'logId',
        'id_column': 'log_id'
    }
]

def generate_mapper(project_type, entity):
    """生成Mapper接口"""
    config = PROJECTS[project_type]
    package = config['package']
    
    content = f'''package {package}.mapper;

import {package}.entity.{entity['name']};
import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import org.apache.ibatis.annotations.Mapper;

/**
 * {entity['comment']}Mapper接口
 * 
 * @author 系统
 * @since 2025-01-01
 */
@Mapper
public interface {entity['name']}Mapper extends BaseMapper<{entity['name']}> {{

}}
'''
    return content

def generate_service(project_type, entity):
    """生成Service接口"""
    config = PROJECTS[project_type]
    package = config['package']
    
    content = f'''package {package}.service;

import {package}.entity.{entity['name']};
import com.baomidou.mybatisplus.extension.service.IService;

/**
 * {entity['comment']}Service接口
 * 
 * @author 系统
 * @since 2025-01-01
 */
public interface {entity['name']}Service extends IService<{entity['name']}> {{

}}
'''
    return content

def generate_service_impl(project_type, entity):
    """生成Service实现类"""
    config = PROJECTS[project_type]
    package = config['package']
    
    content = f'''package {package}.service.impl;

import {package}.entity.{entity['name']};
import {package}.mapper.{entity['name']}Mapper;
import {package}.service.{entity['name']}Service;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import org.springframework.stereotype.Service;

/**
 * {entity['comment']}Service实现类
 * 
 * @author 系统
 * @since 2025-01-01
 */
@Service
public class {entity['name']}ServiceImpl extends ServiceImpl<{entity['name']}Mapper, {entity['name']}> implements {entity['name']}Service {{

}}
'''
    return content

def generate_controller(project_type, entity):
    """生成Controller类"""
    config = PROJECTS[project_type]
    package = config['package']
    name_lower = entity['name'][0].lower() + entity['name'][1:]
    
    # 用户端只读，管理端完整CRUD
    if project_type == 'user':
        methods = '''
    /**
     * 查询{comment}列表
     */
    @GetMapping
    public Result<List<{name}>> list() {{
        List<{name}> list = {name_lower}Service.list();
        return Result.success(list);
    }}

    /**
     * 根据ID查询{comment}
     */
    @GetMapping("/{{id}}")
    public Result<{name}> getById(@PathVariable Long id) {{
        {name} entity = {name_lower}Service.getById(id);
        return Result.success(entity);
    }}
'''.format(comment=entity['comment'], name=entity['name'], name_lower=name_lower)
    else:
        methods = '''
    /**
     * 查询{comment}列表
     */
    @GetMapping
    public Result<List<{name}>> list() {{
        List<{name}> list = {name_lower}Service.list();
        return Result.success(list);
    }}

    /**
     * 根据ID查询{comment}
     */
    @GetMapping("/{{id}}")
    public Result<{name}> getById(@PathVariable Long id) {{
        {name} entity = {name_lower}Service.getById(id);
        return Result.success(entity);
    }}

    /**
     * 新增{comment}
     */
    @PostMapping
    public Result<Boolean> save(@RequestBody {name} entity) {{
        boolean result = {name_lower}Service.save(entity);
        return Result.success(result);
    }}

    /**
     * 更新{comment}
     */
    @PutMapping
    public Result<Boolean> update(@RequestBody {name} entity) {{
        boolean result = {name_lower}Service.updateById(entity);
        return Result.success(result);
    }}

    /**
     * 删除{comment}
     */
    @DeleteMapping("/{{id}}")
    public Result<Boolean> delete(@PathVariable Long id) {{
        boolean result = {name_lower}Service.removeById(id);
        return Result.success(result);
    }}
'''.format(comment=entity['comment'], name=entity['name'], name_lower=name_lower)
    
    content = f'''package {package}.controller;

import {package}.entity.{entity['name']};
import {package}.service.{entity['name']}Service;
import {package}.common.Result;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.List;

/**
 * {entity['comment']}Controller
 * 
 * @author 系统
 * @since 2025-01-01
 */
@RestController
@RequestMapping("/{name_lower}s")
public class {entity['name']}Controller {{

    @Autowired
    private {entity['name']}Service {name_lower}Service;
{methods}
}}
'''
    return content

def write_file(file_path, content):
    """写入文件"""
    os.makedirs(os.path.dirname(file_path), exist_ok=True)
    with open(file_path, 'w', encoding='utf-8') as f:
        f.write(content)
    print(f"✅ 已生成: {file_path}")

def generate_project_code(project_type):
    """生成项目代码"""
    config = PROJECTS[project_type]
    print(f"\n{'='*50}")
    print(f"开始生成 {config['name']} 代码...")
    print(f"{'='*50}\n")
    
    base_path = config['path']
    package_path = config['package'].replace('.', '/')
    src_path = os.path.join(base_path, 'src', 'main', 'java', package_path)
    
    for entity in ENTITIES:
        # 生成Mapper
        mapper_path = os.path.join(src_path, 'mapper', f"{entity['name']}Mapper.java")
        write_file(mapper_path, generate_mapper(project_type, entity))
        
        # 生成Service
        service_path = os.path.join(src_path, 'service', f"{entity['name']}Service.java")
        write_file(service_path, generate_service(project_type, entity))
        
        # 生成ServiceImpl
        service_impl_path = os.path.join(src_path, 'service', 'impl', f"{entity['name']}ServiceImpl.java")
        write_file(service_impl_path, generate_service_impl(project_type, entity))
        
        # 生成Controller
        controller_path = os.path.join(src_path, 'controller', f"{entity['name']}Controller.java")
        write_file(controller_path, generate_controller(project_type, entity))
    
    print(f"\n{'='*50}")
    print(f"{config['name']} 代码生成完成！")
    print(f"共生成 {len(ENTITIES) * 4} 个文件")
    print(f"{'='*50}\n")

def main():
    print("="*50)
    print("食品添加剂管理系统 - 代码生成器")
    print("="*50)
    print("\n请选择要生成的项目:")
    print("1. 用户端后端 (user-backend)")
    print("2. 管理端后端 (admin-backend)")
    print("3. 全部生成")
    print("0. 退出")
    
    choice = input("\n请输入选项 (0-3): ").strip()
    
    if choice == '1':
        generate_project_code('user')
    elif choice == '2':
        generate_project_code('admin')
    elif choice == '3':
        generate_project_code('user')
        generate_project_code('admin')
    elif choice == '0':
        print("已退出")
        return
    else:
        print("无效选项")
        return
    
    print("\n✅ 所有代码生成完成！")
    print("\n下一步:")
    print("1. 使用IDEA打开项目")
    print("2. 等待Maven依赖下载完成")
    print("3. 运行Application启动类")
    print("4. 访问 http://localhost:8081 (用户端) 或 http://localhost:8082 (管理端)")

if __name__ == '__main__':
    main()

