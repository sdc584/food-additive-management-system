package com.foodadditive.admin.entity;

import com.baomidou.mybatisplus.annotation.*;
import lombok.Data;
import java.io.Serializable;
import java.util.Date;

/**
 * 预警实体类
 * 
 * @author 系统
 * @since 2025-01-01
 */
@Data
@TableName("warning")
public class Warning implements Serializable {

    private static final long serialVersionUID = 1L;

    /**
     * 预警ID
     */
    @TableId(value = "warning_id", type = IdType.AUTO)
    private Long warningId;

    /**
     * 预警类型：STOCK-库存预警，EXPIRY-过期预警
     */
    @TableField("warning_type")
    private String warningType;

    /**
     * 添加剂ID
     */
    @TableField("additive_id")
    private Long additiveId;

    /**
     * 预警级别：HIGH-高，MEDIUM-中，LOW-低
     */
    @TableField("warning_level")
    private String warningLevel;

    /**
     * 预警内容
     */
    @TableField("warning_content")
    private String warningContent;

    /**
     * 预警日期
     */
    @TableField("warning_date")
    private Date warningDate;

    /**
     * 状态：0-未处理，1-已处理
     */
    @TableField("status")
    private Integer status;

    /**
     * 处理人ID
     */
    @TableField("handler")
    private Long handler;

    /**
     * 处理时间
     */
    @TableField("handle_time")
    private Date handleTime;

    /**
     * 处理备注
     */
    @TableField("handle_remark")
    private String handleRemark;

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
