package com.foodadditive.user.entity;

import com.baomidou.mybatisplus.annotation.*;
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
     * 记录ID
     */
    @TableId(value = "record_id", type = IdType.AUTO)
    private Long recordId;

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
    @TableField("usage_quantity")
    private BigDecimal usageQuantity;

    /**
     * 使用日期
     */
    @TableField("usage_date")
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
     * 操作员ID
     */
    @TableField("operator")
    private Long operator;

    /**
     * 状态：0-待审核，1-已审核
     */
    @TableField("status")
    private Integer status;

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
