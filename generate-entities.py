#!/usr/bin/env python3
# -*- coding: utf-8 -*-

"""
食品添加剂管理系统 - Entity类生成器
自动生成所有Entity类
"""

import os

# Entity类定义
ENTITIES = {
    'SysUser': {
        'table': 'sys_user',
        'comment': '用户实体类',
        'fields': [
            ('userId', 'Long', 'user_id', '用户ID', 'AUTO'),
            ('username', 'String', 'username', '用户名', None),
            ('password', 'String', 'password', '密码', None),
            ('realName', 'String', 'real_name', '真实姓名', None),
            ('phone', 'String', 'phone', '手机号', None),
            ('email', 'String', 'email', '邮箱', None),
            ('role', 'String', 'role', '角色：ADMIN-管理员，USER-普通用户', None),
            ('status', 'Integer', 'status', '状态：1-启用，0-禁用', None),
            ('createTime', 'Date', 'create_time', '创建时间', 'INSERT'),
            ('updateTime', 'Date', 'update_time', '更新时间', 'INSERT_UPDATE'),
        ]
    },
    'AdditiveCategory': {
        'table': 'additive_category',
        'comment': '添加剂分类实体类',
        'fields': [
            ('categoryId', 'Long', 'category_id', '分类ID', 'AUTO'),
            ('categoryName', 'String', 'category_name', '分类名称', None),
            ('categoryCode', 'String', 'category_code', '分类编码', None),
            ('parentId', 'Long', 'parent_id', '父分类ID', None),
            ('description', 'String', 'description', '描述', None),
            ('sortOrder', 'Integer', 'sort_order', '排序', None),
            ('status', 'Integer', 'status', '状态：1-启用，0-禁用', None),
            ('createTime', 'Date', 'create_time', '创建时间', 'INSERT'),
            ('updateTime', 'Date', 'update_time', '更新时间', 'INSERT_UPDATE'),
        ]
    },
    'FoodAdditive': {
        'table': 'food_additive',
        'comment': '食品添加剂实体类',
        'fields': [
            ('additiveId', 'Long', 'additive_id', '添加剂ID', 'AUTO'),
            ('additiveName', 'String', 'additive_name', '添加剂名称', None),
            ('additiveCode', 'String', 'additive_code', '添加剂编号', None),
            ('categoryId', 'Long', 'category_id', '分类ID', None),
            ('casNumber', 'String', 'cas_number', 'CAS号', None),
            ('molecularFormula', 'String', 'molecular_formula', '分子式', None),
            ('specification', 'String', 'specification', '规格', None),
            ('unit', 'String', 'unit', '单位', None),
            ('maxUsage', 'BigDecimal', 'max_usage', '最大使用量(g/kg)', None),
            ('safetyLevel', 'String', 'safety_level', '安全等级', None),
            ('description', 'String', 'description', '描述', None),
            ('usageScope', 'String', 'usage_scope', '使用范围', None),
            ('status', 'Integer', 'status', '状态：1-启用，0-禁用', None),
            ('createTime', 'Date', 'create_time', '创建时间', 'INSERT'),
            ('updateTime', 'Date', 'update_time', '更新时间', 'INSERT_UPDATE'),
        ]
    },
    'Supplier': {
        'table': 'supplier',
        'comment': '供应商实体类',
        'fields': [
            ('supplierId', 'Long', 'supplier_id', '供应商ID', 'AUTO'),
            ('supplierName', 'String', 'supplier_name', '供应商名称', None),
            ('supplierCode', 'String', 'supplier_code', '供应商编码', None),
            ('contactPerson', 'String', 'contact_person', '联系人', None),
            ('contactPhone', 'String', 'contact_phone', '联系电话', None),
            ('contactEmail', 'String', 'contact_email', '联系邮箱', None),
            ('address', 'String', 'address', '地址', None),
            ('creditLevel', 'String', 'credit_level', '信用等级', None),
            ('businessLicense', 'String', 'business_license', '营业执照号', None),
            ('status', 'Integer', 'status', '状态：1-启用，0-禁用', None),
            ('remark', 'String', 'remark', '备注', None),
            ('createTime', 'Date', 'create_time', '创建时间', 'INSERT'),
            ('updateTime', 'Date', 'update_time', '更新时间', 'INSERT_UPDATE'),
        ]
    },
    'PurchaseRecord': {
        'table': 'purchase_record',
        'comment': '采购记录实体类',
        'fields': [
            ('recordId', 'Long', 'record_id', '记录ID', 'AUTO'),
            ('purchaseNo', 'String', 'purchase_no', '采购单号', None),
            ('additiveId', 'Long', 'additive_id', '添加剂ID', None),
            ('supplierId', 'Long', 'supplier_id', '供应商ID', None),
            ('quantity', 'BigDecimal', 'quantity', '采购数量', None),
            ('unitPrice', 'BigDecimal', 'unit_price', '单价', None),
            ('totalPrice', 'BigDecimal', 'total_price', '总价', None),
            ('purchaseDate', 'Date', 'purchase_date', '采购日期', None),
            ('productionDate', 'Date', 'production_date', '生产日期', None),
            ('expiryDate', 'Date', 'expiry_date', '过期日期', None),
            ('batchNo', 'String', 'batch_no', '批次号', None),
            ('purchaser', 'Long', 'purchaser', '采购员ID', None),
            ('status', 'Integer', 'status', '状态：0-待审核，1-已审核，2-已入库', None),
            ('remark', 'String', 'remark', '备注', None),
            ('createTime', 'Date', 'create_time', '创建时间', 'INSERT'),
            ('updateTime', 'Date', 'update_time', '更新时间', 'INSERT_UPDATE'),
        ]
    },
    'Inventory': {
        'table': 'inventory',
        'comment': '库存实体类',
        'fields': [
            ('inventoryId', 'Long', 'inventory_id', '库存ID', 'AUTO'),
            ('additiveId', 'Long', 'additive_id', '添加剂ID', None),
            ('currentStock', 'BigDecimal', 'current_stock', '当前库存', None),
            ('minStock', 'BigDecimal', 'min_stock', '最小库存', None),
            ('maxStock', 'BigDecimal', 'max_stock', '最大库存', None),
            ('warehouseLocation', 'String', 'warehouse_location', '仓库位置', None),
            ('lastPurchaseDate', 'Date', 'last_purchase_date', '最后采购日期', None),
            ('lastUsageDate', 'Date', 'last_usage_date', '最后使用日期', None),
            ('status', 'Integer', 'status', '状态：1-正常，0-停用', None),
            ('createTime', 'Date', 'create_time', '创建时间', 'INSERT'),
            ('updateTime', 'Date', 'update_time', '更新时间', 'INSERT_UPDATE'),
        ]
    },
    'UsageRecord': {
        'table': 'usage_record',
        'comment': '使用记录实体类',
        'fields': [
            ('recordId', 'Long', 'record_id', '记录ID', 'AUTO'),
            ('usageNo', 'String', 'usage_no', '使用单号', None),
            ('additiveId', 'Long', 'additive_id', '添加剂ID', None),
            ('usageQuantity', 'BigDecimal', 'usage_quantity', '使用数量', None),
            ('usageDate', 'Date', 'usage_date', '使用日期', None),
            ('usagePurpose', 'String', 'usage_purpose', '使用目的', None),
            ('productBatch', 'String', 'product_batch', '产品批次', None),
            ('operator', 'Long', 'operator', '操作员ID', None),
            ('status', 'Integer', 'status', '状态：0-待审核，1-已审核', None),
            ('remark', 'String', 'remark', '备注', None),
            ('createTime', 'Date', 'create_time', '创建时间', 'INSERT'),
            ('updateTime', 'Date', 'update_time', '更新时间', 'INSERT_UPDATE'),
        ]
    },
    'TestReport': {
        'table': 'test_report',
        'comment': '检测报告实体类',
        'fields': [
            ('reportId', 'Long', 'report_id', '报告ID', 'AUTO'),
            ('reportNo', 'String', 'report_no', '报告编号', None),
            ('additiveId', 'Long', 'additive_id', '添加剂ID', None),
            ('testDate', 'Date', 'test_date', '检测日期', None),
            ('testOrganization', 'String', 'test_organization', '检测机构', None),
            ('testResult', 'String', 'test_result', '检测结果：合格/不合格', None),
            ('testItems', 'String', 'test_items', '检测项目', None),
            ('reportFile', 'String', 'report_file', '报告文件路径', None),
            ('remark', 'String', 'remark', '备注', None),
            ('createTime', 'Date', 'create_time', '创建时间', 'INSERT'),
            ('updateTime', 'Date', 'update_time', '更新时间', 'INSERT_UPDATE'),
        ]
    },
    'Warning': {
        'table': 'warning',
        'comment': '预警实体类',
        'fields': [
            ('warningId', 'Long', 'warning_id', '预警ID', 'AUTO'),
            ('warningType', 'String', 'warning_type', '预警类型：STOCK-库存预警，EXPIRY-过期预警', None),
            ('additiveId', 'Long', 'additive_id', '添加剂ID', None),
            ('warningLevel', 'String', 'warning_level', '预警级别：HIGH-高，MEDIUM-中，LOW-低', None),
            ('warningContent', 'String', 'warning_content', '预警内容', None),
            ('warningDate', 'Date', 'warning_date', '预警日期', None),
            ('status', 'Integer', 'status', '状态：0-未处理，1-已处理', None),
            ('handler', 'Long', 'handler', '处理人ID', None),
            ('handleTime', 'Date', 'handle_time', '处理时间', None),
            ('handleRemark', 'String', 'handle_remark', '处理备注', None),
            ('createTime', 'Date', 'create_time', '创建时间', 'INSERT'),
            ('updateTime', 'Date', 'update_time', '更新时间', 'INSERT_UPDATE'),
        ]
    },
    'OperationLog': {
        'table': 'operation_log',
        'comment': '操作日志实体类',
        'fields': [
            ('logId', 'Long', 'log_id', '日志ID', 'AUTO'),
            ('userId', 'Long', 'user_id', '用户ID', None),
            ('username', 'String', 'username', '用户名', None),
            ('operation', 'String', 'operation', '操作类型', None),
            ('method', 'String', 'method', '请求方法', None),
            ('params', 'String', 'params', '请求参数', None),
            ('ip', 'String', 'ip', 'IP地址', None),
            ('operationTime', 'Date', 'operation_time', '操作时间', None),
            ('duration', 'Long', 'duration', '执行时长(ms)', None),
            ('createTime', 'Date', 'create_time', '创建时间', 'INSERT'),
        ]
    },
}


