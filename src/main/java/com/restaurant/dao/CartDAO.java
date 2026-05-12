package com.restaurant.dao;

import com.restaurant.model.Cart;
import com.restaurant.util.DBConnection;
import com.restaurant.util.ValidationUtil;

import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class CartDAO {
    private static final String GET_MENU_ITEM_SQL = "SELECT item_id, item_name, price, is_available FROM menu_items WHERE item_id = ?";
    private static final String ITEM_EXISTS_SQL = "SELECT cart_id, quantity FROM cart WHERE user_id = ? AND item_id = ? LIMIT 1";
    private static final String INSERT_CART_SQL = "INSERT INTO cart (user_id, item_id, quantity, unit_price) VALUES (?, ?, ?, ?)";
    private static final String UPDATE_QUANTITY_SQL = "UPDATE cart SET quantity = ? WHERE cart_id = ?";
    private static final String UPDATE_QUANTITY_BY_USER_SQL = "UPDATE cart SET quantity = ? WHERE cart_id = ? AND user_id = ?";
    private static final String INCREASE_QTY_SQL = "UPDATE cart SET quantity = LEAST(quantity + 1, 20) WHERE cart_id = ?";
    private static final String INCREASE_QTY_BY_USER_SQL = "UPDATE cart SET quantity = LEAST(quantity + 1, 20) WHERE cart_id = ? AND user_id = ?";
    private static final String DECREASE_QTY_SQL = "UPDATE cart SET quantity = GREATEST(quantity - 1, 1) WHERE cart_id = ?";
    private static final String DECREASE_QTY_BY_USER_SQL = "UPDATE cart SET quantity = GREATEST(quantity - 1, 1) WHERE cart_id = ? AND user_id = ?";
    private static final String REMOVE_ITEM_SQL = "DELETE FROM cart WHERE cart_id = ?";
    private static final String REMOVE_ITEM_BY_USER_SQL = "DELETE FROM cart WHERE cart_id = ? AND user_id = ?";
    private static final String CLEAR_CART_SQL = "DELETE FROM cart WHERE user_id = ?";
    private static final String GET_CART_BY_USER_SQL = "SELECT c.cart_id, c.user_id, c.item_id, mi.item_name, mi.image_path, ct.category_name, c.quantity, c.unit_price, (c.quantity * c.unit_price) AS line_total, c.created_at FROM cart c JOIN menu_items mi ON mi.item_id = c.item_id JOIN categories ct ON ct.category_id = mi.category_id WHERE c.user_id = ? ORDER BY c.created_at DESC";
    private static final String GET_CART_COUNT_SQL = "SELECT COALESCE(SUM(quantity), 0) AS total_count FROM cart WHERE user_id = ?";
    private static final String GET_SUBTOTAL_SQL = "SELECT COALESCE(SUM(quantity * unit_price), 0) AS subtotal FROM cart WHERE user_id = ?";

    public boolean addToCart(long userId, long itemId, int qty) throws SQLException {
        try (Connection connection = DBConnection.getConnection()) {
            connection.setAutoCommit(false);
            try {
                BigDecimal unitPrice = getMenuItemPrice(connection, itemId);
                if (unitPrice == null) {
                    connection.rollback();
                    return false;
                }

                if (itemExists(userId, itemId)) {
                    try (PreparedStatement statement = connection.prepareStatement("UPDATE cart SET quantity = quantity + 1 WHERE user_id = ? AND item_id = ?")) {
                        statement.setLong(1, userId);
                        statement.setLong(2, itemId);
                        statement.executeUpdate();
                    }
                } else {
                    try (PreparedStatement statement = connection.prepareStatement("INSERT INTO cart (user_id, item_id, quantity, unit_price) VALUES (?, ?, 1, ?)")) {
                        statement.setLong(1, userId);
                        statement.setLong(2, itemId);
                        statement.setBigDecimal(3, unitPrice);
                        statement.executeUpdate();
                    }
                }

                connection.commit();
                return true;
            } catch (SQLException ex) {
                connection.rollback();
                throw ex;
            } finally {
                connection.setAutoCommit(true);
            }
        }
    }

    public boolean addToCart(long userId, long itemId) throws SQLException {
        return addToCart(userId, itemId, 1);
    }

    private BigDecimal getMenuItemPrice(Connection connection, long itemId) throws SQLException {
        try (PreparedStatement statement = connection.prepareStatement("SELECT price FROM menu_items WHERE item_id = ?")) {
            statement.setLong(1, itemId);
            try (ResultSet resultSet = statement.executeQuery()) {
                return resultSet.next() ? resultSet.getBigDecimal("price") : null;
            }
        }
    }

    public boolean updateQuantity(long cartId, int qty) throws SQLException {
        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(UPDATE_QUANTITY_SQL)) {
            statement.setInt(1, ValidationUtil.clampQuantity(qty));
            statement.setLong(2, cartId);
            return statement.executeUpdate() > 0;
        }
    }

    public boolean updateQuantityForUser(long userId, long cartId, int qty) throws SQLException {
        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(UPDATE_QUANTITY_BY_USER_SQL)) {
            statement.setInt(1, ValidationUtil.clampQuantity(qty));
            statement.setLong(2, cartId);
            statement.setLong(3, userId);
            return statement.executeUpdate() > 0;
        }
    }

    public boolean increaseQty(long cartId) throws SQLException {
        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(INCREASE_QTY_SQL)) {
            statement.setLong(1, cartId);
            return statement.executeUpdate() > 0;
        }
    }

    public boolean increaseQtyForUser(long userId, long cartId) throws SQLException {
        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(INCREASE_QTY_BY_USER_SQL)) {
            statement.setLong(1, cartId);
            statement.setLong(2, userId);
            return statement.executeUpdate() > 0;
        }
    }

    public boolean decreaseQty(long cartId) throws SQLException {
        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(DECREASE_QTY_SQL)) {
            statement.setLong(1, cartId);
            return statement.executeUpdate() > 0;
        }
    }

    public boolean decreaseQtyForUser(long userId, long cartId) throws SQLException {
        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(DECREASE_QTY_BY_USER_SQL)) {
            statement.setLong(1, cartId);
            statement.setLong(2, userId);
            return statement.executeUpdate() > 0;
        }
    }

    public boolean removeItem(long cartId) throws SQLException {
        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(REMOVE_ITEM_SQL)) {
            statement.setLong(1, cartId);
            return statement.executeUpdate() > 0;
        }
    }

    public boolean removeItemForUser(long userId, long cartId) throws SQLException {
        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(REMOVE_ITEM_BY_USER_SQL)) {
            statement.setLong(1, cartId);
            statement.setLong(2, userId);
            return statement.executeUpdate() > 0;
        }
    }

    public boolean clearCart(long userId) throws SQLException {
        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(CLEAR_CART_SQL)) {
            statement.setLong(1, userId);
            statement.executeUpdate();
            return true;
        }
    }

    public List<Cart> getCartByUser(long userId) throws SQLException {
        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(GET_CART_BY_USER_SQL)) {
            statement.setLong(1, userId);
            try (ResultSet resultSet = statement.executeQuery()) {
                List<Cart> carts = new ArrayList<>();
                while (resultSet.next()) {
                    Cart cart = new Cart();
                    cart.setCartId(resultSet.getLong("cart_id"));
                    cart.setUserId(resultSet.getLong("user_id"));
                    cart.setItemId(resultSet.getLong("item_id"));
                    cart.setItemName(resultSet.getString("item_name"));
                    cart.setImagePath(resultSet.getString("image_path"));
                    cart.setCategoryName(resultSet.getString("category_name"));
                    cart.setQuantity(resultSet.getInt("quantity"));
                    cart.setUnitPrice(resultSet.getBigDecimal("unit_price"));
                    cart.setLineTotal(resultSet.getBigDecimal("line_total"));
                    if (resultSet.getTimestamp("created_at") != null) {
                        cart.setCreatedAt(resultSet.getTimestamp("created_at").toLocalDateTime());
                    }
                    carts.add(cart);
                }
                return carts;
            }
        }
    }

    public int getCartCount(long userId) throws SQLException {
        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(GET_CART_COUNT_SQL)) {
            statement.setLong(1, userId);
            try (ResultSet resultSet = statement.executeQuery()) {
                if (resultSet.next()) {
                    return resultSet.getInt("total_count");
                }
            }
            return 0;
        }
    }

    public BigDecimal getSubtotal(long userId) throws SQLException {
        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(GET_SUBTOTAL_SQL)) {
            statement.setLong(1, userId);
            try (ResultSet resultSet = statement.executeQuery()) {
                if (resultSet.next()) {
                    return resultSet.getBigDecimal("subtotal");
                }
            }
        }
        return BigDecimal.ZERO;
    }

    public boolean itemExists(long userId, long itemId) throws SQLException {
        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(ITEM_EXISTS_SQL)) {
            statement.setLong(1, userId);
            statement.setLong(2, itemId);
            try (ResultSet resultSet = statement.executeQuery()) {
                return resultSet.next();
            }
        }
    }

    private CartExistence getExistingCartItem(Connection connection, long userId, long itemId) throws SQLException {
        try (PreparedStatement statement = connection.prepareStatement(ITEM_EXISTS_SQL)) {
            statement.setLong(1, userId);
            statement.setLong(2, itemId);
            try (ResultSet resultSet = statement.executeQuery()) {
                if (!resultSet.next()) {
                    return null;
                }
                return new CartExistence(resultSet.getLong("cart_id"), resultSet.getInt("quantity"));
            }
        }
    }

    private MenuItemSnapshot getMenuItemSnapshot(Connection connection, long itemId) throws SQLException {
        try (PreparedStatement statement = connection.prepareStatement(GET_MENU_ITEM_SQL)) {
            statement.setLong(1, itemId);
            try (ResultSet resultSet = statement.executeQuery()) {
                if (!resultSet.next()) {
                    return null;
                }
                return new MenuItemSnapshot(
                        resultSet.getLong("item_id"),
                        resultSet.getBigDecimal("price"),
                        resultSet.getBoolean("is_available")
                );
            }
        }
    }

    private record CartExistence(long cartId, int quantity) {
    }

    private record MenuItemSnapshot(long itemId, BigDecimal price, boolean available) {
    }
}
