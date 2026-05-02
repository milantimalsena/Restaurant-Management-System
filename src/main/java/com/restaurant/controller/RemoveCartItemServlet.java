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
        Long userId = SessionUtil.getLoggedInUserId(request);

        String cartIdParam = ValidationUtil.sanitize(request.getParameter("cartId"));
        if (!ValidationUtil.isValidIntegerRange(cartIdParam, 1, Integer.MAX_VALUE)) {
            response.sendRedirect(request.getContextPath() + "/cart");
            return;
        }

        long idParam = Long.parseLong(cartIdParam);
        try {
            if (userId != null) {
                // persistent cart remove by cartId
                cartDAO.removeItemForUser(userId, idParam);
            } else {
                // guest remove by itemId stored in cartId param
                jakarta.servlet.http.HttpSession session = request.getSession(false);
                if (session != null) {
                    @SuppressWarnings("unchecked")
                    java.util.Map<Long, Integer> guestCart = (java.util.Map<Long, Integer>) session.getAttribute("guestCart");
                    if (guestCart != null) {
                        guestCart.remove(idParam);
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
