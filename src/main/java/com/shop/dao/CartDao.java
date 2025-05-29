package com.shop.dao;

import com.shop.entity.Cart;
import org.apache.ibatis.annotations.Param;

import java.util.List;

/**
 * 购物车数据访问接口
 */
public interface CartDao {
    
    /**
     * 根据用户ID查询购物车
     */
    List<Cart> findByUserId(Integer userId);
    
    /**
     * 根据用户ID和商品ID查询购物车项
     */
    Cart findByUserIdAndProductId(@Param("userId") Integer userId, @Param("productId") Integer productId);
    
    /**
     * 添加到购物车
     */
    Integer insert(Cart cart);
    
    /**
     * 更新购物车商品数量
     */
    Integer updateQuantity(@Param("userId") Integer userId, @Param("productId") Integer productId, @Param("quantity") int quantity);
    
    /**
     * 删除购物车项
     */
    Integer deleteByUserIdAndProductId(@Param("userId") Integer userId, @Param("productId") Integer productId);
    
    /**
     * 清空用户购物车
     */
    Integer deleteByUserId(Integer userId);
}