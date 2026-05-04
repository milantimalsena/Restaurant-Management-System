package com.restaurant.controller;

import com.restaurant.dao.CartDAO;
import com.restaurant.dao.MenuItemDAO;
import com.restaurant.model.MenuItem;
import com.restaurant.util.SessionUtil;
import com.restaurant.util.ValidationUtil;
import jakarta.servlet.http.HttpSession;

import java.util.HashMap;
import java.util.Map;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.sql.SQLException;

public class AddToCartServlet extends HttpServlet {
    private final CartDAO cartDAO = new CartDAO();
    private final MenuItemDAO menuItemDAO = new MenuItemDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        System.out.println("AddToCart HIT");
        Long userId = SessionUtil.getLoggedInUserId(request);
        String itemIdParam = ValidationUtil.sanitize(request.getParameter("itemId"));
        String qtyParam = ValidationUtil.sanitize(request.getParameter("qty"));
        String redirect = ValidationUtil.sanitize(request.getParameter("redirect"));

        System.out.println("AddToCart: userId=" + userId + ", itemIdParam=" + itemIdParam + ", qtyParam=" + qtyParam);

        long itemId;
        try {
            itemId = Long.parseLong(itemIdParam);
            if (itemId < 1L) {
                response.sendRedirect(request.getContextPath() + "/menu");
                return;
            }
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/menu");
            return;
        }

        int qty = 1;
        try {
            int parsedQty = Integer.parseInt(qtyParam == null ? "1" : qtyParam);
            qty = ValidationUtil.clampQuantity(parsedQty);
        } catch (NumberFormatException ignored) {
            qty = 1;
        }

        MenuItem item;
        try {
            item = menuItemDAO.getById(itemId);
            if (item == null || !item.isAvailable()) {
                request.getSession().setAttribute("cartMessage", "This item is currently unavailable or out of stock.");
                response.sendRedirect(request.getContextPath() + "/menu");
                return;
            }
        } catch (SQLException ex) {
            request.getSession().setAttribute("cartMessage", "Unable to add item right now.");
            response.sendRedirect(request.getContextPath() + "/menu");
            return;
        }

        // Require login to add to persistent cart. If user is not logged in, redirect to login page.
        if (!SessionUtil.hasRole(request, "CUSTOMER") || userId == null) {
            System.out.println("AddToCart: user not authenticated, redirecting to login");
            String dest = request.getRequestURI();
            String query = request.getQueryString();
            String returnTo = dest + (query == null ? "" : "?" + query);
            try {
                String encoded = java.net.URLEncoder.encode(returnTo, java.nio.charset.StandardCharsets.UTF_8.name());
                response.sendRedirect(request.getContextPath() + "/login?redirect=" + encoded);
            } catch (java.io.UnsupportedEncodingException e) {
                response.sendRedirect(request.getContextPath() + "/login");
            }
            return;
        }

        // If user is logged in as CUSTOMER use persistent cart
        try {
            boolean success = cartDAO.addToCart(userId, itemId, qty);
            if (success) {
                // update persistent cart count in session so navbar shows accurate count
                try {
                    int count = cartDAO.getCartCount(userId);
                    request.getSession().setAttribute("cartCount", count);
                } catch (SQLException e) {
                    System.out.println("AddToCart: failed to fetch cart count: " + e.getMessage());
                }
                request.getSession().setAttribute("cartMessage", "Item added to cart.");
            } else {
                request.getSession().setAttribute("cartMessage", "This item is currently unavailable or out of stock.");
            }
        } catch (SQLException ex) {
            System.out.println("AddToCart: SQLException while adding to cart: " + ex.getMessage());
            request.getSession().setAttribute("cartMessage", "Unable to add item right now.");
        }

        if (ValidationUtil.isRequiredValid(redirect)) {
            response.sendRedirect(request.getContextPath() + redirect);
        } else {
            response.sendRedirect(request.getContextPath() + "/cart");
        }
    }
}
