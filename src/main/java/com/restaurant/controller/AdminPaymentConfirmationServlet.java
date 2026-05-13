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

@WebServlet("/admin/payment-confirmation")
public class AdminPaymentConfirmationServlet extends HttpServlet {
    private static final Set<String> VALID_PAYMENT_STATUSES = Set.of("Paid", "Rejected");
    private final OrderDAO orderDAO = new OrderDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        if (!SessionUtil.hasRole(request, "ADMIN")) {
            response.sendRedirect(request.getContextPath() + "/admin/login");
            return;
        }

        moveFlashMessagesToRequest(request);
        loadPendingPayments(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        if (!SessionUtil.hasRole(request, "ADMIN")) {
            response.sendRedirect(request.getContextPath() + "/admin/login");
            return;
        }

        String orderIdValue = ValidationUtil.sanitize(request.getParameter("orderId"));
        String status = resolvePaymentStatus(ValidationUtil.sanitize(request.getParameter("action")));
        HttpSession session = request.getSession();

        if (!ValidationUtil.isValidIntegerRange(orderIdValue, 1, Integer.MAX_VALUE) || status == null) {
            session.setAttribute("errorMessage", "Invalid payment confirmation request.");
            response.sendRedirect(request.getContextPath() + "/admin/payment-confirmation");
            return;
        }

        try {
            boolean updated = orderDAO.updatePaymentStatus(Integer.parseInt(orderIdValue), status);
            if (updated) {
                session.setAttribute("successMessage", "Payment status updated to " + status + ".");
            } else {
                session.setAttribute("errorMessage", "Order was not found.");
            }
        } catch (SQLException | IllegalArgumentException ex) {
            ex.printStackTrace();
            session.setAttribute("errorMessage", "Unable to update payment status right now.");
        }

        response.sendRedirect(request.getContextPath() + "/admin/payment-confirmation");
    }

    private void loadPendingPayments(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            List<Order> pendingPaymentOrders = orderDAO.getPendingPaymentOrders();
            request.setAttribute("pendingPaymentOrders", pendingPaymentOrders);
        } catch (SQLException ex) {
            ex.printStackTrace();
            request.setAttribute("errorMessage", "Unable to load pending payment orders.");
        }

        request.getRequestDispatcher("/admin/payment-confirmation.jsp").forward(request, response);
    }

    private String resolvePaymentStatus(String action) {
        String status = null;
        if ("confirm".equalsIgnoreCase(action)) {
            status = "Paid";
        } else if ("reject".equalsIgnoreCase(action)) {
            status = "Rejected";
        }

        return VALID_PAYMENT_STATUSES.contains(status) ? status : null;
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
