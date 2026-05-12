package com.restaurant.controller;

import com.restaurant.dao.ReservationDAO;
import com.restaurant.model.RestaurantTable;
import com.restaurant.util.SessionUtil;
import com.restaurant.util.ValidationUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.sql.SQLException;
import java.util.Set;

public class AdminReservationServlet extends HttpServlet {
    private static final Set<String> VALID_STATUSES = Set.of("APPROVED", "REJECTED", "CANCELLED", "COMPLETED");
    private final ReservationDAO reservationDAO = new ReservationDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        if (!SessionUtil.hasRole(request, "ADMIN")) {
            response.sendRedirect(request.getContextPath() + "/admin/login");
            return;
        }

        loadAdminPage(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        if (!SessionUtil.hasRole(request, "ADMIN")) {
            response.sendRedirect(request.getContextPath() + "/admin/login");
            return;
        }

        String action = ValidationUtil.sanitize(request.getParameter("action"));
        try {
            if ("addTable".equals(action)) {
                addTable(request);
            } else if ("toggleTable".equals(action)) {
                toggleTable(request);
            } else if ("updateStatus".equals(action)) {
                updateStatus(request);
            }
            response.sendRedirect(request.getContextPath() + "/admin/manage-reservations");
        } catch (SQLException ex) {
            ex.printStackTrace();
            request.setAttribute("errorMessage", "Unable to update reservations right now.");
            loadAdminPage(request, response);
        }
    }

    private void addTable(HttpServletRequest request) throws SQLException {
        String tableNumber = ValidationUtil.sanitize(request.getParameter("tableNumber"));
        String capacityValue = ValidationUtil.sanitize(request.getParameter("capacity"));

        if (!ValidationUtil.isRequiredValid(tableNumber) || !ValidationUtil.isValidIntegerRange(capacityValue, 1, 30)) {
            return;
        }

        RestaurantTable table = new RestaurantTable();
        table.setTableNumber(tableNumber);
        table.setCapacity(Integer.parseInt(capacityValue));
        table.setActive(true);
        reservationDAO.addTable(table);
    }

    private void toggleTable(HttpServletRequest request) throws SQLException {
        String tableIdValue = ValidationUtil.sanitize(request.getParameter("tableId"));
        boolean active = "true".equalsIgnoreCase(request.getParameter("active"));

        if (ValidationUtil.isValidIntegerRange(tableIdValue, 1, Integer.MAX_VALUE)) {
            reservationDAO.setTableActive(Long.parseLong(tableIdValue), active);
        }
    }

    private void updateStatus(HttpServletRequest request) throws SQLException {
        String bookingIdValue = ValidationUtil.sanitize(request.getParameter("bookingId"));
        String status = ValidationUtil.sanitize(request.getParameter("status"));

        if (ValidationUtil.isValidIntegerRange(bookingIdValue, 1, Integer.MAX_VALUE)
                && status != null
                && VALID_STATUSES.contains(status.toUpperCase())) {
            reservationDAO.updateReservationStatus(Long.parseLong(bookingIdValue), status.toUpperCase());
        }
    }

    private void loadAdminPage(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            request.setAttribute("totalReservations", reservationDAO.countReservations());
            request.setAttribute("pendingBookings", reservationDAO.countPendingReservations());
            request.setAttribute("approvedToday", reservationDAO.countApprovedToday());
            request.setAttribute("reservationList", reservationDAO.getAllReservations());
            request.setAttribute("tableList", reservationDAO.getAllTables());
        } catch (SQLException ex) {
            ex.printStackTrace();
            request.setAttribute("errorMessage", "Unable to load reservation management data.");
        }
        request.getRequestDispatcher("/admin/manage-reservations.jsp").forward(request, response);
    }
}
