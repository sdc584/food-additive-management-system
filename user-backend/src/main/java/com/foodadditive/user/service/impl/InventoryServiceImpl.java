package com.foodadditive.user.service.impl;

import com.foodadditive.user.entity.Inventory;
import com.foodadditive.user.mapper.InventoryMapper;
import com.foodadditive.user.service.InventoryService;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import org.springframework.stereotype.Service;

import java.util.List;

/**
 * 库存Service实现类
 *
 * @author 系统
 * @since 2025-01-01
 */
@Service
public class InventoryServiceImpl extends ServiceImpl<InventoryMapper, Inventory> implements InventoryService {

    @Override
    public Double getTotalQuantity() {
        List<Inventory> list = this.list();
        return list.stream()
                .mapToDouble(inventory -> inventory.getQuantity() != null ? inventory.getQuantity() : 0.0)
                .sum();
    }
}
