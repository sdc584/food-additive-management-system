package com.foodadditive.admin.service;

import com.foodadditive.admin.entity.OperationLog;
import com.baomidou.mybatisplus.extension.service.IService;

import java.util.List;

/**
 * 操作日志Service接口
 *
 * @author 系统
 * @since 2025-01-01
 */
public interface OperationLogService extends IService<OperationLog> {

    /**
     * 获取最近的操作日志
     * @param limit 数量限制
     * @return 操作日志列表
     */
    List<OperationLog> getRecentLogs(Integer limit);

}
