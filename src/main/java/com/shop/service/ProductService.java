package com.shop.service;

import com.shop.entity.Product;

import java.util.List;

/**
 * 商品服务接口
 */
public interface ProductService {
    
    /**
     * 查询所有商品
     */
    List<Product> findAll();
    
    /**
     * 根据ID查询商品
     */
    Product findById(Integer id);
    
    /**
     * 搜索商品
     */
    List<Product> searchProducts(String keyword);
    
    /**
     * 搜索商品（带排序）
     */
    List<Product> searchProducts(String keyword, String sort);
    
    /**
     * 查询热销商品
     */
    List<Product> findHotProducts(int limit);
    
    /**
     * 查询最新商品
     */
    List<Product> findLatestProducts(int limit);
    
    /**
     * 分页查询商品
     */
    List<Product> findByPage(int page, int size);
    
    /**
     * 分页查询商品（带排序）
     */
    List<Product> findByPage(int page, int size, String sort);
    
    /**
     * 统计商品总数
     */
    int getTotalCount();
    
    /**
     * 添加商品
     */
    boolean addProduct(Product product);
    
    /**
     * 更新商品
     */
    boolean updateProduct(Product product);
    
    /**
     * 删除商品
     */
    boolean deleteProduct(Integer id);
}