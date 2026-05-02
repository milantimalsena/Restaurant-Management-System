package com.restaurant.dao;

import com.restaurant.model.Cart;
import com.restaurant.model.Order;
import com.restaurant.model.OrderItem;
import com.restaurant.model.Payment;
import com.restaurant.util.DBConnection;

import java.math.BigDecimal;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class OrderDAO {
    private static final String GET_CART_ITEMS_SQL = "SELECT c.item_id, mi.item_name, c.quantity, c.unit_price, (c.quantity * c.unit_price) AS line_total FROM cart c JOIN menu_items mi ON mi.item_id = c.item_id WHERE c.user_id = ? ORDER BY c.created_at";
    private static final String GET_CART_SUBTOTAL_SQL = "SELECT COALESCE(SUM(quantity * unit_price), 0) AS subtotal FROM cart WHERE user_id = ?";
    private static final String CLEAR_CART_SQL = "DELETE FROM cart WHERE user_id = ?";

    private static final String INSERT_ORDER_SQL = "INSERT INTO orders (order_number, user_id, order_type, order_status, payment_status, subtotal, tax, delivery_fee, discount, grand_total, delivery_address, phone_snapshot, notes) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
    private static final String INSERT_ORDER_ITEM_SQL = "INSERT INTO order_items (order_id, item_id, quantity, unit_price, line_total) VALUES (?, ?, ?, ?, ?)";
    private static final String INSERT_PAYMENT_SQL = "INSERT INTO payments (order_id, payment_method, transaction_ref, amount, payment_status, paid_at) VALUES (?, ?, ?, ?, ?, ?)";
    private static final String UPDATE_ORDER_STATUS_SQL = "UPDATE orders SET order_status = ? WHERE order_id = ?";
    private static final String UPDATE_ORDER_AND_PAYMENT_STATUS_SQL = "UPDATE orders o LEFT JOIN payments p ON p.order_id = o.order_id SET o.order_status = ?, o.payment_status = ?, p.payment_status = ? WHERE o.order_id = ?";

    private static final String GET_ORDER_BY_ID_SQL = "SELECT o.order_id, o.order_number, o.user_id, o.order_type, o.order_status, o.payment_status, o.subtotal, o.tax, o.delivery_fee, o.discount, o.grand_total, o.delivery_address, o.phone_snapshot, o.notes, o.ordered_at, o.updated_at, p.payment_method FROM orders o LEFT JOIN payments p ON p.order_id = o.order_id WHERE o.order_id = ?";
    private static final String GET_ORDER_ITEMS_SQL = "SELECT oi.order_item_id, oi.order_id, oi.item_id, mi.item_name, oi.quantity, oi.unit_price, oi.line_total FROM order_items oi JOIN menu_items mi ON mi.item_id = oi.item_id WHERE oi.order_id = ?";
    private static final String GET_ORDERS_BY_USER_SQL = "SELECT o.order_id, o.order_number, o.user_id, o.order_type, o.order_status, o.payment_status, o.subtotal, o.tax, o.delivery_fee, o.discount, o.grand_total, o.delivery_address, o.phone_snapshot, o.notes, o.ordered_at, o.updated_at, p.payment_method FROM orders o LEFT JOIN payments p ON p.order_id = o.order_id WHERE o.user_id = ? ORDER BY o.ordered_at DESC";

    public List<Cart> getCartItems(long userId) throws SQLException {
        System.out.println("DAO EXECUTING QUERY: getCartItems");
        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(GET_CART_ITEMS_SQL)) {
            statement.setLong(1, userId);
            try (ResultSet resultSet = statement.executeQuery()) {
                List<Cart> items = new ArrayList<>();
                while (resultSet.next()) {
                    Cart cart = new Cart();
                    cart.setItemId(resultSet.getLong("item_id"));
                    cart.setItemName(resultSet.getString("item_name"));
                    cart.setQuantity(resultSet.getInt("quantity"));
                    cart.setUnitPrice(resultSet.getBigDecimal("unit_price"));
                    cart.setLineTotal(resultSet.getBigDecimal("line_total"));
                    items.add(cart);
                }
                return items;
            }
        }
    }

    public BigDecimal getCartSubtotal(long userId) throws SQLException {
        System.out.println("DAO EXECUTING QUERY: getCartSubtotal");
        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(GET_CART_SUBTOTAL_SQL)) {
            statement.setLong(1, userId);
            try (ResultSet resultSet = statement.executeQuery()) {
                if (resultSet.next()) {
                    return resultSet.getBigDecimal("subtotal");
                }
                return BigDecimal.ZERO;
            }
        }
    }

    public boolean clearCart(long userId) throws SQLException {
        System.out.println("DAO EXECUTING QUERY: clearCart");
        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(CLEAR_CART_SQL)) {
            statement.setLong(1, userId);
            statement.executeUpdate();
            return true;
        }
    }

    public long createOrder(Order order) throws SQLException {
        System.out.println("DAO EXECUTING QUERY: createOrder");
        try (Connection connection = DBConnection.getConnection()) {
            connection.setAutoCommit(false);
            try {
                long orderId;
                try (PreparedStatement statement = connection.prepareStatement(INSERT_ORDER_SQL, Statement.RETURN_GENERATED_KEYS)) {
                    statement.setString(1, order.getOrderNumber());
                    statement.setLong(2, order.getUserId());
                    statement.setString(3, order.getOrderType());
                    statement.setString(4, order.getOrderStatus());
                    statement.setString(5, order.getPaymentStatus());
                    statement.setBigDecimal(6, order.getSubtotal());
                    statement.setBigDecimal(7, order.getTax());
                    statement.setBigDecimal(8, order.getDeliveryFee());
                    statement.setBigDecimal(9, order.getDiscount());
                    statement.setBigDecimal(10, order.getGrandTotal());
                    statement.setString(11, order.getDeliveryAddress());
                    statement.setString(12, order.getPhoneSnapshot());
                    statement.setString(13, order.getNotes());
                    statement.executeUpdate();

                    try (ResultSet keys = statement.getGeneratedKeys()) {
                        if (!keys.next()) {
                            throw new SQLException("Failed to create order.");
                        }
                        orderId = keys.getLong(1);
                    }
                }

                addOrderItemsInternal(connection, orderId, order.getItems());

                Payment payment = new Payment();
                payment.setOrderId(orderId);
                payment.setPaymentMethod(order.getPaymentMethod());
                payment.setAmount(order.getGrandTotal());
                payment.setPaymentStatus("CASH".equalsIgnoreCase(order.getPaymentMethod()) ? "UNPAID" : "PAID");
                if (!"CASH".equalsIgnoreCase(order.getPaymentMethod())) {
                    payment.setTransactionRef("TXN-" + order.getOrderNumber());
                    payment.setPaidAt(java.time.LocalDateTime.now());
                }
                createPaymentInternal(connection, payment);

                clearCart(connection, order.getUserId());

                connection.commit();
                return orderId;
            } catch (SQLException ex) {
                ex.printStackTrace();
                connection.rollback();
                throw ex;
            } finally {
                connection.setAutoCommit(true);
            }
        }
    }

    public Order getOrderById(long orderId) throws SQLException {
        System.out.println("DAO EXECUTING QUERY: getOrderById");
        try (Connection connection = DBConnection.getConnection();
             PreparedStatement orderStmt = connection.prepareStatement(GET_ORDER_BY_ID_SQL);
             PreparedStatement itemsStmt = connection.prepareStatement(GET_ORDER_ITEMS_SQL)) {

            orderStmt.setLong(1, orderId);
            Order order = null;
            try (ResultSet resultSet = orderStmt.executeQuery()) {
                if (resultSet.next()) {
                    order = mapOrder(resultSet);
                }
            }

            if (order == null) {
                return null;
            }

            itemsStmt.setLong(1, orderId);
            try (ResultSet resultSet = itemsStmt.executeQuery()) {
                List<OrderItem> items = new ArrayList<>();
                while (resultSet.next()) {
                    items.add(mapOrderItem(resultSet));
                }
                order.setItems(items);
            }

            return order;
        }
    }

    public List<Order> getOrdersByUser(long userId) throws SQLException {
        System.out.println("DAO EXECUTING QUERY: getOrdersByUser");
        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(GET_ORDERS_BY_USER_SQL)) {
            statement.setLong(1, userId);
            try (ResultSet resultSet = statement.executeQuery()) {
                List<Order> orders = new ArrayList<>();
                while (resultSet.next()) {
                    orders.add(mapOrder(resultSet));
                }
                return orders;
            }
        }
    }

    public boolean addOrderItems(long orderId, List<OrderItem> items) throws SQLException {
        System.out.println("DAO EXECUTING QUERY: addOrderItems");
        try (Connection connection = DBConnection.getConnection()) {
            addOrderItemsInternal(connection, orderId, items);
            return true;
        }
    }

    public boolean createPayment(Payment payment) throws SQLException {
        System.out.println("DAO EXECUTING QUERY: createPayment");
        try (Connection connection = DBConnection.getConnection()) {
            createPaymentInternal(connection, payment);
            return true;
        }
    }

    public boolean updateStatus(long orderId, String orderStatus) throws SQLException {
        System.out.println("DAO EXECUTING QUERY: updateStatus(order)");
        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(UPDATE_ORDER_STATUS_SQL)) {
            statement.setString(1, orderStatus);
            statement.setLong(2, orderId);
            return statement.executeUpdate() > 0;
        }
    }

    public boolean updateStatus(long orderId, String orderStatus, String paymentStatus) throws SQLException {
        System.out.println("DAO EXECUTING QUERY: updateStatus(order,payment)");
        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(UPDATE_ORDER_AND_PAYMENT_STATUS_SQL)) {
            statement.setString(1, orderStatus);
            statement.setString(2, paymentStatus);
            statement.setString(3, paymentStatus);
            statement.setLong(4, orderId);
            return statement.executeUpdate() > 0;
        }
    }

    private void addOrderItemsInternal(Connection connection, long orderId, List<OrderItem> items) throws SQLException {
        try (PreparedStatement statement = connection.prepareStatement(INSERT_ORDER_ITEM_SQL)) {
            for (OrderItem item : items) {
                statement.setLong(1, orderId);
                statement.setLong(2, item.getItemId());
                statement.setInt(3, item.getQuantity());
                statement.setBigDecimal(4, item.getUnitPrice());
                statement.setBigDecimal(5, item.getLineTotal());
                statement.addBatch();
            }
            statement.executeBatch();
        }
    }

    private void createPaymentInternal(Connection connection, Payment payment) throws SQLException {
        try (PreparedStatement statement = connection.prepareStatement(INSERT_PAYMENT_SQL)) {
            statement.setLong(1, payment.getOrderId());
            statement.setString(2, payment.getPaymentMethod());
            statement.setString(3, payment.getTransactionRef());
            statement.setBigDecimal(4, payment.getAmount());
            statement.setString(5, payment.getPaymentStatus());
            if (payment.getPaidAt() != null) {
                statement.setTimestamp(6, Timestamp.valueOf(payment.getPaidAt()));
            } else {
                statement.setNull(6, Types.TIMESTAMP);
            }
            statement.executeUpdate();
        }
    }

    private void clearCart(Connection connection, long userId) throws SQLException {
        try (PreparedStatement statement = connection.prepareStatement(CLEAR_CART_SQL)) {
            statement.setLong(1, userId);
            statement.executeUpdate();
        }
    }

    private Order mapOrder(ResultSet resultSet) throws SQLException {
        Order order = new Order();
        order.setOrderId(resultSet.getLong("order_id"));
        order.setOrderNumber(resultSet.getString("order_number"));
        order.setUserId(resultSet.getLong("user_id"));
        order.setOrderType(resultSet.getString("order_type"));
        order.setOrderStatus(resultSet.getString("order_status"));
        order.setPaymentStatus(resultSet.getString("payment_status"));
        order.setSubtotal(resultSet.getBigDecimal("subtotal"));
        order.setTax(resultSet.getBigDecimal("tax"));
        order.setDeliveryFee(resultSet.getBigDecimal("delivery_fee"));
        order.setDiscount(resultSet.getBigDecimal("discount"));
        order.setGrandTotal(resultSet.getBigDecimal("grand_total"));
        order.setDeliveryAddress(resultSet.getString("delivery_address"));
        order.setPhoneSnapshot(resultSet.getString("phone_snapshot"));
        order.setNotes(resultSet.getString("notes"));
        order.setPaymentMethod(resultSet.getString("payment_method"));
        if (resultSet.getTimestamp("ordered_at") != null) {
            order.setOrderedAt(resultSet.getTimestamp("ordered_at").toLocalDateTime());
        }
        if (resultSet.getTimestamp("updated_at") != null) {
            order.setUpdatedAt(resultSet.getTimestamp("updated_at").toLocalDateTime());
        }
        return order;
    }

    private OrderItem mapOrderItem(ResultSet resultSet) throws SQLException {
        OrderItem item = new OrderItem();
        item.setOrderItemId(resultSet.getLong("order_item_id"));
        item.setOrderId(resultSet.getLong("order_id"));
        item.setItemId(resultSet.getLong("item_id"));
        item.setItemName(resultSet.getString("item_name"));
        item.setQuantity(resultSet.getInt("quantity"));
        item.setUnitPrice(resultSet.getBigDecimal("unit_price"));
        item.setLineTotal(resultSet.getBigDecimal("line_total"));
        return item;
    }
}
