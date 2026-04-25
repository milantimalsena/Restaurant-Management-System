package com.restaurant.controller;

import com.restaurant.dao.MenuItemDAO;
import com.restaurant.model.MenuItem;
import com.restaurant.util.ValidationUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

public class SearchMenuServlet extends HttpServlet {
    private final MenuItemDAO menuItemDAO = new MenuItemDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        String keyword = ValidationUtil.sanitize(request.getParameter("q"));
        if (!ValidationUtil.isRequiredValid(keyword)) {
            response.getWriter().write("[]");
            return;
        }

        try {
            List<MenuItem> items = menuItemDAO.searchItems(keyword);
            StringBuilder json = new StringBuilder("[");
            for (int i = 0; i < items.size(); i++) {
                MenuItem item = items.get(i);
                json.append("{\"itemId\":").append(item.getItemId())
                        .append(",\"itemName\":\"").append(escapeJson(item.getItemName())).append("\"")
                        .append(",\"price\":").append(item.getPrice())
                        .append(",\"imagePath\":\"").append(escapeJson(item.getImagePath())).append("\"")
                        .append(",\"available\":").append(item.isAvailable())
                        .append("}");
                if (i < items.size() - 1) {
                    json.append(',');
                }
            }
            json.append(']');
            response.getWriter().write(json.toString());
        } catch (SQLException ex) {
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write("[]");
        }
    }

    private String escapeJson(String value) {
        if (value == null) {
            return "";
        }
        return value.replace("\\", "\\\\")
                .replace("\"", "\\\"")
                .replace("\n", "\\n")
                .replace("\r", "");
    }
}
