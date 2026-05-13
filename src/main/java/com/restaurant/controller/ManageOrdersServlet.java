package com.restaurant.controller;

import com.restaurant.dao.OrderDAO;
import com.restaurant.model.Order;
import com.restaurant.util.SessionUtil;
import com.restaurant.util.ValidationUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.sql.SQLException;
import java.util.List;
import java.util.Set;

@WebServlet("/admin/manage-orders")
public class ManageOrdersServlet extends HttpServlet {
    private static final Set<String> VALID_ORDER_STATUSES = Set.of("Pending", "Preparing", "Ready", "Delivered", "Cancelled");
    private final OrderDAO orderDAO = new OrderDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        if (!SessionUtil.hasRole(request, "ADMIN")) {
            response.sendRedirect(request.getContextPath() + "/admin/login");
            return;
        }

        moveFlashMessagesToRequest(request);
        loadOrders(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        if (!SessionUtil.hasRole(request, "ADMIN")) {
            response.sendRedirect(request.getContextPath() + "/admin/login");
            return;
        }

        String orderIdValue = ValidationUtil.sanitize(request.getParameter("orderId"));
        String status = ValidationUtil.sanitize(request.getParameter("orderStatus"));
        HttpSession session = request.getSession();

        if (!ValidationUtil.isValidIntegerRange(orderIdValue, 1, Integer.MAX_VALUE) || !VALID_ORDER_STATUSES.contains(status)) {
            session.setAttribute("errorMessage", "Invalid order status update request.");
            response.sendRedirect(request.getContextPath() + "/admin/manage-orders");
            return;
        }

        try {
            boolean updated = orderDAO.updateOrderStatus(Integer.parseInt(orderIdValue), status);
            if (updated) {
                session.setAttribute("successMessage", "Order #" + orderIdValue + " updated to " + status + ".");
            } else {
                session.setAttribute("errorMessage", "Order was not found.");
            }
        } catch (SQLException | IllegalArgumentException ex) {
            ex.printStackTrace();
            session.setAttribute("errorMessage", "Unable to update order status right now.");
        }

        response.sendRedirect(request.getContextPath() + "/admin/manage-orders");
    }

    private void loadOrders(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            List<Order> orders = orderDAO.getAllOrders();
            request.setAttribute("orders", orders);
        } catch (SQLException ex) {
            ex.printStackTrace();
            request.setAttribute("errorMessage", "Unable to load orders.");
        }

        request.getRequestDispatcher("/admin/manage-orders.jsp").forward(request, response);
    }

    private void moveFlashMessagesToRequest(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session == null) {
            return;
        }

        moveFlashAttribute(session, request, "successMessage");
        moveFlashAttribute(session, request, "errorMessage");
    }

    private void moveFlashAttribute(HttpSession session, HttpServletRequest request, String attributeName) {
        Object message = session.getAttribute(attributeName);
        if (message != null) {
            request.setAttribute(attributeName, message);
            session.removeAttribute(attributeName);
        }
    }
}
