package com.shop.entity;

import lombok.Data;

/**
 * 购物车实体类
 */
@Data
public class Cart {
    private int userId;
    private int productId;
    private int quantity;

    private Product product;

    public static Cart forCreate(int userId, int productId, int quantity) {
         Cart cart = new Cart();
         cart.setUserId(userId);
         cart.setProductId(productId);
         cart.setQuantity(quantity);
         return cart;
    }
}