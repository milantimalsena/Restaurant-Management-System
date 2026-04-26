package com.restaurant.controller;

import com.restaurant.dao.CartDAO;
import com.restaurant.model.Cart;
import com.restaurant.util.SessionUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.math.BigDecimal;
import java.math.RoundingMode;
import java.sql.SQLException;
import java.util.List;

public class ViewCartServlet extends HttpServlet {
    private static final BigDecimal TAX_RATE = new BigDecimal("0.13");
    private final CartDAO cartDAO = new CartDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        if (!SessionUtil.hasRole(request, "CUSTOMER")) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        Long userId = SessionUtil.getLoggedInUserId(request);
        if (userId == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        try {
            List<Cart> carts = cartDAO.getCartByUser(userId);
            BigDecimal subtotal = cartDAO.getSubtotal(userId);
            BigDecimal tax = subtotal.multiply(TAX_RATE).setScale(2, RoundingMode.HALF_UP);
            BigDecimal grandTotal = subtotal.add(tax);
            int cartCount = cartDAO.getCartCount(userId);

            request.setAttribute("cartItems", carts);
            request.setAttribute("subtotal", subtotal);
            request.setAttribute("tax", tax);
            request.setAttribute("grandTotal", grandTotal);
            request.setAttribute("cartCount", cartCount);

            HttpSession session = request.getSession(false);
            if (session != null && session.getAttribute("cartMessage") != null) {
                request.setAttribute("cartMessage", session.getAttribute("cartMessage"));
                session.removeAttribute("cartMessage");
            }

            request.getRequestDispatcher("/customer/cart.jsp").forward(request, response);
        } catch (SQLException ex) {
            request.setAttribute("errorMessage", "Unable to load cart right now.");
            request.getRequestDispatcher("/customer/cart.jsp").forward(request, response);
        }
    }
}
