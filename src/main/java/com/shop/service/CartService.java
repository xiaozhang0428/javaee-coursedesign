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
    List<Cart> findByUserId(int userId);
    
    /**
     * 添加商品到购物车
     */
    String addToCart(int userId, int productId, int quantity);
    
    /**
     * 更新购物车商品数量
     */
    String updateQuantity(int userId, int productId, int quantity);
    
    /**
     * 从购物车删除商品
     */
    boolean removeFromCart(int userId, int productId);
}