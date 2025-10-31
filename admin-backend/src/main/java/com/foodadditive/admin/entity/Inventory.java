package com.foodadditive.admin.entity;

import com.baomidou.mybatisplus.annotation.*;
import lombok.Data;
import java.io.Serializable;
import java.math.BigDecimal;
import java.util.Date;

/**
 * 库存实体类
 * 
 * @author 系统
 * @since 2025-01-01
 */
@Data
@TableName("inventory")
public class Inventory implements Serializable {

    private static final long serialVersionUID = 1L;

    /**
     * 库存ID
     */
    @TableId(value = "inventory_id", type = IdType.AUTO)
    private Long inventoryId;

    /**
     * 添加剂ID
     */
    @TableField("additive_id")
    private Long additiveId;

    /**
     * 添加剂名称（非数据库字段）
     */
    @TableField(exist = false)
    private String additiveName;

    /**
     * 当前库存
     */
    @TableField("current_stock")
    private BigDecimal currentStock;

    /**
     * 最小库存
     */
    @TableField("min_stock")
    private BigDecimal minStock;

    /**
     * 最大库存
     */
    @TableField("max_stock")
    private BigDecimal maxStock;

    /**
     * 仓库位置
     */
    @TableField("warehouse_location")
    private String warehouseLocation;

    /**
     * 最后采购日期
     */
    @TableField("last_purchase_date")
    private Date lastPurchaseDate;

    /**
     * 最后使用日期
     */
    @TableField("last_usage_date")
    private Date lastUsageDate;

    /**
     * 状态：1-正常，0-停用
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
