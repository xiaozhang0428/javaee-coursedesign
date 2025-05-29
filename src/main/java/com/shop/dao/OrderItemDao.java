package com.shop.dao;

import com.shop.entity.OrderItem;

import java.util.List;

/**
 * 订单明细数据访问接口
 */
public interface OrderItemDao {
    
    /**
     * 根据订单ID查询订单明细
     */
    List<OrderItem> findByOrderId(String orderId);
    
    /**
     * 添加订单明细
     */
    Integer insert(OrderItem orderItem);
    
    /**
     * 批量添加订单明细
     */
    Integer batchInsert(List<OrderItem> orderItems);
    
    /**
     * 删除订单明细
     */
    Integer deleteByOrderId(String orderId);
}