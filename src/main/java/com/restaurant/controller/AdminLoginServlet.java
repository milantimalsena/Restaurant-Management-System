package com.restaurant.controller;

import com.restaurant.dao.AdminDAO;
import com.restaurant.model.Admin;
import com.restaurant.util.PasswordUtil;
import com.restaurant.util.SessionUtil;
import com.restaurant.util.ValidationUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.sql.SQLException;

public class AdminLoginServlet extends HttpServlet {
    private final AdminDAO adminDAO = new AdminDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        if (SessionUtil.hasRole(request, "ADMIN")) {
            response.sendRedirect(request.getContextPath() + "/admin/dashboard.jsp");
            return;
        }
        request.getRequestDispatcher("/admin/admin-login.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String email = request.getParameter("email");
        String password = request.getParameter("password");

        if (!ValidationUtil.isEmailValid(email) || !ValidationUtil.isPasswordValid(password)) {
            request.setAttribute("errorMessage", "Invalid email or password format.");
            request.getRequestDispatcher("/admin/admin-login.jsp").forward(request, response);
            return;
        }

        try {
            Admin admin = adminDAO.findByEmail(email.trim().toLowerCase());
            if (admin == null || !PasswordUtil.verifyPassword(password, admin.getPasswordHash())) {
                request.setAttribute("errorMessage", "Invalid admin credentials.");
                request.getRequestDispatcher("/admin/admin-login.jsp").forward(request, response);
                return;
            }

            if (!"ACTIVE".equalsIgnoreCase(admin.getStatus())) {
                request.setAttribute("errorMessage", "Admin account is blocked.");
                request.getRequestDispatcher("/admin/admin-login.jsp").forward(request, response);
                return;
            }

            SessionUtil.createAdminSession(request, admin.getAdminId(), admin.getFullName(), admin.getEmail());
            response.sendRedirect(request.getContextPath() + "/admin/dashboard.jsp");
        } catch (SQLException ex) {
            request.setAttribute("errorMessage", "Unable to process request at the moment.");
            request.getRequestDispatcher("/admin/admin-login.jsp").forward(request, response);
        }
    }
}
