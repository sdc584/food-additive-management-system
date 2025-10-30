package com.foodadditive.user.entity;

import com.baomidou.mybatisplus.annotation.*;
import lombok.Data;
import java.io.Serializable;
import java.math.BigDecimal;
import java.util.Date;

/**
 * 食品添加剂实体类示例
 * 
 * 使用说明：
 * 1. 将此文件复制到 entity 包下
 * 2. 根据实际表结构修改字段
 * 3. 为其他表创建类似的Entity类
 * 
 * @author 系统
 * @since 2025-01-01
 */
@Data
@TableName("food_additive")
public class FoodAdditive implements Serializable {

    private static final long serialVersionUID = 1L;

    /**
     * 添加剂ID
     */
    @TableId(value = "additive_id", type = IdType.AUTO)
    private Long additiveId;

    /**
     * 添加剂名称
     */
    @TableField("additive_name")
    private String additiveName;

    /**
     * 添加剂编号
     */
    @TableField("additive_code")
    private String additiveCode;

    /**
     * 分类ID
     */
    @TableField("category_id")
    private Long categoryId;

    /**
     * CAS号
     */
    @TableField("cas_number")
    private String casNumber;

    /**
     * 分子式
     */
    @TableField("molecular_formula")
    private String molecularFormula;

    /**
     * 规格
     */
    @TableField("specification")
    private String specification;

    /**
     * 单位
     */
    @TableField("unit")
    private String unit;

    /**
     * 最大使用量(g/kg)
     */
    @TableField("max_usage")
    private BigDecimal maxUsage;

    /**
     * 安全等级
     */
    @TableField("safety_level")
    private String safetyLevel;

    /**
     * 描述
     */
    @TableField("description")
    private String description;

    /**
     * 使用范围
     */
    @TableField("usage_scope")
    private String usageScope;

    /**
     * 状态：1-启用，0-禁用
     */
    @TableField("status")
    private Integer status;

    /**
     * 创建时间
     */
    @TableField(value = "create_time", fill = FieldFill.INSERT)
    private Date createTime;

    /**
     * 更新时间
     */
    @TableField(value = "update_time", fill = FieldFill.INSERT_UPDATE)
    private Date updateTime;
}


// ========================================
// 其他Entity类示例
// ========================================

/**
 * 用户实体类
 */
@Data
@TableName("sys_user")
class SysUser implements Serializable {
    
    private static final long serialVersionUID = 1L;

    @TableId(value = "user_id", type = IdType.AUTO)
    private Long userId;

    @TableField("username")
    private String username;

    @TableField("password")
    private String password;

    @TableField("real_name")
    private String realName;

    @TableField("phone")
    private String phone;

    @TableField("email")
    private String email;

    @TableField("role")
    private String role;

    @TableField("status")
    private Integer status;

    @TableField(value = "create_time", fill = FieldFill.INSERT)
    private Date createTime;

    @TableField(value = "update_time", fill = FieldFill.INSERT_UPDATE)
    private Date updateTime;
}

/**
 * 添加剂分类实体类
 */
@Data
@TableName("additive_category")
class AdditiveCategory implements Serializable {
    
    private static final long serialVersionUID = 1L;

    @TableId(value = "category_id", type = IdType.AUTO)
    private Long categoryId;

    @TableField("category_name")
    private String categoryName;

    @TableField("category_code")
    private String categoryCode;

    @TableField("parent_id")
    private Long parentId;

    @TableField("description")
    private String description;

    @TableField("sort_order")
    private Integer sortOrder;

    @TableField("status")
    private Integer status;

    @TableField(value = "create_time", fill = FieldFill.INSERT)
    private Date createTime;

    @TableField(value = "update_time", fill = FieldFill.INSERT_UPDATE)
    private Date updateTime;
}

/**
 * 供应商实体类
 */
@Data
@TableName("supplier")
class Supplier implements Serializable {
    
    private static final long serialVersionUID = 1L;

    @TableId(value = "supplier_id", type = IdType.AUTO)
    private Long supplierId;

    @TableField("supplier_name")
    private String supplierName;

    @TableField("supplier_code")
    private String supplierCode;

    @TableField("contact_person")
    private String contactPerson;

    @TableField("contact_phone")
    private String contactPhone;

    @TableField("contact_email")
    private String contactEmail;

    @TableField("address")
    private String address;

    @TableField("credit_level")
    private String creditLevel;

    @TableField("business_license")
    private String businessLicense;

    @TableField("status")
    private Integer status;

    @TableField("remark")
    private String remark;

    @TableField(value = "create_time", fill = FieldFill.INSERT)
    private Date createTime;

    @TableField(value = "update_time", fill = FieldFill.INSERT_UPDATE)
    private Date updateTime;
}

/**
 * 库存实体类
 */
@Data
@TableName("inventory")
class Inventory implements Serializable {
    
    private static final long serialVersionUID = 1L;

    @TableId(value = "inventory_id", type = IdType.AUTO)
    private Long inventoryId;

    @TableField("additive_id")
    private Long additiveId;

    @TableField("current_stock")
    private BigDecimal currentStock;

    @TableField("min_stock")
    private BigDecimal minStock;

    @TableField("max_stock")
    private BigDecimal maxStock;

    @TableField("warehouse_location")
    private String warehouseLocation;

    @TableField("last_purchase_date")
    private Date lastPurchaseDate;

    @TableField("last_usage_date")
    private Date lastUsageDate;

    @TableField("status")
    private Integer status;

    @TableField(value = "create_time", fill = FieldFill.INSERT)
    private Date createTime;

    @TableField(value = "update_time", fill = FieldFill.INSERT_UPDATE)
    private Date updateTime;
}

// 注意：
// 1. 每个Entity类都应该在单独的文件中
// 2. 包名根据项目类型修改 (user 或 admin)
// 3. 使用Lombok的@Data注解简化代码
// 4. 使用MyBatis Plus的注解标注表名和字段
// 5. 主键使用@TableId，自增类型为IdType.AUTO
// 6. 时间字段使用FieldFill自动填充

