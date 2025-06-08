package com.shop.entity;

import lombok.Data;

import java.math.BigDecimal;
import java.util.Date;

/**
 * 商品实体类
 */
@Data
public class Product {
    private int id;
    private String name;
    private String description;
    private BigDecimal price;
    private int stock;
    private int sales;
    private String image;
    private int status;
    // 注释掉数据库中不存在的字段
    // private int categoryId;
    // private Date createTime;
}