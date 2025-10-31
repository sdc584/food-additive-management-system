package com.foodadditive.admin.entity;

import com.baomidou.mybatisplus.annotation.*;
import com.fasterxml.jackson.annotation.JsonFormat;
import lombok.Data;
import java.io.Serializable;
import java.math.BigDecimal;
import java.util.Date;

/**
 * 使用记录实体类
 * 
 * @author 系统
 * @since 2025-01-01
 */
@Data
@TableName("usage_record")
public class UsageRecord implements Serializable {

    private static final long serialVersionUID = 1L;

    /**
     * 使用记录ID
     */
    @TableId(value = "usage_id", type = IdType.AUTO)
    private Long usageId;

    /**
     * 使用单号
     */
    @TableField("usage_no")
    private String usageNo;

    /**
     * 添加剂ID
     */
    @TableField("additive_id")
    private Long additiveId;

    /**
     * 使用数量
     */
    @TableField("quantity")
    private BigDecimal quantity;

    /**
     * 使用日期
     */
    @TableField("usage_date")
    @JsonFormat(pattern = "yyyy-MM-dd", timezone = "GMT+8")
    private Date usageDate;

    /**
     * 使用目的
     */
    @TableField("usage_purpose")
    private String usagePurpose;

    /**
     * 产品批次
     */
    @TableField("product_batch")
    private String productBatch;

    /**
     * 用户ID
     */
    @TableField("user_id")
    private Long userId;

    /**
     * 部门
     */
    @TableField("department")
    private String department;

    /**
     * 添加剂名称（非数据库字段）
     */
    @TableField(exist = false)
    private String additiveName;

    /**
     * 备注
     */
    @TableField("remark")
    private String remark;

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
