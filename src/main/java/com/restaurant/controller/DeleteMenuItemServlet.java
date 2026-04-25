package com.restaurant.controller;

import com.restaurant.dao.MenuItemDAO;
import com.restaurant.util.SessionUtil;
import com.restaurant.util.ValidationUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.sql.SQLException;

public class DeleteMenuItemServlet extends HttpServlet {
    private final MenuItemDAO menuItemDAO = new MenuItemDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        if (!SessionUtil.hasRole(request, "ADMIN")) {
            response.sendRedirect(request.getContextPath() + "/admin/login");
            return;
        }

        String itemId = ValidationUtil.sanitize(request.getParameter("itemId"));
        if (!ValidationUtil.isValidIntegerRange(itemId, 1, Integer.MAX_VALUE)) {
            response.sendRedirect(request.getContextPath() + "/admin/manage-menu");
            return;
        }

        try {
            menuItemDAO.deleteItem(Long.parseLong(itemId));
        } catch (SQLException ignored) {
        }

        response.sendRedirect(request.getContextPath() + "/admin/manage-menu");
    }
}
