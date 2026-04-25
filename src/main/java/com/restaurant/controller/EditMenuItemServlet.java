package com.restaurant.controller;

import com.restaurant.dao.CategoryDAO;
import com.restaurant.dao.MenuItemDAO;
import com.restaurant.model.Category;
import com.restaurant.model.MenuItem;
import com.restaurant.util.FileUploadUtil;
import com.restaurant.util.SessionUtil;
import com.restaurant.util.ValidationUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;

import java.io.File;
import java.io.IOException;
import java.math.BigDecimal;
import java.sql.SQLException;
import java.util.List;

@MultipartConfig(
        fileSizeThreshold = 1024 * 1024,
        maxFileSize = 5 * 1024 * 1024,
        maxRequestSize = 8 * 1024 * 1024
)
public class EditMenuItemServlet extends HttpServlet {
    private final MenuItemDAO menuItemDAO = new MenuItemDAO();
    private final CategoryDAO categoryDAO = new CategoryDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        if (!SessionUtil.hasRole(request, "ADMIN")) {
            response.sendRedirect(request.getContextPath() + "/admin/login");
            return;
        }

        String idParam = ValidationUtil.sanitize(request.getParameter("id"));
        if (!ValidationUtil.isValidIntegerRange(idParam, 1, Integer.MAX_VALUE)) {
            response.sendRedirect(request.getContextPath() + "/admin/manage-menu");
            return;
        }

        try {
            MenuItem item = menuItemDAO.getById(Long.parseLong(idParam));
            List<Category> categories = categoryDAO.getAllActiveCategories();
            if (item == null) {
                response.sendRedirect(request.getContextPath() + "/admin/manage-menu");
                return;
            }

            request.setAttribute("item", item);
            request.setAttribute("categories", categories);
            request.getRequestDispatcher("/admin/edit-menu-item.jsp").forward(request, response);
        } catch (SQLException ex) {
            response.sendRedirect(request.getContextPath() + "/admin/manage-menu");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        if (!SessionUtil.hasRole(request, "ADMIN")) {
            response.sendRedirect(request.getContextPath() + "/admin/login");
            return;
        }

        String itemId = ValidationUtil.sanitize(request.getParameter("itemId"));
        String categoryId = ValidationUtil.sanitize(request.getParameter("categoryId"));
        String itemName = ValidationUtil.sanitize(request.getParameter("itemName"));
        String description = ValidationUtil.sanitize(request.getParameter("description"));
        String price = ValidationUtil.sanitize(request.getParameter("price"));
        String prepTime = ValidationUtil.sanitize(request.getParameter("prepTimeMinutes"));
        String existingImagePath = ValidationUtil.sanitize(request.getParameter("existingImagePath"));

        if (!ValidationUtil.isValidIntegerRange(itemId, 1, Integer.MAX_VALUE)
                || !ValidationUtil.isValidIntegerRange(categoryId, 1, Integer.MAX_VALUE)
                || !ValidationUtil.isRequiredValid(itemName)
                || !ValidationUtil.isPositivePrice(price)
                || !ValidationUtil.isValidIntegerRange(prepTime, 1, 240)) {
            response.sendRedirect(request.getContextPath() + "/admin/edit-menu-item?id=" + itemId);
            return;
        }

        boolean isAvailable = "on".equalsIgnoreCase(request.getParameter("isAvailable"));
        boolean isFeatured = "on".equalsIgnoreCase(request.getParameter("isFeatured"));

        try {
            Part imagePart = request.getPart("image");
            String uploadDir = getServletContext().getRealPath("") + File.separator + "uploads" + File.separator + "menu";
            String imagePath = FileUploadUtil.saveMenuImage(imagePart, uploadDir);
            if (!ValidationUtil.isRequiredValid(imagePath)) {
                imagePath = existingImagePath;
            }

            MenuItem item = new MenuItem();
            item.setItemId(Long.parseLong(itemId));
            item.setCategoryId(Long.parseLong(categoryId));
            item.setItemName(itemName);
            item.setDescription(description);
            item.setPrice(new BigDecimal(price));
            item.setImagePath(imagePath);
            item.setAvailable(isAvailable);
            item.setFeatured(isFeatured);
            item.setPrepTimeMinutes(Integer.parseInt(prepTime));

            menuItemDAO.updateItem(item);
            response.sendRedirect(request.getContextPath() + "/admin/manage-menu");
        } catch (SQLException ex) {
            response.sendRedirect(request.getContextPath() + "/admin/edit-menu-item?id=" + itemId);
        }
    }
}
