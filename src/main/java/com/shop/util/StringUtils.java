package com.shop.util;

import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;

public class StringUtils {

    public static boolean isEmpty(String str) {
        return !org.springframework.util.StringUtils.hasText(str);
    }

    public static boolean isPhone(String phone) {
        return phone != null && phone.trim().matches("^1[3-9]\\d{9}$");
    }

    public static boolean isEmail(String email) {
        return email != null && email.trim().matches("^\\w+([-+.]\\w+)*@\\w+([-.]\\w+)*\\.\\w+([-.]\\w+)*$");
    }

    public static String md5(String input) {
        if (input == null) {
            return null;
        }

        try {
            MessageDigest md = MessageDigest.getInstance("MD5");
            byte[] digest = md.digest(input.getBytes());

            StringBuilder sb = new StringBuilder();
            for (byte b : digest) {
                sb.append(String.format("%02x", b & 0xff));
            }

            return sb.toString();
        } catch (NoSuchAlgorithmException e) {
            throw new RuntimeException("MD5加密失败", e);
        }
    }
}
