package com.restaurant.controller;

import com.restaurant.dao.CategoryDAO;
import com.restaurant.dao.MenuItemDAO;
import com.restaurant.model.Category;
import com.restaurant.model.MenuItem;
import com.restaurant.util.SessionUtil;
import com.restaurant.util.ValidationUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class ManageMenuServlet extends HttpServlet {
    private final MenuItemDAO menuItemDAO = new MenuItemDAO();
    private final CategoryDAO categoryDAO = new CategoryDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        if (!SessionUtil.hasRole(request, "ADMIN")) {
            response.sendRedirect(request.getContextPath() + "/admin/login");
            return;
        }

        String query = ValidationUtil.sanitize(request.getParameter("q"));
        String categoryIdParam = ValidationUtil.sanitize(request.getParameter("categoryId"));

        try {
            List<MenuItem> items;
            if (ValidationUtil.isRequiredValid(query)) {
                items = menuItemDAO.searchItems(query);
            } else if (ValidationUtil.isValidIntegerRange(categoryIdParam, 1, Integer.MAX_VALUE)) {
                items = menuItemDAO.filterByCategory(Long.parseLong(categoryIdParam));
            } else {
                items = menuItemDAO.getAllItems();
            }

            List<Category> categories = categoryDAO.getAllCategories();

            request.setAttribute("items", items);
            request.setAttribute("categories", categories);
            request.setAttribute("searchQuery", query);
            request.setAttribute("selectedCategoryId", categoryIdParam);
            request.getRequestDispatcher("/admin/manage-menu.jsp").forward(request, response);
        } catch (SQLException ex) {
            request.setAttribute("errorMessage", "Failed to load menu management data.");
            request.getRequestDispatcher("/admin/manage-menu.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        if (!SessionUtil.hasRole(request, "ADMIN")) {
            response.sendRedirect(request.getContextPath() + "/admin/login");
            return;
        }

        String action = ValidationUtil.sanitize(request.getParameter("action"));
        if (!"bulkAvailability".equals(action)) {
            response.sendRedirect(request.getContextPath() + "/admin/manage-menu");
            return;
        }

        String availability = ValidationUtil.sanitize(request.getParameter("availability"));
        String[] ids = request.getParameterValues("selectedItemIds");
        if (ids == null || ids.length == 0) {
            response.sendRedirect(request.getContextPath() + "/admin/manage-menu");
            return;
        }

        List<Long> itemIds = new ArrayList<>();
        for (String id : ids) {
            if (ValidationUtil.isValidIntegerRange(id, 1, Integer.MAX_VALUE)) {
                itemIds.add(Long.parseLong(id));
            }
        }

        try {
            menuItemDAO.bulkUpdateAvailability(itemIds, "available".equalsIgnoreCase(availability));
        } catch (SQLException ignored) {
        }

        response.sendRedirect(request.getContextPath() + "/admin/manage-menu");
    }
}
