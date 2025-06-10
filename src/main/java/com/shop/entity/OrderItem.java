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
    private String productName;  // 商品名称
    private BigDecimal productPrice;  // 商品价格
    private BigDecimal subtotal;  // 小计
    private BigDecimal price;  // 商品单价（可选字段）

    private Product product;

    public static OrderItem forCreate(int orderId, int productId, int quantity, BigDecimal price, Product product) {
        OrderItem orderItem = new OrderItem();
        orderItem.orderId = orderId;
        orderItem.productId = productId;
        orderItem.quantity = quantity;
        orderItem.productName = product != null ? product.getName() : ""; // 设置商品名称
        orderItem.productPrice = product != null ? product.getPrice() : BigDecimal.ZERO; // 设置商品价格
        orderItem.subtotal = orderItem.productPrice.multiply(BigDecimal.valueOf(quantity)); // 计算小计
        orderItem.price = orderItem.productPrice; // 设置单价（与productPrice相同）
        orderItem.product = product;
        return orderItem;
    }
    
    // 获取商品价格（优先使用productPrice字段，如果为空则从Product对象获取）
    public BigDecimal getPrice() {
        if (productPrice != null) {
            return productPrice;
        }
        return product != null ? product.getPrice() : BigDecimal.ZERO;
    }
    
    // 计算总价（优先使用subtotal字段，如果为空则计算）
    public BigDecimal getTotalPrice() {
        if (subtotal != null) {
            return subtotal;
        }
        return getPrice().multiply(BigDecimal.valueOf(quantity));
    }
}