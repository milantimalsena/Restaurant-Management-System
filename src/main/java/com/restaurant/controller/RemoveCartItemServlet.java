package com.restaurant.controller;

import com.restaurant.dao.CartDAO;
import com.restaurant.util.SessionUtil;
import com.restaurant.util.ValidationUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.sql.SQLException;

public class RemoveCartItemServlet extends HttpServlet {
    private final CartDAO cartDAO = new CartDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        if (!SessionUtil.hasRole(request, "CUSTOMER")) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        Long userId = SessionUtil.getLoggedInUserId(request);
        if (userId == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String cartIdParam = ValidationUtil.sanitize(request.getParameter("cartId"));
        if (!ValidationUtil.isValidIntegerRange(cartIdParam, 1, Integer.MAX_VALUE)) {
            response.sendRedirect(request.getContextPath() + "/cart");
            return;
        }

        try {
            cartDAO.removeItemForUser(userId, Long.parseLong(cartIdParam));
        } catch (SQLException ignored) {
        }

        response.sendRedirect(request.getContextPath() + "/cart");
    }
}
