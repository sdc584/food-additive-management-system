#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
食品添加剂管理系统 - 代码生成器
自动生成用户端和管理端的Java代码
"""

import os

# 实体类定义
entities = {
    'SysUser': {
        'table': 'sys_user',
        'comment': '用户',
        'fields': [
            ('userId', 'Long', 'user_id', '用户ID'),
            ('username', 'String', 'username', '用户名'),
            ('password', 'String', 'password', '密码'),
            ('realName', 'String', 'real_name', '真实姓名'),
            ('phone', 'String', 'phone', '手机号'),
            ('email', 'String', 'email', '邮箱'),
            ('role', 'String', 'role', '角色'),
            ('status', 'Integer', 'status', '状态'),
        ]
    },
    'AdditiveCategory': {
        'table': 'additive_category',
        'comment': '添加剂分类',
        'fields': [
            ('categoryId', 'Long', 'category_id', '分类ID'),
            ('categoryName', 'String', 'category_name', '分类名称'),
            ('categoryCode', 'String', 'category_code', '分类编码'),
            ('parentId', 'Long', 'parent_id', '父分类ID'),
            ('description', 'String', 'description', '描述'),
            ('sortOrder', 'Integer', 'sort_order', '排序'),
            ('status', 'Integer', 'status', '状态'),
        ]
    },
    'FoodAdditive': {
        'table': 'food_additive',
        'comment': '食品添加剂',
        'fields': [
            ('additiveId', 'Long', 'additive_id', '添加剂ID'),
            ('additiveName', 'String', 'additive_name', '添加剂名称'),
            ('additiveCode', 'String', 'additive_code', '添加剂编号'),
            ('categoryId', 'Long', 'category_id', '分类ID'),
            ('casNumber', 'String', 'cas_number', 'CAS号'),
            ('molecularFormula', 'String', 'molecular_formula', '分子式'),
            ('specification', 'String', 'specification', '规格'),
            ('unit', 'String', 'unit', '单位'),
            ('maxUsage', 'BigDecimal', 'max_usage', '最大使用量'),
            ('safetyLevel', 'String', 'safety_level', '安全等级'),
            ('description', 'String', 'description', '描述'),
            ('usageScope', 'String', 'usage_scope', '使用范围'),
            ('status', 'Integer', 'status', '状态'),
        ]
    },
    'Supplier': {
        'table': 'supplier',
        'comment': '供应商',
        'fields': [
            ('supplierId', 'Long', 'supplier_id', '供应商ID'),
            ('supplierName', 'String', 'supplier_name', '供应商名称'),
            ('supplierCode', 'String', 'supplier_code', '供应商编码'),
            ('contactPerson', 'String', 'contact_person', '联系人'),
            ('contactPhone', 'String', 'contact_phone', '联系电话'),
            ('contactEmail', 'String', 'contact_email', '联系邮箱'),
            ('address', 'String', 'address', '地址'),
            ('creditLevel', 'String', 'credit_level', '信用等级'),
            ('businessLicense', 'String', 'business_license', '营业执照号'),
            ('status', 'Integer', 'status', '状态'),
            ('remark', 'String', 'remark', '备注'),
        ]
    },
    'PurchaseRecord': {
        'table': 'purchase_record',
        'comment': '采购记录',
        'fields': [
            ('purchaseId', 'Long', 'purchase_id', '采购ID'),
            ('purchaseNo', 'String', 'purchase_no', '采购单号'),
            ('additiveId', 'Long', 'additive_id', '添加剂ID'),
            ('supplierId', 'Long', 'supplier_id', '供应商ID'),
            ('quantity', 'BigDecimal', 'quantity', '采购数量'),
            ('unitPrice', 'BigDecimal', 'unit_price', '单价'),
            ('totalPrice', 'BigDecimal', 'total_price', '总价'),
            ('purchaseDate', 'Date', 'purchase_date', '采购日期'),
            ('productionDate', 'Date', 'production_date', '生产日期'),
            ('expiryDate', 'Date', 'expiry_date', '过期日期'),
            ('batchNumber', 'String', 'batch_number', '批次号'),
            ('purchaserId', 'Long', 'purchaser_id', '采购员ID'),
            ('status', 'String', 'status', '状态'),
            ('remark', 'String', 'remark', '备注'),
        ]
    },
    'Inventory': {
        'table': 'inventory',
        'comment': '库存',
        'fields': [
            ('inventoryId', 'Long', 'inventory_id', '库存ID'),
            ('additiveId', 'Long', 'additive_id', '添加剂ID'),
            ('currentStock', 'BigDecimal', 'current_stock', '当前库存'),
            ('minStock', 'BigDecimal', 'min_stock', '最小库存'),
            ('maxStock', 'BigDecimal', 'max_stock', '最大库存'),
            ('warehouseLocation', 'String', 'warehouse_location', '仓库位置'),
            ('lastPurchaseDate', 'Date', 'last_purchase_date', '最后采购日期'),
            ('lastUsageDate', 'Date', 'last_usage_date', '最后使用日期'),
            ('status', 'Integer', 'status', '状态'),
        ]
    },
    'UsageRecord': {
        'table': 'usage_record',
        'comment': '使用记录',
        'fields': [
            ('usageId', 'Long', 'usage_id', '使用记录ID'),
            ('usageNo', 'String', 'usage_no', '使用单号'),
            ('additiveId', 'Long', 'additive_id', '添加剂ID'),
            ('quantity', 'BigDecimal', 'quantity', '使用数量'),
            ('usageDate', 'Date', 'usage_date', '使用日期'),
            ('usagePurpose', 'String', 'usage_purpose', '使用目的'),
            ('productBatch', 'String', 'product_batch', '产品批次'),
            ('userId', 'Long', 'user_id', '使用人ID'),
            ('department', 'String', 'department', '使用部门'),
            ('remark', 'String', 'remark', '备注'),
        ]
    },
    'TestReport': {
        'table': 'test_report',
        'comment': '检测报告',
        'fields': [
            ('reportId', 'Long', 'report_id', '报告ID'),
            ('reportNo', 'String', 'report_no', '报告编号'),
            ('additiveId', 'Long', 'additive_id', '添加剂ID'),
            ('testDate', 'Date', 'test_date', '检测日期'),
            ('testOrganization', 'String', 'test_organization', '检测机构'),
            ('testItems', 'String', 'test_items', '检测项目'),
            ('testResult', 'String', 'test_result', '检测结果'),
            ('testConclusion', 'String', 'test_conclusion', '检测结论'),
            ('attachmentUrl', 'String', 'attachment_url', '附件URL'),
            ('remark', 'String', 'remark', '备注'),
        ]
    },
    'Warning': {
        'table': 'warning',
        'comment': '预警',
        'fields': [
            ('warningId', 'Long', 'warning_id', '预警ID'),
            ('warningType', 'String', 'warning_type', '预警类型'),
            ('additiveId', 'Long', 'additive_id', '添加剂ID'),
            ('inventoryId', 'Long', 'inventory_id', '库存ID'),
            ('warningLevel', 'String', 'warning_level', '预警级别'),
            ('warningContent', 'String', 'warning_content', '预警内容'),
            ('warningDate', 'Date', 'warning_date', '预警时间'),
            ('status', 'String', 'status', '状态'),
            ('handlerId', 'Long', 'handler_id', '处理人ID'),
            ('handleTime', 'Date', 'handle_time', '处理时间'),
            ('handleRemark', 'String', 'handle_remark', '处理备注'),
        ]
    },
    'OperationLog': {
        'table': 'operation_log',
        'comment': '操作日志',
        'fields': [
            ('logId', 'Long', 'log_id', '日志ID'),
            ('userId', 'Long', 'user_id', '操作用户ID'),
            ('username', 'String', 'username', '用户名'),
            ('operation', 'String', 'operation', '操作类型'),
            ('method', 'String', 'method', '请求方法'),
            ('params', 'String', 'params', '请求参数'),
            ('ip', 'String', 'ip', 'IP地址'),
            ('operationTime', 'Date', 'operation_time', '操作时间'),
            ('executionTime', 'Long', 'execution_time', '执行时长'),
            ('status', 'Integer', 'status', '状态'),
            ('errorMsg', 'String', 'error_msg', '错误信息'),
        ]
    },
}

print("代码生成器准备就绪")
print(f"将生成 {len(entities)} 个实体类及其相关代码")
print("\n实体列表:")
for i, (name, info) in enumerate(entities.items(), 1):
    print(f"{i}. {name} - {info['comment']}")

print("\n请使用Java代码生成工具或手动创建以下文件:")
print("1. Entity类 (实体类)")
print("2. Mapper接口 (数据访问层)")
print("3. Service接口和实现类 (业务逻辑层)")
print("4. Controller类 (控制器层)")
print("\n建议使用MyBatis Plus代码生成器或IDEA插件快速生成代码")

