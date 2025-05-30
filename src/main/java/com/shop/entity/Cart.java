package com.shop.entity;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

/**
 * 购物车实体类
 */
@Data
@NoArgsConstructor
@AllArgsConstructor
public class Cart {
    private int userId;
    private int productId;
    private int quantity;

    private Product product;
}