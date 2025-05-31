package com.shop.entity;

import lombok.Data;

import java.math.BigDecimal;

/**
 * 订单明细实体类
 */
@Data
public class OrderItem {
    private int id;
    private int orderId;
    private int productId;
    private int quantity;
    private BigDecimal price;

    private Product product;

    public static OrderItem forCreate(int orderId, int productId, int quantity, BigDecimal price, Product product) {
        OrderItem orderItem = new OrderItem();
        orderItem.orderId = orderId;
        orderItem.productId = productId;
        orderItem.quantity = quantity;
        orderItem.price = price;
        orderItem.product = product;
        return orderItem;
    }
}