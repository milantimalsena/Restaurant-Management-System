package com.restaurant.controller;

import com.restaurant.dao.CategoryDAO;
import com.restaurant.dao.MenuItemDAO;
import com.restaurant.model.Category;
import com.restaurant.model.MenuItem;
import com.restaurant.util.ValidationUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

public class MenuServlet extends HttpServlet {
    private final CategoryDAO categoryDAO = new CategoryDAO();
    private final MenuItemDAO menuItemDAO = new MenuItemDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String itemIdParam = ValidationUtil.sanitize(request.getParameter("itemId"));
        String categoryIdParam = ValidationUtil.sanitize(request.getParameter("categoryId"));
        String query = ValidationUtil.sanitize(request.getParameter("q"));

        try {
            if (ValidationUtil.isValidIntegerRange(itemIdParam, 1, Integer.MAX_VALUE)) {
                MenuItem item = menuItemDAO.getById(Long.parseLong(itemIdParam));
                if (item == null) {
                    response.sendRedirect(request.getContextPath() + "/menu");
                    return;
                }
                request.setAttribute("menuItemDetail", item);
                request.getRequestDispatcher("/public/item-details.jsp").forward(request, response);
                return;
            }

            List<Category> categories = categoryDAO.getAllActiveCategories();
            List<MenuItem> items;
            if (ValidationUtil.isRequiredValid(query)) {
                items = menuItemDAO.searchItems(query);
            } else if (ValidationUtil.isValidIntegerRange(categoryIdParam, 1, Integer.MAX_VALUE)) {
                items = menuItemDAO.filterByCategory(Long.parseLong(categoryIdParam));
            } else {
                items = menuItemDAO.getAllItems();
            }

            List<MenuItem> featuredItems = menuItemDAO.getFeaturedItems();
            request.setAttribute("categories", categories);
            request.setAttribute("menuItems", items);
            request.setAttribute("featuredItems", featuredItems);
            request.setAttribute("selectedCategoryId", categoryIdParam);
            request.setAttribute("searchQuery", query);
            request.getRequestDispatcher("/public/menu.jsp").forward(request, response);
        } catch (SQLException ex) {
            request.setAttribute("errorMessage", "Unable to load menu right now.");
            request.getRequestDispatcher("/public/menu.jsp").forward(request, response);
        }
    }
}
