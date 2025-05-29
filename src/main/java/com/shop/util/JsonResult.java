package com.shop.util;

/**
 * JSON响应结果封装类
 */
public class JsonResult<T> {
    private boolean success;
    private String message;
    private T data;

    public JsonResult() {}

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

    // Getters and Setters
    public boolean isSuccess() {
        return success;
    }

    public void setSuccess(boolean success) {
        this.success = success;
    }

    public String getMessage() {
        return message;
    }

    public void setMessage(String message) {
        this.message = message;
    }

    public T getData() {
        return data;
    }

    public void setData(T data) {
        this.data = data;
    }
}