package com.shop.util;

import lombok.Getter;
import lombok.Setter;

/**
 * JSON响应结果封装类
 */
@Setter
@Getter
public class JsonResult<T> {
    private boolean success;
    private String message;
    private T data;

    public JsonResult(boolean success, String message) {
        this.success = success;
        this.message = message;
    }

    public JsonResult(boolean success, String message, T data) {
        this.success = success;
        this.message = message;
        this.data = data;
    }

    public static <T> JsonResult<T> success() {
        return new JsonResult<>(true, "操作成功");
    }

    public static <T> JsonResult<T> success(String message) {
        return new JsonResult<>(true, message);
    }

    public static <T> JsonResult<T> success(T data) {
        return new JsonResult<>(true, "操作成功", data);
    }

    public static <T> JsonResult<T> success(String message, T data) {
        return new JsonResult<>(true, message, data);
    }

    public static <T> JsonResult<T> error(String message) {
        return new JsonResult<>(false, message);
    }

    public static <T> JsonResult<T> error(String message, T data) {
        return new JsonResult<>(false, message, data);
    }

    public static <T> JsonResult<T> from(Either<T> result) {
        if (result.isSuccess()) {
            return success(result.result());
        } else {
            return error(result.error());
        }
    }
}