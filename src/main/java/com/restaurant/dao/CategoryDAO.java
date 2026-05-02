package com.restaurant.dao;

import com.restaurant.model.Category;
import com.restaurant.util.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class CategoryDAO extends MenuItemDAO {
    private static final String GET_ACTIVE_CATEGORIES_SQL = "SELECT category_id, category_name, description, is_active, created_at FROM categories WHERE is_active = 1 ORDER BY category_name";
    private static final String GET_ALL_CATEGORIES_SQL = "SELECT category_id, category_name, description, is_active, created_at FROM categories ORDER BY category_name";
    private static final String INSERT_CATEGORY_SQL = "INSERT INTO categories (category_name, description, is_active) VALUES (?, ?, ?)";

    public List<Category> getAllActiveCategories() throws SQLException {
        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(GET_ACTIVE_CATEGORIES_SQL);
             ResultSet resultSet = statement.executeQuery()) {
            return mapCategories(resultSet);
        }
    }

    public List<Category> getAllCategories() throws SQLException {
        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(GET_ALL_CATEGORIES_SQL);
             ResultSet resultSet = statement.executeQuery()) {
            return mapCategories(resultSet);
        }
    }

    public boolean addCategory(Category category) throws SQLException {
        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(INSERT_CATEGORY_SQL)) {
            statement.setString(1, category.getCategoryName());
            statement.setString(2, category.getDescription());
            statement.setBoolean(3, category.isActive());
            return statement.executeUpdate() > 0;
        }
    }

    private List<Category> mapCategories(ResultSet resultSet) throws SQLException {
        List<Category> categories = new ArrayList<>();
        while (resultSet.next()) {
            Category category = new Category();
            category.setCategoryId(resultSet.getLong("category_id"));
            category.setCategoryName(resultSet.getString("category_name"));
            category.setDescription(resultSet.getString("description"));
            category.setActive(resultSet.getBoolean("is_active"));
            if (resultSet.getTimestamp("created_at") != null) {
                category.setCreatedAt(resultSet.getTimestamp("created_at").toLocalDateTime());
            }
            categories.add(category);
        }
        return categories;
    }
}
