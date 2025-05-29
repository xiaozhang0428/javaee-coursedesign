package com.shop.dao;

import com.shop.entity.Order;
import org.apache.ibatis.annotations.Param;

import java.util.Date;
import java.util.List;

/**
 * 订单数据访问接口
 */
public interface OrderDao {
    
    /**
     * 根据ID查询订单
     */
    Order findById(Integer id);
    
    /**
     * 根据用户ID查询订单列表
     */
    List<Order> findByUserId(Integer userId);
    
    /**
     * 根据用户ID和日期范围查询订单
     */
    List<Order> findByUserIdAndDateRange(@Param("userId") Integer userId, 
                                        @Param("startDate") Date startDate, 
                                        @Param("endDate") Date endDate);
    
    /**
     * 添加订单
     */
    Integer insert(Order order);
    
    /**
     * 更新订单状态
     */
    Integer updateStatus(@Param("id") Integer id, @Param("status") Integer status);
    
    /**
     * 删除订单
     */
    Integer deleteById(Integer id);
}