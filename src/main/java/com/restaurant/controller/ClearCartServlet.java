package com.restaurant.controller;

import com.restaurant.dao.CartDAO;
import com.restaurant.util.SessionUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.sql.SQLException;

public class ClearCartServlet extends HttpServlet {
    private final CartDAO cartDAO = new CartDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        Long userId = SessionUtil.getLoggedInUserId(request);

        try {
            if (userId != null) {
                cartDAO.clearCart(userId);
            } else {
                jakarta.servlet.http.HttpSession session = request.getSession(false);
                if (session != null) {
                    session.removeAttribute("guestCart");
                    session.setAttribute("cartCount", 0);
                }
            }
        } catch (SQLException ignored) {
        }

        response.sendRedirect(request.getContextPath() + "/cart");
    }
}
