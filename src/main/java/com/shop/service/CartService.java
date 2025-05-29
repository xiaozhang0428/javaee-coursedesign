package com.shop.service;

import com.shop.entity.Cart;

import java.util.List;

/**
 * 购物车服务接口
 */
public interface CartService {
    
    /**
     * 查询用户购物车
     */
    List<Cart> findByUserId(Integer userId);
    
    /**
     * 添加商品到购物车
     */
    boolean addToCart(Integer userId, Integer productId, int quantity);
    
    /**
     * 更新购物车商品数量
     */
    boolean updateQuantity(Integer userId, Integer productId, int quantity);
    
    /**
     * 从购物车删除商品
     */
    boolean removeFromCart(Integer userId, Integer productId);
    
    /**
     * 清空购物车
     */
    boolean clearCart(Integer userId);
    
    /**
     * 计算购物车总金额
     */
    double getTotalAmount(Integer userId);
}