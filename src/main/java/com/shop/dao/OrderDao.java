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
     * 查询所有订单
     */
    List<Order> findAll();
    
    /**
     * 根据ID查询订单
     */
    Order findById(Integer id);
    
    /**
     * 根据用户ID查询订单列表
     */
    List<Order> findByUserId(Integer userId);
    
    /**
     * 根据状态查询订单
     */
    List<Order> findByStatus(Integer status);
    
    /**
     * 根据用户ID和日期范围查询订单
     */
    List<Order> findByUserIdAndDateRange(@Param("userId") Integer userId, 
                                        @Param("startDate") Date startDate, 
                                        @Param("endDate") Date endDate);
    
    /**
     * 分页查询订单
     */
    List<Order> findByPage(@Param("offset") Integer offset, @Param("size") Integer size);
    
    /**
     * 统计订单总数
     */
    Integer countAll();
    
    /**
     * 根据用户ID统计订单数
     */
    Integer countByUserId(Integer userId);
    
    /**
     * 添加订单
     */
    Integer insert(Order order);
    
    /**
     * 更新订单
     */
    Integer update(Order order);
    
    /**
     * 更新订单状态
     */
    Integer updateStatus(@Param("id") Integer id, @Param("status") Integer status);
    
    /**
     * 删除订单
     */
    Integer deleteById(Integer id);
    
    /**
     * 根据用户ID删除订单
     */
    Integer deleteByUserId(Integer userId);
}