def generate_entity(class_name, entity_info, package):
    """生成Entity类代码"""
    
    imports = ['import com.baomidou.mybatisplus.annotation.*;',
               'import lombok.Data;',
               'import java.io.Serializable;']
    
    # 检查是否需要BigDecimal或Date
    has_bigdecimal = any(field[1] == 'BigDecimal' for field in entity_info['fields'])
    has_date = any(field[1] == 'Date' for field in entity_info['fields'])
    
    if has_bigdecimal:
        imports.append('import java.math.BigDecimal;')
    if has_date:
        imports.append('import java.util.Date;')
    
    code = f"""package {package}.entity;

{chr(10).join(imports)}

/**
 * {entity_info['comment']}
 * 
 * @author 系统
 * @since 2025-01-01
 */
@Data
@TableName("{entity_info['table']}")
public class {class_name} implements Serializable {{

    private static final long serialVersionUID = 1L;

"""
    
    # 生成字段
    for field in entity_info['fields']:
        field_name, field_type, column_name, comment, fill_type = field
        
        code += f"    /**\n     * {comment}\n     */\n"
        
        # 主键字段
        if fill_type == 'AUTO':
            code += f'    @TableId(value = "{column_name}", type = IdType.AUTO)\n'
        # 自动填充字段
        elif fill_type:
            code += f'    @TableField(value = "{column_name}", fill = FieldFill.{fill_type})\n'
        # 普通字段
        else:
            code += f'    @TableField("{column_name}")\n'
        
        code += f'    private {field_type} {field_name};\n\n'
    
    code += '}\n'
    
    return code


