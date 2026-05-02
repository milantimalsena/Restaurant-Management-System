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
import java.util.ArrayList;
import java.util.List;
import java.math.BigDecimal;
import java.sql.SQLException;
import java.util.List;

@MultipartConfig(
        fileSizeThreshold = 1024 * 1024,
        maxFileSize = 5 * 1024 * 1024,
        maxRequestSize = 8 * 1024 * 1024
)
public class AddMenuItemServlet extends HttpServlet {
    private final CategoryDAO categoryDAO = new CategoryDAO();
    private final MenuItemDAO menuItemDAO = new MenuItemDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        if (!SessionUtil.hasRole(request, "ADMIN")) {
            response.sendRedirect(request.getContextPath() + "/admin/login");
            return;
        }

        try {
            List<Category> categories = categoryDAO.getAllActiveCategories();
            request.setAttribute("categories", categories);

            // list existing asset images to allow choosing instead of upload
            String assetsPath = getServletContext().getRealPath("/assets/images/foods");
            List<String> assetImages = new ArrayList<>();
            if (assetsPath != null) {
                File dir = new File(assetsPath);
                if (dir.exists() && dir.isDirectory()) {
                    for (File f : dir.listFiles()) {
                        if (f.isFile()) {
                            assetImages.add("assets/images/foods/" + f.getName());
                        }
                    }
                }
            }
            request.setAttribute("assetImages", assetImages);
            request.getRequestDispatcher("/admin/add-menu-item.jsp").forward(request, response);
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

        String categoryId = ValidationUtil.sanitize(request.getParameter("categoryId"));
        String itemName = ValidationUtil.sanitize(request.getParameter("itemName"));
        String description = ValidationUtil.sanitize(request.getParameter("description"));
        String price = ValidationUtil.sanitize(request.getParameter("price"));
        String prepTime = ValidationUtil.sanitize(request.getParameter("prepTimeMinutes"));

        boolean isAvailable = "on".equalsIgnoreCase(request.getParameter("isAvailable"));
        boolean isFeatured = "on".equalsIgnoreCase(request.getParameter("isFeatured"));

        if (!ValidationUtil.isValidIntegerRange(categoryId, 1, Integer.MAX_VALUE)
                || !ValidationUtil.isRequiredValid(itemName)
                || !ValidationUtil.isPositivePrice(price)
                || !ValidationUtil.isValidIntegerRange(prepTime, 1, 240)) {
            request.setAttribute("errorMessage", "Please enter valid menu item details.");
            doGet(request, response);
            return;
        }

        try {
            // allow choosing existing asset image (assetImage) or uploading a new file (image)
            String assetImage = ValidationUtil.sanitize(request.getParameter("assetImage"));
            String imagePath = null;
            if (ValidationUtil.isRequiredValid(assetImage)) {
                imagePath = assetImage;
            } else {
                Part imagePart = request.getPart("image");
                String uploadDir = getServletContext().getRealPath("") + File.separator + "uploads" + File.separator + "menu";
                imagePath = FileUploadUtil.saveMenuImage(imagePart, uploadDir);
            }

            MenuItem item = new MenuItem();
            item.setCategoryId(Long.parseLong(categoryId));
            item.setItemName(itemName);
            item.setDescription(description);
            item.setPrice(new BigDecimal(price));
            item.setImagePath(imagePath);
            item.setAvailable(isAvailable);
            item.setFeatured(isFeatured);
            item.setPrepTimeMinutes(Integer.parseInt(prepTime));

            menuItemDAO.addItem(item);
            response.sendRedirect(request.getContextPath() + "/admin/manage-menu");
        } catch (SQLException ex) {
            request.setAttribute("errorMessage", "Unable to save item at the moment.");
            doGet(request, response);
        }
    }
}
