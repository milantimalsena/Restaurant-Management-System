package com.restaurant.controller;

import com.restaurant.dao.OrderDAO;
import com.restaurant.dao.ReservationDAO;
import com.restaurant.dao.UserDAO;
import com.restaurant.util.SessionUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.math.BigDecimal;
import java.sql.SQLException;
import java.util.List;

@WebServlet("/admin/dashboard")
public class AdminDashboardServlet extends HttpServlet {
    private final OrderDAO orderDAO = new OrderDAO();
    private final UserDAO userDAO = new UserDAO();
    private final ReservationDAO reservationDAO = new ReservationDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        if (!SessionUtil.hasRole(request, "ADMIN")) {
            response.sendRedirect(request.getContextPath() + "/admin/login");
            return;
        }

        try {
            request.setAttribute("totalOrders", orderDAO.countOrders());
            request.setAttribute("revenue", orderDAO.getTotalRevenue());
            request.setAttribute("customers", userDAO.countUsers());
            request.setAttribute("reservations", reservationDAO.countReservations());
            request.setAttribute("recentOrders", orderDAO.getRecentOrders(8));
        } catch (SQLException ex) {
            ex.printStackTrace();
            request.setAttribute("totalOrders", 0);
            request.setAttribute("revenue", BigDecimal.ZERO);
            request.setAttribute("customers", 0);
            request.setAttribute("reservations", 0);
            request.setAttribute("recentOrders", List.of());
            request.setAttribute("errorMessage", "Unable to load dashboard summary right now.");
        }

        request.setAttribute("dashboardLoaded", true);
        request.getRequestDispatcher("/admin/dashboard.jsp").forward(request, response);
    }
}
