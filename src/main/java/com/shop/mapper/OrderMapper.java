package com.shop.mapper;

import com.shop.entity.Order;
import org.apache.ibatis.annotations.Param;

import java.util.Date;
import java.util.List;

/**
 * 订单数据访问接口
 */
public interface OrderMapper {

    /**
     * 查询所有订单
     */
    List<Order> findAll();

    /**
     * 根据ID查询订单
     */
    Order findById(int id);

    /**
     * 根据用户ID查询订单列表
     */
    List<Order> findByUserId(int userId);

    /**
     * 根据状态查询订单
     */
    List<Order> findByStatus(int status);

    /**
     * 根据用户ID和日期范围查询订单
     */
    List<Order> findByUserIdAndDateRange(@Param("userId") int userId,
                                         @Param("startDate") Date startDate,
                                         @Param("endDate") Date endDate);

    /**
     * 分页查询订单
     */
    List<Order> findByPage(@Param("offset") int offset, @Param("size") int size);

    /**
     * 统计订单总数
     */
    int countAll();

    /**
     * 根据用户ID统计订单数
     */
    int countByUserId(int userId);

    /**
     * 添加订单
     */
    int insert(Order order);

    /**
     * 更新订单
     */
    int update(Order order);

    /**
     * 更新订单状态
     */
    int updateStatus(@Param("id") int id, @Param("status") int status);

    /**
     * 删除订单
     */
    int deleteById(int id);

    /**
     * 根据用户ID删除订单
     */
    int deleteByUserId(int userId);
}