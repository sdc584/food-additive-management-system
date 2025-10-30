package com.foodadditive.user.entity;

import com.baomidou.mybatisplus.annotation.*;
import lombok.Data;
import java.io.Serializable;
import java.util.Date;

/**
 * 检测报告实体类
 * 
 * @author 系统
 * @since 2025-01-01
 */
@Data
@TableName("test_report")
public class TestReport implements Serializable {

    private static final long serialVersionUID = 1L;

    /**
     * 报告ID
     */
    @TableId(value = "report_id", type = IdType.AUTO)
    private Long reportId;

    /**
     * 报告编号
     */
    @TableField("report_no")
    private String reportNo;

    /**
     * 添加剂ID
     */
    @TableField("additive_id")
    private Long additiveId;

    /**
     * 检测日期
     */
    @TableField("test_date")
    private Date testDate;

    /**
     * 检测机构
     */
    @TableField("test_organization")
    private String testOrganization;

    /**
     * 检测结果：合格/不合格
     */
    @TableField("test_result")
    private String testResult;

    /**
     * 检测项目
     */
    @TableField("test_items")
    private String testItems;

    /**
     * 报告文件路径
     */
    @TableField("report_file")
    private String reportFile;

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
