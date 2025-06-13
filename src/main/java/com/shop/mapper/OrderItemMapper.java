package com.shop.mapper;

import com.shop.entity.OrderItem;

import java.util.List;

/**
 * 订单明细数据访问接口
 */
public interface OrderItemMapper {

    /**
     * 批量添加订单明细
     */
    int batchInsert(List<OrderItem> orderItems);
}