package com.shop.entity;

import com.shop.util.StringUtils;
import com.shop.util.UpdateProfileRequest;
import lombok.Data;

import java.util.Date;

/**
 * 用户实体类
 */
@Data
public class User {
    private int id;
    private String username;
    private String password;
    private String email;
    private String phone;
    private String address;
    private Date createTime;

    public void apply(UpdateProfileRequest updateInfo) {
        if (StringUtils.isEmail(updateInfo.getEmail()))
            this.email = updateInfo.getEmail().trim();
        if (StringUtils.isPhone(updateInfo.getPhone()))
            this.phone = updateInfo.getPhone().trim();
        if (!StringUtils.isEmpty(updateInfo.getAddress()))
            this.address = updateInfo.getAddress().trim();
    }

    public static User forRegister(String username, String password, String email) {
        User user = new User();
        user.username = username;
        user.password = password;
        user.email = email;
        user.createTime = new Date();
        return user;
    }
}