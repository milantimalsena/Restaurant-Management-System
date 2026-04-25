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

public class RegisterServlet extends HttpServlet {
    private final UserDAO userDAO = new UserDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.getRequestDispatcher("/public/register.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String fullName = request.getParameter("fullName");
        String email = request.getParameter("email");
        String phone = request.getParameter("phone");
        String password = request.getParameter("password");
        String address = request.getParameter("address");

        if (!ValidationUtil.isRequiredValid(fullName)
                || !ValidationUtil.isEmailValid(email)
                || !ValidationUtil.isPhoneValid(phone)
                || !ValidationUtil.isPasswordValid(password)) {
            request.setAttribute("errorMessage", "Please fill all fields correctly. Password must be at least 8 characters.");
            request.getRequestDispatcher("/public/register.jsp").forward(request, response);
            return;
        }

        try {
            if (userDAO.emailExists(email.trim())) {
                request.setAttribute("errorMessage", "Email is already registered. Please use another email.");
                request.getRequestDispatcher("/public/register.jsp").forward(request, response);
                return;
            }

            User user = new User();
            user.setFullName(fullName.trim());
            user.setEmail(email.trim().toLowerCase());
            user.setPhone(phone.trim());
            user.setPasswordHash(PasswordUtil.hashPassword(password));
            user.setAddress(address == null ? null : address.trim());

            boolean created = userDAO.createUser(user);
            if (created) {
                request.getSession().setAttribute("successMessage", "Registration successful. Please login.");
                response.sendRedirect(request.getContextPath() + "/login");
            } else {
                request.setAttribute("errorMessage", "Registration failed. Please try again.");
                request.getRequestDispatcher("/public/register.jsp").forward(request, response);
            }
        } catch (SQLException ex) {
            request.setAttribute("errorMessage", "Unable to process request at the moment.");
            request.getRequestDispatcher("/public/register.jsp").forward(request, response);
        }
    }
}
