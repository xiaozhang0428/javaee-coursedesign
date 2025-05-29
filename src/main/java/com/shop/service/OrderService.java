package com.shop.service;

import com.shop.entity.Order;
import com.shop.entity.Cart;

import java.util.List;

/**
 * 订单服务接口
 */
public interface OrderService {
    
    /**
     * 根据用户ID查询订单列表
     */
    List<Order> findByUserId(Integer userId);
    
    /**
     * 根据ID查询订单详情
     */
    Order findById(Integer id);
    
    /**
     * 创建订单（从购物车结算）
     */
    Order createOrder(Integer userId, List<Integer> productIds);
    
    /**
     * 更新订单状态
     */
    boolean updateStatus(Integer orderId, Integer status);
    
    /**
     * 分页查询订单
     */
    List<Order> findByPage(int page, int size);
    
    /**
     * 统计订单总数
     */
    int countAll();
    
    /**
     * 根据用户ID统计订单数
     */
    int countByUserId(Integer userId);
}