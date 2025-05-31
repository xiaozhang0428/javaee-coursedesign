package com.shop.entity;

import lombok.Data;

import java.math.BigDecimal;
import java.util.Date;
import java.util.List;

/**
 * 订单实体类
 */
@Data
public class Order {
    private int id;
    private int userId;
    private BigDecimal totalAmount;
    private int status; // 0-待支付，1-已支付，2-已发货，3-已完成
    private String shippingAddress;
    private Date createTime;

    private User user;
    private List<OrderItem> orderItems;

    public Order(int userId, BigDecimal totalAmount, int status, String shippingAddress, Date createTime) {
        this.userId = userId;
        this.totalAmount = totalAmount;
        this.status = status;
        this.shippingAddress = shippingAddress;
        this.createTime = createTime;
    }

    public String getStatusText() {
        return switch (status) {
            case 0 -> "待支付";
            case 1 -> "已支付";
            case 2 -> "已发货";
            case 3 -> "已完成";
            default -> "未知状态";
        };
    }
}