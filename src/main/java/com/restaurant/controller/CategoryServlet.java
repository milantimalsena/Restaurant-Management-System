package com.restaurant.controller;

import com.restaurant.dao.CategoryDAO;
import com.restaurant.model.Category;
import com.restaurant.util.SessionUtil;
import com.restaurant.util.ValidationUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

public class CategoryServlet extends HttpServlet {
    private final CategoryDAO categoryDAO = new CategoryDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        if (!SessionUtil.hasRole(request, "ADMIN")) {
            response.sendRedirect(request.getContextPath() + "/admin/login");
            return;
        }

        try {
            List<Category> categories = categoryDAO.getAllCategories();
            request.setAttribute("categories", categories);
            request.getRequestDispatcher("/admin/manage-categories.jsp").forward(request, response);
        } catch (SQLException ex) {
            request.setAttribute("errorMessage", "Unable to load categories.");
            request.getRequestDispatcher("/admin/manage-categories.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        if (!SessionUtil.hasRole(request, "ADMIN")) {
            response.sendRedirect(request.getContextPath() + "/admin/login");
            return;
        }

        String categoryName = ValidationUtil.sanitize(request.getParameter("categoryName"));
        String description = ValidationUtil.sanitize(request.getParameter("description"));
        boolean active = "on".equalsIgnoreCase(request.getParameter("isActive"));

        if (!ValidationUtil.isRequiredValid(categoryName)) {
            response.sendRedirect(request.getContextPath() + "/admin/categories");
            return;
        }

        Category category = new Category();
        category.setCategoryName(categoryName);
        category.setDescription(description);
        category.setActive(active);

        try {
            categoryDAO.addCategory(category);
        } catch (SQLException ignored) {
        }

        response.sendRedirect(request.getContextPath() + "/admin/categories");
    }
}
