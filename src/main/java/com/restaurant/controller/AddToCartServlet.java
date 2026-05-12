package com.restaurant.controller;

import com.restaurant.dao.CartDAO;
import com.restaurant.util.SessionUtil;
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
        if (userId == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String itemIdParam = request.getParameter("itemId");
        if (itemIdParam == null || itemIdParam.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/public/menu.jsp?error=invalid_item");
            return;
        }

        int itemId;
        try {
            itemId = Integer.parseInt(itemIdParam.trim());
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/public/menu.jsp?error=invalid_item");
            return;
        }

        if (itemId < 1) {
            response.sendRedirect(request.getContextPath() + "/public/menu.jsp?error=invalid_item");
            return;
        }

        try {
            boolean added = cartDAO.addToCart(userId, itemId);
            if (!added) {
                response.sendRedirect(request.getContextPath() + "/public/menu.jsp?error=invalid_item");
                return;
            }

            request.getSession().setAttribute("cartMessage", "Item added to cart successfully.");
            response.sendRedirect(request.getContextPath() + "/public/menu.jsp?success=added");
        } catch (SQLException ex) {
            ex.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/public/menu.jsp?error=cart_failed");
        }
    }
}
