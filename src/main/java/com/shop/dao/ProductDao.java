package com.shop.dao;

import com.shop.entity.Product;
import org.apache.ibatis.annotations.Param;

import java.util.List;

/**
 * 商品数据访问接口
 */
public interface ProductDao {
    
    /**
     * 查询所有商品
     */
    List<Product> findAll();
    
    /**
     * 根据ID查询商品
     */
    Product findById(Integer id);
    
    /**
     * 根据关键字搜索商品
     */
    List<Product> searchByKeyword(@Param("keyword") String keyword);
    
    /**
     * 查询热销商品
     */
    List<Product> findHotProducts(@Param("limit") Integer limit);
    
    /**
     * 查询最新商品
     */
    List<Product> findLatestProducts(@Param("limit") Integer limit);
    
    /**
     * 分页查询商品
     */
    List<Product> findByPage(@Param("offset") Integer offset, @Param("limit") Integer limit);
    
    /**
     * 统计商品总数
     */
    Integer countAll();
    
    /**
     * 添加商品
     */
    Integer insert(Product product);
    
    /**
     * 更新商品
     */
    Integer update(Product product);
    
    /**
     * 删除商品
     */
    Integer deleteById(Integer id);
    
    /**
     * 更新商品库存
     */
    Integer updateStock(@Param("id") Integer id, @Param("quantity") Integer quantity);
    
    /**
     * 更新商品销量
     */
    Integer updateSales(@Param("id") Integer id, @Param("quantity") Integer quantity);
}