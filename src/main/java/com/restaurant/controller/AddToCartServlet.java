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

public class AddToCartServlet extends HttpServlet {
    private final CartDAO cartDAO = new CartDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        if (!SessionUtil.hasRole(request, "CUSTOMER")) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        Long userId = SessionUtil.getLoggedInUserId(request);
        String itemIdParam = ValidationUtil.sanitize(request.getParameter("itemId"));
        String qtyParam = ValidationUtil.sanitize(request.getParameter("qty"));
        String redirect = ValidationUtil.sanitize(request.getParameter("redirect"));

        if (userId == null || !ValidationUtil.isValidIntegerRange(itemIdParam, 1, Integer.MAX_VALUE)) {
            response.sendRedirect(request.getContextPath() + "/menu");
            return;
        }

        int qty = 1;
        if (ValidationUtil.isValidIntegerRange(qtyParam, 1, 20)) {
            qty = Integer.parseInt(qtyParam);
        }

        try {
            boolean success = cartDAO.addToCart(userId, Long.parseLong(itemIdParam), qty);
            request.getSession().setAttribute("cartMessage", success ? "Item added to cart." : "Unable to add unavailable item.");
        } catch (SQLException ex) {
            request.getSession().setAttribute("cartMessage", "Unable to add item right now.");
        }

        if (ValidationUtil.isRequiredValid(redirect)) {
            response.sendRedirect(request.getContextPath() + redirect);
        } else {
            response.sendRedirect(request.getContextPath() + "/cart");
        }
    }
}
