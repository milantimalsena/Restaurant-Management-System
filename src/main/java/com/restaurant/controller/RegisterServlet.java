package com.restaurant.controller;

import com.restaurant.dao.UserDAO;
import com.restaurant.model.User;
import com.restaurant.util.PasswordUtil;
import com.restaurant.util.ValidationUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.sql.SQLException;
import java.util.logging.Level;
import java.util.logging.Logger;

public class RegisterServlet extends HttpServlet {
    private static final Logger LOGGER = Logger.getLogger(RegisterServlet.class.getName());
    private final UserDAO userDAO = new UserDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        System.out.println("Servlet HIT: RegisterServlet#doGet");
        request.getRequestDispatcher("/public/register.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        System.out.println("Servlet HIT: RegisterServlet#doPost");
        String fullName = ValidationUtil.sanitize(request.getParameter("fullName"));
        String email = ValidationUtil.sanitize(request.getParameter("email"));
        String phone = ValidationUtil.sanitize(request.getParameter("phone"));
        String password = request.getParameter("password");
        String address = ValidationUtil.sanitize(request.getParameter("address"));

        request.setAttribute("fullName", fullName);
        request.setAttribute("email", email);
        request.setAttribute("phone", phone);
        request.setAttribute("address", address);

        if (!ValidationUtil.isRequiredValid(fullName)
                || !ValidationUtil.isEmailValid(email)
                || !ValidationUtil.isPhoneValid(phone)
                || !ValidationUtil.isPasswordValid(password)) {
            request.setAttribute("errorMessage", "Please fill all fields correctly. Password must be at least 8 characters.");
            request.getRequestDispatcher("/public/register.jsp").forward(request, response);
            return;
        }

        try {
            String normalizedEmail = email.toLowerCase();
            if (userDAO.emailExists(normalizedEmail)) {
                // Provide clearer message when an account with the email already exists
                request.setAttribute("errorMessage", "The user with this email already exists.");
                request.getRequestDispatcher("/public/register.jsp").forward(request, response);
                return;
            }

            if (userDAO.phoneExists(phone)) {
                request.setAttribute("errorMessage", "Phone number is already registered. Please use another phone number.");
                request.getRequestDispatcher("/public/register.jsp").forward(request, response);
                return;
            }

            User user = new User();
            user.setFullName(fullName);
            user.setEmail(normalizedEmail);
            user.setPhone(phone);
            user.setPasswordHash(PasswordUtil.hashPassword(password));
            user.setAddress(address);
            user.setStatus("ACTIVE");

            boolean created = userDAO.createUser(user);
            if (created) {
                request.getSession().setAttribute("successMessage", "Registration successful. Please login.");
                response.sendRedirect(request.getContextPath() + "/login");
            } else {
                request.setAttribute("errorMessage", "Registration failed. Please try again.");
                request.getRequestDispatcher("/public/register.jsp").forward(request, response);
            }
        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, "Registration failed in RegisterServlet", ex);
            ex.printStackTrace();
            request.setAttribute("jakarta.servlet.error.status_code", 500);
            request.setAttribute("jakarta.servlet.error.request_uri", request.getRequestURI());
            request.setAttribute("jakarta.servlet.error.message", ex.getMessage());
            request.setAttribute("jakarta.servlet.error.exception", ex);
            request.setAttribute("debugMessage", "Registration failed: " + ex.getMessage());
            request.getRequestDispatcher("/common/error.jsp").forward(request, response);
        }
    }
}
