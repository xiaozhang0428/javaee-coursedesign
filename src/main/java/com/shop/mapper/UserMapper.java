package com.shop.mapper;

import com.shop.entity.User;
import org.apache.ibatis.annotations.Param;

/**
 * 用户数据访问接口
 */
public interface UserMapper {
    
    /**
     * 根据ID查询用户
     */
    User findById(Integer id);
    
    /**
     * 根据用户名查询用户
     */
    User findByUsername(String username);
    
    /**
     * 根据用户名和密码查询用户（登录）
     */
    User findByUsernameAndPassword(@Param("username") String username, @Param("password") String password);
    
    /**
     * 添加用户
     */
    Integer insert(User user);
    
    /**
     * 更新用户信息
     */
    Integer update(User user);
    
    /**
     * 删除用户
     */
    Integer deleteById(Integer id);
    
    /**
     * 检查用户名是否存在
     */
    int countByUsername(String username);
    
    /**
     * 检查邮箱是否存在
     */
    int countByEmail(String email);
}