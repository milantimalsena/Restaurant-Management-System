package com.restaurant.controller;

import com.restaurant.util.ValidationUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebServlet("/contact-message")
public class ContactMessageServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");

        String fullName = ValidationUtil.sanitize(request.getParameter("fullName"));
        String email = ValidationUtil.sanitize(request.getParameter("email"));
        String subject = ValidationUtil.sanitize(request.getParameter("subject"));
        String message = ValidationUtil.sanitize(request.getParameter("message"));

        HttpSession session = request.getSession();

        if (isBlank(fullName) || isBlank(email) || isBlank(subject) || isBlank(message)) {
            session.setAttribute("contactError", "Please complete all required fields.");
            response.sendRedirect(request.getContextPath() + "/public/contact.jsp");
            return;
        }

        if (!ValidationUtil.isEmailValid(email)) {
            session.setAttribute("contactError", "Please enter a valid email address.");
            response.sendRedirect(request.getContextPath() + "/public/contact.jsp");
            return;
        }

        if (fullName.length() > 100 || subject.length() > 150 || message.length() > 1000) {
            session.setAttribute("contactError", "Your message is too long. Please shorten it and try again.");
            response.sendRedirect(request.getContextPath() + "/public/contact.jsp");
            return;
        }

        session.setAttribute("contactSuccess", "Thank you, " + fullName + ". Your message has been received.");
        response.sendRedirect(request.getContextPath() + "/public/contact.jsp");
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException {
        response.sendRedirect(request.getContextPath() + "/public/contact.jsp");
    }

    private boolean isBlank(String value) {
        return value == null || value.trim().isEmpty();
    }
}
