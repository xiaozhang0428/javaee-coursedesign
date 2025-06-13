package com.shop.mapper;

import com.shop.entity.Order;
import org.apache.ibatis.annotations.Param;

import java.util.List;

/**
 * 订单数据访问接口
 */
public interface OrderMapper {

    /**
     * 根据ID查询订单
     */
    Order findById(int id);

    /**
     * 根据用户ID查询订单列表
     */
    List<Order> findByUserId(int userId);

    /**
     * 根据用户ID查询订单列表
     */
    List<Order> findByUserIdAndStatus(@Param("userId") int userId, @Param("status") String status);

    /**
     * 添加订单
     */
    int insert(Order order);

    /**
     * 更新订单状态
     */
    int updateStatus(@Param("id") int id, @Param("status") String status);

}