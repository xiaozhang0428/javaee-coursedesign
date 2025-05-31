package com.shop.util;

import lombok.Data;

@Data
public class UpdateProfileRequest {

    private String email;
    private String phone;
    private String address;
}
