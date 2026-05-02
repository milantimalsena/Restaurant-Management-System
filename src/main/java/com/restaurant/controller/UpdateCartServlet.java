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
        Long userId = SessionUtil.getLoggedInUserId(request);

        String cartIdParam = ValidationUtil.sanitize(request.getParameter("cartId"));
        String action = ValidationUtil.sanitize(request.getParameter("action"));
        String qtyParam = ValidationUtil.sanitize(request.getParameter("qty"));

        if (!ValidationUtil.isValidIntegerRange(cartIdParam, 1, Integer.MAX_VALUE)) {
            response.sendRedirect(request.getContextPath() + "/cart");
            return;
        }

        long idParam = Long.parseLong(cartIdParam);
        try {
            if (userId != null) {
                // persistent cart operations using cartId
                long cartId = idParam;
                if ("increase".equalsIgnoreCase(action)) {
                    cartDAO.increaseQtyForUser(userId, cartId);
                } else if ("decrease".equalsIgnoreCase(action)) {
                    cartDAO.decreaseQtyForUser(userId, cartId);
                } else if ("manual".equalsIgnoreCase(action) && ValidationUtil.isValidIntegerRange(qtyParam, 1, 20)) {
                    cartDAO.updateQuantityForUser(userId, cartId, Integer.parseInt(qtyParam));
                }
            } else {
                // guest session cart operations using itemId in place of cartId
                jakarta.servlet.http.HttpSession session = request.getSession(false);
                if (session != null) {
                    @SuppressWarnings("unchecked")
                    java.util.Map<Long, Integer> guestCart = (java.util.Map<Long, Integer>) session.getAttribute("guestCart");
                    if (guestCart != null) {
                        Long itemId = idParam;
                        int current = guestCart.getOrDefault(itemId, 0);
                        int newQty = current;
                        if ("increase".equalsIgnoreCase(action)) {
                            newQty = Math.min(20, current + 1);
                        } else if ("decrease".equalsIgnoreCase(action)) {
                            newQty = Math.max(1, current - 1);
                        } else if ("manual".equalsIgnoreCase(action) && ValidationUtil.isValidIntegerRange(qtyParam, 1, 20)) {
                            newQty = Integer.parseInt(qtyParam);
                        }
                        if (newQty <= 0) {
                            guestCart.remove(itemId);
                        } else {
                            guestCart.put(itemId, newQty);
                        }
                        session.setAttribute("guestCart", guestCart);
                        int cartCount = guestCart.values().stream().mapToInt(Integer::intValue).sum();
                        session.setAttribute("cartCount", cartCount);
                    }
                }
            }
        } catch (SQLException ignored) {
        }

        response.sendRedirect(request.getContextPath() + "/cart");
    }
}
