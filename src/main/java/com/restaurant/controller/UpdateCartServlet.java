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

public class UpdateCartServlet extends HttpServlet {
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
        String action = ValidationUtil.sanitize(request.getParameter("action"));
        String qtyParam = ValidationUtil.sanitize(request.getParameter("qty"));

        if (!ValidationUtil.isValidIntegerRange(cartIdParam, 1, Integer.MAX_VALUE)) {
            response.sendRedirect(request.getContextPath() + "/cart");
            return;
        }

        long cartId = Long.parseLong(cartIdParam);
        try {
            if ("increase".equalsIgnoreCase(action)) {
                cartDAO.increaseQtyForUser(userId, cartId);
            } else if ("decrease".equalsIgnoreCase(action)) {
                cartDAO.decreaseQtyForUser(userId, cartId);
            } else if ("manual".equalsIgnoreCase(action) && ValidationUtil.isValidIntegerRange(qtyParam, 1, 20)) {
                cartDAO.updateQuantityForUser(userId, cartId, Integer.parseInt(qtyParam));
            }
        } catch (SQLException ignored) {
        }

        response.sendRedirect(request.getContextPath() + "/cart");
    }
}
