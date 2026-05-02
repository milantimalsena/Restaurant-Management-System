package com.restaurant.controller;

import com.restaurant.dao.OrderDAO;
import com.restaurant.model.Cart;
import com.restaurant.util.SessionUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.math.BigDecimal;
import java.math.RoundingMode;
import java.sql.SQLException;
import java.util.List;

public class CheckoutServlet extends HttpServlet {
    private static final BigDecimal TAX_RATE = new BigDecimal("0.10");
    private static final BigDecimal DELIVERY_FEE = new BigDecimal("100.00");
    private final OrderDAO orderDAO = new OrderDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        System.out.println("Servlet HIT: CheckoutServlet#doGet");
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
            List<Cart> cartItems = orderDAO.getCartItems(userId);
            if (cartItems.isEmpty()) {
                response.sendRedirect(request.getContextPath() + "/cart");
                return;
            }

            if (request.getSession(false) != null && request.getSession(false).getAttribute("checkoutError") != null) {
                request.setAttribute("checkoutError", request.getSession(false).getAttribute("checkoutError"));
                request.getSession(false).removeAttribute("checkoutError");
            }

            BigDecimal subtotal = orderDAO.getCartSubtotal(userId);
            BigDecimal tax = subtotal.multiply(TAX_RATE).setScale(2, RoundingMode.HALF_UP);
            BigDecimal grandTotal = subtotal.add(tax).setScale(2, RoundingMode.HALF_UP);

            request.setAttribute("cartItems", cartItems);
            request.setAttribute("subtotal", subtotal);
            request.setAttribute("tax", tax);
            request.setAttribute("deliveryFeeDefault", DELIVERY_FEE);
            request.setAttribute("grandTotalPreview", grandTotal);
            request.setAttribute("taxRate", TAX_RATE);
            request.getRequestDispatcher("/customer/checkout.jsp").forward(request, response);
        } catch (SQLException ex) {
            ex.printStackTrace();
            request.setAttribute("jakarta.servlet.error.status_code", 500);
            request.setAttribute("jakarta.servlet.error.request_uri", request.getRequestURI());
            request.setAttribute("jakarta.servlet.error.message", ex.getMessage());
            request.setAttribute("jakarta.servlet.error.exception", ex);
            request.setAttribute("debugMessage", "Checkout failed: " + ex.getMessage());
            request.getRequestDispatcher("/common/error.jsp").forward(request, response);
        }
    }
}
