package com.foodadditive.admin.entity;

import com.baomidou.mybatisplus.annotation.*;
import lombok.Data;
import java.io.Serializable;
import java.math.BigDecimal;
import java.util.Date;

/**
 * 食品添加剂实体类
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
     * 分类名称（非数据库字段）
     */
    @TableField(exist = false)
    private String categoryName;

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
