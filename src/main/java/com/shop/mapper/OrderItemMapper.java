package com.shop.mapper;

import com.shop.entity.OrderItem;

import java.util.List;

/**
 * 订单明细数据访问接口
 */
public interface OrderItemMapper {
    
    /**
     * 根据订单ID查询订单明细
     */
    List<OrderItem> findByOrderId(int orderId);
    
    /**
     * 添加订单明细
     */
    int insert(OrderItem orderItem);
    
    /**
     * 批量添加订单明细
     */
    int batchInsert(List<OrderItem> orderItems);
    
    /**
     * 删除订单明细
     */
    int deleteByOrderId(int orderId);
}