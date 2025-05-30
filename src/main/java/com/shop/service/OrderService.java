package com.shop.service;

import com.shop.entity.Order;
import com.shop.entity.User;
import com.shop.util.Either;

import java.util.List;

/**
 * 订单服务接口
 */
public interface OrderService {
    
    /**
     * 根据用户ID查询订单列表
     */
    List<Order> findByUserId(int userId);
    
    /**
     * 根据ID查询订单详情
     */
    Order findById(int id);
    
    /**
     * 创建订单（从购物车结算）
     */
    Either<Order> createOrder(User user, List<Integer> productIds);
    
    /**
     * 更新订单状态
     */
    boolean updateStatus(int orderId, int status);
    
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
    int countByUserId(int userId);
}