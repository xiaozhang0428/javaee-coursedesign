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
    public static final String STATUS_PENDING = "pending";
    public static final String STATUS_PAID = "paid";
    public static final String STATUS_SHIPPED = "shipped";
    public static final String STATUS_COMPLETED = "completed";
    public static final String STATUS_CANCELLED = "cancelled";

    private int id;
    private int userId;
    private BigDecimal totalAmount;
    // pending, paid, shipped, completed, cancelled
    // 待付款    已付款 已发货    已完成      已取消
    private String status;
    private String username;
    private String phone;
    private String address;
    private Date createTime;

    private List<OrderItem> orderItems;

    public static Order forCreate(User user, BigDecimal totalAmount) {
        Order order = new Order();
        order.userId = user.getId();
        order.totalAmount = totalAmount;
        order.status = STATUS_PENDING;
        order.username = user.getUsername();
        order.phone = user.getPhone();
        order.address = user.getAddress();
        order.createTime = new Date();
        return order;
    }
}