package com.foodadditive.admin.entity;

import com.baomidou.mybatisplus.annotation.*;
import lombok.Data;
import java.io.Serializable;
import java.math.BigDecimal;
import java.util.Date;

/**
 * 采购记录实体类
 * 
 * @author 系统
 * @since 2025-01-01
 */
@Data
@TableName("purchase_record")
public class PurchaseRecord implements Serializable {

    private static final long serialVersionUID = 1L;

    /**
     * 采购ID
     */
    @TableId(value = "purchase_id", type = IdType.AUTO)
    private Long purchaseId;

    /**
     * 采购单号
     */
    @TableField("purchase_no")
    private String purchaseNo;

    /**
     * 添加剂ID
     */
    @TableField("additive_id")
    private Long additiveId;

    /**
     * 供应商ID
     */
    @TableField("supplier_id")
    private Long supplierId;

    /**
     * 采购数量
     */
    @TableField("quantity")
    private BigDecimal quantity;

    /**
     * 单价
     */
    @TableField("unit_price")
    private BigDecimal unitPrice;

    /**
     * 总价
     */
    @TableField("total_price")
    private BigDecimal totalPrice;

    /**
     * 采购日期
     */
    @TableField("purchase_date")
    private Date purchaseDate;

    /**
     * 生产日期
     */
    @TableField("production_date")
    private Date productionDate;

    /**
     * 过期日期
     */
    @TableField("expiry_date")
    private Date expiryDate;

    /**
     * 批次号
     */
    @TableField("batch_number")
    private String batchNumber;

    /**
     * 采购员ID
     */
    @TableField("purchaser_id")
    private Long purchaserId;

    /**
     * 状态：PENDING-待审核，APPROVED-已审核，COMPLETED-已完成，CANCELLED-已取消
     */
    @TableField("status")
    private String status;

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
