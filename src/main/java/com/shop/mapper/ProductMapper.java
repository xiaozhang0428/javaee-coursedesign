package com.shop.mapper;

import com.shop.entity.Product;
import org.apache.ibatis.annotations.Param;

import java.util.List;

/**
 * 商品数据访问接口
 */
public interface ProductMapper {

    /**
     * 根据ID查询商品
     */
    Product findById(int id);

    /**
     * 根据关键字搜索商品
     */
    List<Product> search(@Param("keyword") String keyword, @Param("sort") String sort);

    /**
     * 查询热销商品
     */
    List<Product> findHotProducts(@Param("limit") int limit);

    /**
     * 查询最新商品
     */
    List<Product> findLatestProducts(@Param("limit") int limit);

    /**
     * 查询商品
     */
    List<Product> findByPage(@Param("offset") int offset, @Param("limit") int limit, @Param("sort") String sort);

    /**
     * 统计商品总数
     */
    int countAll();

    /**
     * 更新商品
     */
    int update(Product product);

    /**
     * 获取搜索建议
     */
    List<String> findByKeyword(@Param("keyword") String keyword, @Param("limit") int limit);
}