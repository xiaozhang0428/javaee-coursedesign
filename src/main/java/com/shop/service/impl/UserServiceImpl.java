package com.shop.service.impl;

import com.shop.dao.UserDao;
import com.shop.entity.User;
import com.shop.service.UserService;
import com.shop.util.MD5Util;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.Date;

/**
 * 用户服务实现类
 */
@Service
public class UserServiceImpl implements UserService {
    
    @Autowired
    private UserDao userDao;
    
    @Override
    public User login(String username, String password) {
        if (username == null || password == null) {
            return null;
        }
        String encryptedPassword = MD5Util.encrypt(password);
        return userDao.findByUsernameAndPassword(username, encryptedPassword);
    }
    
    @Override
    public boolean register(User user) {
        if (user == null || user.getUsername() == null || user.getPassword() == null) {
            return false;
        }
        
        // 检查用户名是否已存在
        if (isUsernameExists(user.getUsername())) {
            return false;
        }
        
        // 检查邮箱是否已存在
        if (user.getEmail() != null && isEmailExists(user.getEmail())) {
            return false;
        }
        
        // 密码加密
        user.setPassword(MD5Util.encrypt(user.getPassword()));
        user.setCreateTime(new Date());
        
        return userDao.insert(user) > 0;
    }
    
    @Override
    public User findById(Integer id) {
        if (id == null) {
            return null;
        }
        return userDao.findById(id);
    }
    
    @Override
    public boolean updateUser(User user) {
        if (user == null || user.getId() == null) {
            return false;
        }
        return userDao.update(user) > 0;
    }
    
    @Override
    public boolean isUsernameExists(String username) {
        if (username == null) {
            return false;
        }
        return userDao.countByUsername(username) > 0;
    }
    
    @Override
    public boolean isEmailExists(String email) {
        if (email == null) {
            return false;
        }
        return userDao.countByEmail(email) > 0;
    }
}