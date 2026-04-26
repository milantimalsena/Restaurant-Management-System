package com.restaurant.util;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.UUID;

public final class OrderNumberUtil {
    private static final DateTimeFormatter ORDER_TIME = DateTimeFormatter.ofPattern("yyyyMMddHHmm");

    private OrderNumberUtil() {
    }

    public static String generateOrderNumber() {
        String timestamp = LocalDateTime.now().format(ORDER_TIME);
        String randomSuffix = UUID.randomUUID().toString().substring(0, 6).toUpperCase();
        return "ORD-" + timestamp + "-" + randomSuffix;
    }
}
