package com.restaurant.dao;

import com.restaurant.model.MenuItem;
import com.restaurant.util.DBConnection;

import java.sql.Connection;
import java.sql.DatabaseMetaData;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

public class MenuItemDAO {
    private static final String BASE_SELECT = "SELECT mi.item_id, mi.category_id, c.category_name, mi.item_name, mi.description, mi.price, mi.image_path, mi.is_available, mi.is_featured, mi.prep_time_minutes, mi.created_at, mi.updated_at FROM menu_items mi JOIN categories c ON c.category_id = mi.category_id";
    private static final String INSERT_ITEM_SQL = "INSERT INTO menu_items (category_id, item_name, description, price, image_path, is_available, is_featured, prep_time_minutes) VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
    private static final String UPDATE_ITEM_SQL = "UPDATE menu_items SET category_id = ?, item_name = ?, description = ?, price = ?, image_path = ?, is_available = ?, is_featured = ?, prep_time_minutes = ? WHERE item_id = ?";
    private static final String DELETE_ITEM_SQL = "DELETE FROM menu_items WHERE item_id = ?";
    private static final String GET_BY_ID_SQL = BASE_SELECT + " WHERE mi.item_id = ?";
    private static final String GET_ALL_SQL = BASE_SELECT + " ORDER BY mi.created_at DESC";
    private static final String SEARCH_SQL = BASE_SELECT + " WHERE mi.item_name LIKE ? OR mi.description LIKE ? ORDER BY mi.created_at DESC";
    private static final String FILTER_BY_CATEGORY_SQL = BASE_SELECT + " WHERE mi.category_id = ? ORDER BY mi.created_at DESC";
    private static final String UPDATE_AVAILABILITY_SQL = "UPDATE menu_items SET is_available = ? WHERE item_id = ?";
    private static final String GET_FEATURED_SQL = BASE_SELECT + " WHERE mi.is_featured = 1 AND mi.is_available = 1 ORDER BY mi.updated_at DESC LIMIT 8";
    private static final String BULK_AVAILABILITY_SQL = "UPDATE menu_items SET is_available = ? WHERE item_id IN (%s)";

    public MenuItemDAO() {
        try {
            ensureFeaturedColumn();
        } catch (SQLException ex) {
            ex.printStackTrace();
        }
    }

    private void ensureFeaturedColumn() throws SQLException {
        try (Connection connection = DBConnection.getConnection()) {
            DatabaseMetaData metaData = connection.getMetaData();
            try (ResultSet resultSet = metaData.getColumns(connection.getCatalog(), null, "menu_items", "is_featured")) {
                if (resultSet.next()) {
                    return;
                }
            }

            try (Statement statement = connection.createStatement()) {
                statement.executeUpdate("ALTER TABLE menu_items ADD COLUMN is_featured TINYINT(1) NOT NULL DEFAULT 0 AFTER is_available");
            }
        }
    }

    public boolean addItem(MenuItem item) throws SQLException {
        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(INSERT_ITEM_SQL)) {
            bindItemForCreateOrUpdate(statement, item);
            return statement.executeUpdate() > 0;
        }
    }

    public boolean updateItem(MenuItem item) throws SQLException {
        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(UPDATE_ITEM_SQL)) {
            bindItemForCreateOrUpdate(statement, item);
            statement.setLong(9, item.getItemId());
            return statement.executeUpdate() > 0;
        }
    }

    public boolean deleteItem(long itemId) throws SQLException {
        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(DELETE_ITEM_SQL)) {
            statement.setLong(1, itemId);
            return statement.executeUpdate() > 0;
        }
    }

    public List<MenuItem> getAllItems() throws SQLException {
        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(GET_ALL_SQL);
             ResultSet resultSet = statement.executeQuery()) {
            return mapItems(resultSet);
        }
    }

    public MenuItem getById(long itemId) throws SQLException {
        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(GET_BY_ID_SQL)) {
            statement.setLong(1, itemId);
            try (ResultSet resultSet = statement.executeQuery()) {
                List<MenuItem> items = mapItems(resultSet);
                return items.isEmpty() ? null : items.get(0);
            }
        }
    }

    public List<MenuItem> searchItems(String keyword) throws SQLException {
        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(SEARCH_SQL)) {
            String token = "%" + keyword + "%";
            statement.setString(1, token);
            statement.setString(2, token);
            try (ResultSet resultSet = statement.executeQuery()) {
                return mapItems(resultSet);
            }
        }
    }

    public List<MenuItem> filterByCategory(long categoryId) throws SQLException {
        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(FILTER_BY_CATEGORY_SQL)) {
            statement.setLong(1, categoryId);
            try (ResultSet resultSet = statement.executeQuery()) {
                return mapItems(resultSet);
            }
        }
    }

    public boolean updateAvailability(long itemId, boolean isAvailable) throws SQLException {
        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(UPDATE_AVAILABILITY_SQL)) {
            statement.setBoolean(1, isAvailable);
            statement.setLong(2, itemId);
            return statement.executeUpdate() > 0;
        }
    }

    public boolean bulkUpdateAvailability(List<Long> itemIds, boolean isAvailable) throws SQLException {
        if (itemIds == null || itemIds.isEmpty()) {
            return false;
        }

        String placeholders = String.join(",", itemIds.stream().map(id -> "?").toList());
        String sql = BULK_AVAILABILITY_SQL.formatted(placeholders);

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setBoolean(1, isAvailable);
            int index = 2;
            for (Long itemId : itemIds) {
                statement.setLong(index++, itemId);
            }
            return statement.executeUpdate() > 0;
        }
    }

    public List<MenuItem> getFeaturedItems() throws SQLException {
        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(GET_FEATURED_SQL);
             ResultSet resultSet = statement.executeQuery()) {
            return mapItems(resultSet);
        }
    }

    private void bindItemForCreateOrUpdate(PreparedStatement statement, MenuItem item) throws SQLException {
        statement.setLong(1, item.getCategoryId());
        statement.setString(2, item.getItemName());
        statement.setString(3, item.getDescription());
        statement.setBigDecimal(4, item.getPrice());
        statement.setString(5, item.getImagePath());
        statement.setBoolean(6, item.isAvailable());
        statement.setBoolean(7, item.isFeatured());
        statement.setInt(8, item.getPrepTimeMinutes());
    }

    private List<MenuItem> mapItems(ResultSet resultSet) throws SQLException {
        List<MenuItem> items = new ArrayList<>();
        while (resultSet.next()) {
            MenuItem item = new MenuItem();
            item.setItemId(resultSet.getLong("item_id"));
            item.setCategoryId(resultSet.getLong("category_id"));
            item.setCategoryName(resultSet.getString("category_name"));
            item.setItemName(resultSet.getString("item_name"));
            item.setDescription(resultSet.getString("description"));
            item.setPrice(resultSet.getBigDecimal("price"));
            item.setImagePath(resultSet.getString("image_path"));
            item.setAvailable(resultSet.getBoolean("is_available"));
            item.setFeatured(resultSet.getBoolean("is_featured"));
            item.setPrepTimeMinutes(resultSet.getInt("prep_time_minutes"));
            if (resultSet.getTimestamp("created_at") != null) {
                item.setCreatedAt(resultSet.getTimestamp("created_at").toLocalDateTime());
            }
            if (resultSet.getTimestamp("updated_at") != null) {
                item.setUpdatedAt(resultSet.getTimestamp("updated_at").toLocalDateTime());
            }
            items.add(item);
        }
        return items;
    }
}
