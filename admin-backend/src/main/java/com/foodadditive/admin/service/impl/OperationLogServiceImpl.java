package com.foodadditive.admin.service.impl;

import com.foodadditive.admin.entity.OperationLog;
import com.foodadditive.admin.mapper.OperationLogMapper;
import com.foodadditive.admin.service.OperationLogService;
import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import org.springframework.stereotype.Service;

import java.util.List;

/**
 * 操作日志Service实现类
 *
 * @author 系统
 * @since 2025-01-01
 */
@Service
public class OperationLogServiceImpl extends ServiceImpl<OperationLogMapper, OperationLog> implements OperationLogService {

    @Override
    public List<OperationLog> getRecentLogs(Integer limit) {
        QueryWrapper<OperationLog> queryWrapper = new QueryWrapper<>();
        queryWrapper.orderByDesc("operation_time");
        queryWrapper.last("LIMIT " + limit);
        return this.list(queryWrapper);
    }

}
