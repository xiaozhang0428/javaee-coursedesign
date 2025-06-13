package com.shop.mapper;

import com.shop.entity.Cart;
import org.apache.ibatis.annotations.Param;

import java.util.List;

/**
 * 购物车数据访问接口
 */
public interface CartMapper {
    
    /**
     * 根据用户ID查询购物车
     */
    List<Cart> findByUserId(int userId);
    
    /**
     * 根据用户ID和商品ID查询购物车项
     */
    Cart findByUserIdAndProductId(@Param("userId") int userId, @Param("productId") int productId);
    
    /**
     * 添加到购物车
     */
    int insert(Cart cart);
    
    /**
     * 更新购物车商品数量
     */
    int updateQuantity(@Param("userId") int userId, @Param("productId") int productId, @Param("quantity") int quantity);
    
    /**
     * 删除购物车项
     */
    int deleteByUserIdAndProductId(@Param("userId") int userId, @Param("productId") int productId);
}