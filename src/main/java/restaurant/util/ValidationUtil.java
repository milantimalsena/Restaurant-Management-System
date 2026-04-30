package com.restaurant.util;

public class ValidationUtil {

    // Requirement: Check for empty inputs
    public static boolean isEmpty(String value) {
        return value == null || value.trim().isEmpty();
    }

    // Requirement Page 9, Sec 4: Ensure names don't have numbers
    public static boolean isValidName(String name) {
        if (isEmpty(name)) return false;
        return name.matches("^[a-zA-Z\\s]+$");
    }

    // Requirement: Check for valid phone numbers (unique identifier)
    public static boolean isValidPhone(String phone) {
        if (isEmpty(phone)) return false;
        return phone.matches("^[0-9]{10}$");
    }
}