def main():
    print("=" * 50)
    print("食品添加剂管理系统 - Entity类生成器")
    print("=" * 50)
    print()
    
    print("请选择要生成的项目:")
    print("1. 用户端后端 (user-backend)")
    print("2. 管理端后端 (admin-backend)")
    print("3. 全部生成")
    
    choice = input("\n请输入选项 (1-3): ").strip()
    
    projects = []
    if choice == '1':
        projects = [('user-backend', 'com.foodadditive.user')]
    elif choice == '2':
        projects = [('admin-backend', 'com.foodadditive.admin')]
    elif choice == '3':
        projects = [
            ('user-backend', 'com.foodadditive.user'),
            ('admin-backend', 'com.foodadditive.admin')
        ]
    else:
        print("❌ 无效选项")
        return
    
    for project_dir, package in projects:
        print(f"\n{'=' * 50}")
        print(f"开始生成 {project_dir} 的Entity类...")
        print('=' * 50)
        print()
        
        entity_dir = os.path.join(project_dir, 'src', 'main', 'java', 
                                  package.replace('.', os.sep), 'entity')
        os.makedirs(entity_dir, exist_ok=True)
        
        count = 0
        for class_name, entity_info in ENTITIES.items():
            code = generate_entity(class_name, entity_info, package)
            file_path = os.path.join(entity_dir, f'{class_name}.java')
            
            with open(file_path, 'w', encoding='utf-8') as f:
                f.write(code)
            
            print(f"✅ 已生成: {file_path}")
            count += 1
        
        print()
        print('=' * 50)
        print(f"{project_dir} Entity类生成完成！")
        print(f"共生成 {count} 个文件")
        print('=' * 50)
    
    print()
    print("✅ 所有Entity类生成完成！")
    print()
    print("下一步:")
    print("1. 创建公共类和配置类")
    print("2. 完善业务逻辑")
    print("3. 启动后端服务")
    print()


if __name__ == '__main__':
    main()

