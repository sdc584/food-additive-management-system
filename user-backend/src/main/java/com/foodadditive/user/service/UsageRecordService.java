package com.foodadditive.user.service;

import com.foodadditive.user.entity.UsageRecord;
import com.baomidou.mybatisplus.extension.service.IService;

/**
 * 使用记录Service接口
 *
 * @author 系统
 * @since 2025-01-01
 */
public interface UsageRecordService extends IService<UsageRecord> {

    /**
     * 获取当月使用记录数量
     * @return 当月使用记录数量
     */
    long getCurrentMonthCount();
}
