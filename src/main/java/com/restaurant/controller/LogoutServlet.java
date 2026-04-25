package com.restaurant.controller;

import com.restaurant.util.SessionUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

public class LogoutServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        SessionUtil.invalidateSession(request);

        Cookie rememberCookie = new Cookie("rememberedEmail", "");
        rememberCookie.setHttpOnly(true);
        rememberCookie.setMaxAge(0);
        rememberCookie.setPath(request.getContextPath().isEmpty() ? "/" : request.getContextPath());
        response.addCookie(rememberCookie);

        response.sendRedirect(request.getContextPath() + "/login");
    }
}
