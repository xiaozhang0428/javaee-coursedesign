package com.shop.util;

import lombok.Data;

@Data
public class UpdatePasswordRequest {

    String oldPassword;
    String newPassword;
}
