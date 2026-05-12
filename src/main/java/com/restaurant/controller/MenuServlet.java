package com.restaurant.controller;

import com.restaurant.dao.CategoryDAO;
import com.restaurant.dao.CartDAO;
import com.restaurant.dao.MenuItemDAO;
import com.restaurant.model.Category;
import com.restaurant.model.MenuItem;
import com.restaurant.util.SessionUtil;
import com.restaurant.util.ValidationUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

public class MenuServlet extends HttpServlet {
    private final CategoryDAO categoryDAO = new CategoryDAO();
    private final MenuItemDAO menuItemDAO = new MenuItemDAO();
    private final CartDAO cartDAO = new CartDAO();

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

            Long userId = SessionUtil.getLoggedInUserId(request);
            int cartCount = 0;
            if (userId != null) {
                cartCount = cartDAO.getCartCount(userId);
            }

            request.setAttribute("categories", categories);
            request.setAttribute("menuItems", items);
            request.setAttribute("featuredItems", featuredItems);
            request.setAttribute("selectedCategoryId", categoryIdParam);
            request.setAttribute("searchQuery", query);
            request.setAttribute("cartCount", cartCount);

            HttpSession session = request.getSession(false);
            if (session != null && session.getAttribute("cartMessage") != null) {
                request.setAttribute("cartMessage", session.getAttribute("cartMessage"));
                session.removeAttribute("cartMessage");
            }

            request.getRequestDispatcher("/public/menu-view.jsp").forward(request, response);
        } catch (SQLException ex) {
            ex.printStackTrace();
            request.setAttribute("errorMessage", "Unable to load menu right now.");
            request.getRequestDispatcher("/public/menu-view.jsp").forward(request, response);
        }
    }
}
