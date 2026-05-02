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
        Long userId = SessionUtil.getLoggedInUserId(request);
        String itemIdParam = ValidationUtil.sanitize(request.getParameter("itemId"));
        String qtyParam = ValidationUtil.sanitize(request.getParameter("qty"));
        String redirect = ValidationUtil.sanitize(request.getParameter("redirect"));

        if (!ValidationUtil.isValidIntegerRange(itemIdParam, 1, Integer.MAX_VALUE)) {
            response.sendRedirect(request.getContextPath() + "/menu");
            return;
        }

        int qty = 1;
        if (ValidationUtil.isValidIntegerRange(qtyParam, 1, 20)) {
            qty = Integer.parseInt(qtyParam);
        }

        long itemId = Long.parseLong(itemIdParam);

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

        // If user is logged in as CUSTOMER use persistent cart
        if (SessionUtil.hasRole(request, "CUSTOMER") && userId != null) {
            try {
                boolean success = cartDAO.addToCart(userId, itemId, qty);
                request.getSession().setAttribute("cartMessage", success ? "Item added to cart." : "This item is currently unavailable or out of stock.");
            } catch (SQLException ex) {
                request.getSession().setAttribute("cartMessage", "Unable to add item right now.");
            }
        } else {
            // Allow guests to add items into session-based cart
            HttpSession session = request.getSession(true);
            @SuppressWarnings("unchecked")
            Map<Long, Integer> guestCart = (Map<Long, Integer>) session.getAttribute("guestCart");
            if (guestCart == null) {
                guestCart = new HashMap<>();
            }
            int existing = guestCart.getOrDefault(itemId, 0);
            int newQty = ValidationUtil.clampQuantity(existing + qty);
            guestCart.put(itemId, newQty);
            session.setAttribute("guestCart", guestCart);

            // store cart count in session for navbar convenience
            int cartCount = guestCart.values().stream().mapToInt(Integer::intValue).sum();
            session.setAttribute("cartCount", cartCount);
            session.setAttribute("cartMessage", "Item added to cart.");
        }

        if (ValidationUtil.isRequiredValid(redirect)) {
            response.sendRedirect(request.getContextPath() + redirect);
        } else {
            response.sendRedirect(request.getContextPath() + "/cart");
        }
    }
}
