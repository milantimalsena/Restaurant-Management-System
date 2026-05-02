package com.restaurant.controller;

import com.restaurant.dao.UserDAO;
import com.restaurant.model.User;
import com.restaurant.util.PasswordUtil;
import com.restaurant.util.SessionUtil;
import com.restaurant.util.ValidationUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.sql.SQLException;

public class LoginServlet extends HttpServlet {
    private final UserDAO userDAO = new UserDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        System.out.println("Servlet HIT: LoginServlet#doGet");
        if (SessionUtil.hasRole(request, "CUSTOMER")) {
            response.sendRedirect(request.getContextPath() + "/customer/dashboard.jsp");
            return;
        }

        Cookie[] cookies = request.getCookies();
        if (cookies != null) {
            for (Cookie cookie : cookies) {
                if ("rememberedEmail".equals(cookie.getName())) {
                    request.setAttribute("rememberedEmail", cookie.getValue());
                    break;
                }
            }
        }

        HttpSession session = request.getSession(false);
        if (session != null) {
            Object successMessage = session.getAttribute("successMessage");
            if (successMessage != null) {
                request.setAttribute("successMessage", successMessage);
                session.removeAttribute("successMessage");
            }
        }

        request.getRequestDispatcher("/public/login.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        System.out.println("Servlet HIT: LoginServlet#doPost");
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String remember = request.getParameter("rememberMe");

        if (!ValidationUtil.isEmailValid(email) || !ValidationUtil.isPasswordValid(password)) {
            request.setAttribute("errorMessage", "Invalid email or password format.");
            request.getRequestDispatcher("/public/login.jsp").forward(request, response);
            return;
        }

        try {
            User user = userDAO.findByEmail(email.trim().toLowerCase());
            if (user == null || !PasswordUtil.verifyPassword(password, user.getPasswordHash())) {
                request.setAttribute("errorMessage", "Invalid credentials.");
                request.getRequestDispatcher("/public/login.jsp").forward(request, response);
                return;
            }

            if (!"ACTIVE".equalsIgnoreCase(user.getStatus())) {
                request.setAttribute("errorMessage", "Your account is blocked. Contact support.");
                request.getRequestDispatcher("/public/login.jsp").forward(request, response);
                return;
            }

            SessionUtil.createUserSession(request, user.getUserId(), user.getFullName(), user.getEmail());

            Cookie rememberCookie = new Cookie("rememberedEmail", user.getEmail());
            rememberCookie.setHttpOnly(true);
            rememberCookie.setPath(request.getContextPath().isEmpty() ? "/" : request.getContextPath());
            if ("on".equalsIgnoreCase(remember)) {
                rememberCookie.setMaxAge(7 * 24 * 60 * 60);
            } else {
                rememberCookie.setMaxAge(0);
            }
            response.addCookie(rememberCookie);

            response.sendRedirect(request.getContextPath() + "/customer/dashboard.jsp");
        } catch (SQLException ex) {
            ex.printStackTrace();
            request.setAttribute("jakarta.servlet.error.status_code", 500);
            request.setAttribute("jakarta.servlet.error.request_uri", request.getRequestURI());
            request.setAttribute("jakarta.servlet.error.message", ex.getMessage());
            request.setAttribute("jakarta.servlet.error.exception", ex);
            request.setAttribute("debugMessage", "Login failed: " + ex.getMessage());
            request.getRequestDispatcher("/common/error.jsp").forward(request, response);
        }
    }
}
