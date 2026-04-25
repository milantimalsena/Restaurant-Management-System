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
}
