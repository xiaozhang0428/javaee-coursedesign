package com.shop.entity;

import lombok.Data;

import java.util.Date;

/**
 * 购物车实体类
 */
@Data
public class Cart {
    private int id;
    private int userId;
    private int productId;
    private int quantity;
    private Date createTime;

    private Product product;

    public static Cart forCreate(int userId, int productId, int quantity) {
         Cart cart = new Cart();
         cart.setUserId(userId);
         cart.setProductId(productId);
         cart.setQuantity(quantity);
         cart.setCreateTime(new Date());
         return cart;
    }
}