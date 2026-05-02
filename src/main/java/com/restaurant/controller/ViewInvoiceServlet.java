package com.restaurant.controller;

import com.restaurant.dao.OrderDAO;
import com.restaurant.model.Order;
import com.restaurant.util.InvoiceUtil;
import com.restaurant.util.SessionUtil;
import com.restaurant.util.ValidationUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.sql.SQLException;

public class ViewInvoiceServlet extends HttpServlet {
    private final OrderDAO orderDAO = new OrderDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        System.out.println("Servlet HIT: ViewInvoiceServlet#doGet");
        if (!SessionUtil.hasRole(request, "CUSTOMER")) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String orderIdParam = ValidationUtil.sanitize(request.getParameter("orderId"));
        if (!ValidationUtil.isValidIntegerRange(orderIdParam, 1, Integer.MAX_VALUE)) {
            response.sendRedirect(request.getContextPath() + "/my-orders");
            return;
        }

        try {
            Order order = orderDAO.getOrderById(Long.parseLong(orderIdParam));
            Long userId = SessionUtil.getLoggedInUserId(request);
            if (order == null || userId == null || !userId.equals(order.getUserId())) {
                response.sendRedirect(request.getContextPath() + "/my-orders");
                return;
            }

            request.setAttribute("order", order);
            request.setAttribute("invoiceHtml", InvoiceUtil.buildInvoiceHtml(order));
            request.getRequestDispatcher("/customer/invoice.jsp").forward(request, response);
        } catch (SQLException ex) {
            ex.printStackTrace();
            request.setAttribute("debugMessage", "Unable to load invoice details: " + ex.getMessage());
            request.getRequestDispatcher("/common/error.jsp").forward(request, response);
        }
    }
}
