package com.restaurant.util;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;

import java.util.Optional;

public final class SessionUtil {
    private SessionUtil() {
    }

    public static void createUserSession(HttpServletRequest request, Long userId, String fullName, String email) {
        HttpSession session = request.getSession(true);
        session.setAttribute("userRole", "CUSTOMER");
        session.setAttribute("userId", userId);
        session.setAttribute("userFullName", fullName);
        session.setAttribute("userEmail", email);
        session.setMaxInactiveInterval(30 * 60);
    }

    public static void createAdminSession(HttpServletRequest request, Long adminId, String fullName, String email) {
        HttpSession session = request.getSession(true);
        session.setAttribute("userRole", "ADMIN");
        session.setAttribute("adminId", adminId);
        session.setAttribute("adminFullName", fullName);
        session.setAttribute("adminEmail", email);
        session.setMaxInactiveInterval(30 * 60);
    }

    public static boolean isAuthenticated(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        return session != null && session.getAttribute("userRole") != null;
    }

    public static boolean hasRole(HttpServletRequest request, String role) {
        HttpSession session = request.getSession(false);
        return session != null && role.equals(session.getAttribute("userRole"));
    }

    public static void invalidateSession(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session != null) {
            session.invalidate();
        }
    }

    public static Long getLoggedInUserId(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session == null) {
            return null;
        }

        Object userId = session.getAttribute("userId");
        if (userId instanceof Long id) {
            return id;
        }
        if (userId instanceof Integer id) {
            return id.longValue();
        }
        if (userId instanceof String value) {
            try {
                return Long.parseLong(value);
            } catch (NumberFormatException ignored) {
                return null;
            }
        }

        return null;
    }
}
