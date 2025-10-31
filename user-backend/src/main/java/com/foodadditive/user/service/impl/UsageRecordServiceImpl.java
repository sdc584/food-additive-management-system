package com.foodadditive.user.service.impl;

import com.foodadditive.user.entity.UsageRecord;
import com.foodadditive.user.mapper.UsageRecordMapper;
import com.foodadditive.user.service.UsageRecordService;
import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.time.YearMonth;

/**
 * 使用记录Service实现类
 *
 * @author 系统
 * @since 2025-01-01
 */
@Service
public class UsageRecordServiceImpl extends ServiceImpl<UsageRecordMapper, UsageRecord> implements UsageRecordService {

    @Override
    public long getCurrentMonthCount() {
        // 获取当前年月
        YearMonth currentMonth = YearMonth.now();
        LocalDateTime startOfMonth = currentMonth.atDay(1).atStartOfDay();
        LocalDateTime endOfMonth = currentMonth.atEndOfMonth().atTime(23, 59, 59);

        // 查询当月的使用记录数量
        QueryWrapper<UsageRecord> queryWrapper = new QueryWrapper<>();
        queryWrapper.between("usage_date", startOfMonth, endOfMonth);

        return this.count(queryWrapper);
    }
}
