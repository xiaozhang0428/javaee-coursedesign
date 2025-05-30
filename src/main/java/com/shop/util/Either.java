package com.shop.util;

public record Either<T>(T result, String error) {

    public static <T> Either<T> of(T result) {
        return new Either<>(result, null);
    }

    public static <T> Either<T> error(String error) {
        return new Either<>(null, error);
    }

    public static <T> Either<T> error(String error, Object... args) {
        return new Either<>(null, String.format(error, args));
    }

    public boolean isSuccess() {
        return error == null;
    }
}
