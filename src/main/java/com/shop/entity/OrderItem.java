package com.shop.entity;

import lombok.Data;

import java.math.BigDecimal;

/**
 * 订单明细实体类
 */
@Data
public class OrderItem {
    private int id;
    private int oid;
    private int pid;
    private BigDecimal price;
    private int quantity;
    private BigDecimal subtotal; // 小计

    private String productName;
    private String productDescription;
    private BigDecimal productPrice;
    private String productImage;

    public static OrderItem forCreate(Order order, Product product, int quantity, BigDecimal price) {
        OrderItem orderItem = new OrderItem();
        orderItem.oid = order.getId();
        orderItem.pid = product.getId();
        orderItem.price = price;
        orderItem.quantity = quantity;
        orderItem.subtotal = price.multiply(BigDecimal.valueOf(quantity));

        orderItem.productName = product.getName();
        orderItem.productDescription = product.getDescription();
        orderItem.productPrice = product.getPrice();
        orderItem.productImage = product.getImage();
        return orderItem;
    }
}