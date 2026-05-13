package com.restaurant.controller;

import com.restaurant.dao.OrderDAO;
import com.restaurant.model.Order;
import com.restaurant.util.SessionUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

@WebServlet("/customer/orders")
public class CustomerOrdersServlet extends HttpServlet {
    private final OrderDAO orderDAO = new OrderDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        if (!SessionUtil.hasRole(request, "CUSTOMER")) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        Long userId = SessionUtil.getLoggedInUserId(request);
        if (userId == null || userId > Integer.MAX_VALUE) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        try {
            List<Order> orders = orderDAO.getOrdersByUserId(userId.intValue());
            request.setAttribute("orders", orders);
        } catch (SQLException ex) {
            ex.printStackTrace();
            request.setAttribute("errorMessage", "Unable to load your latest orders.");
        }

        request.getRequestDispatcher("/customer/orders.jsp").forward(request, response);
    }
}
