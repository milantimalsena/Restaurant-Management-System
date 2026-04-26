package com.restaurant.util;

import java.util.regex.Pattern;

public final class ValidationUtil {
    private static final Pattern EMAIL_PATTERN = Pattern.compile("^[A-Za-z0-9+_.-]+@[A-Za-z0-9.-]+$");
    private static final Pattern PHONE_PATTERN = Pattern.compile("^(?:\\+977[- ]?)?[9][6-9]\\d{8}$|^\\d{10}$");

    private ValidationUtil() {
    }

    public static boolean isRequiredValid(String value) {
        return value != null && !value.trim().isEmpty();
    }

    public static boolean isEmailValid(String email) {
        return isRequiredValid(email) && EMAIL_PATTERN.matcher(email.trim()).matches();
    }

    public static boolean isPasswordValid(String password) {
        return isRequiredValid(password) && password.length() >= 8;
    }

    public static boolean isPhoneValid(String phone) {
        return isRequiredValid(phone) && PHONE_PATTERN.matcher(phone.trim()).matches();
    }

    public static boolean isPositivePrice(String value) {
        if (!isRequiredValid(value)) {
            return false;
        }

        try {
            return Double.parseDouble(value.trim()) >= 0;
        } catch (NumberFormatException ex) {
            return false;
        }
    }

    public static boolean isValidIntegerRange(String value, int min, int max) {
        if (!isRequiredValid(value)) {
            return false;
        }

        try {
            int parsed = Integer.parseInt(value.trim());
            return parsed >= min && parsed <= max;
        } catch (NumberFormatException ex) {
            return false;
        }
    }

    public static String sanitize(String value) {
        if (value == null) {
            return null;
        }
        return value.trim();
    }

    public static int clampQuantity(int quantity) {
        if (quantity < 1) {
            return 1;
        }
        return Math.min(quantity, 20);
    }
}
