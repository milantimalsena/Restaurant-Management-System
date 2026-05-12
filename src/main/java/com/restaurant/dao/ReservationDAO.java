package com.restaurant.dao;

import com.restaurant.model.Reservation;
import com.restaurant.model.RestaurantTable;
import com.restaurant.util.DBConnection;

import java.sql.Connection;
import java.sql.DatabaseMetaData;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Time;
import java.time.LocalDate;
import java.time.LocalTime;
import java.util.ArrayList;
import java.util.List;

public class ReservationDAO {
    public ReservationDAO() {
        try {
            ensureSchema();
        } catch (SQLException ex) {
            ex.printStackTrace();
        }
    }

    private void ensureSchema() throws SQLException {
        try (Connection connection = DBConnection.getConnection();
             Statement statement = connection.createStatement()) {
            statement.executeUpdate("""
                    CREATE TABLE IF NOT EXISTS restaurant_tables (
                      table_id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
                      table_number VARCHAR(20) NOT NULL,
                      capacity TINYINT UNSIGNED NOT NULL,
                      is_active TINYINT(1) NOT NULL DEFAULT 1,
                      created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
                      PRIMARY KEY (table_id),
                      UNIQUE KEY uq_restaurant_tables_number (table_number)
                    ) ENGINE=InnoDB
                    """);

            statement.executeUpdate("""
                    CREATE TABLE IF NOT EXISTS reservations (
                      reservation_id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
                      user_id BIGINT UNSIGNED NOT NULL,
                      reservation_date DATE NOT NULL,
                      reservation_time TIME NOT NULL,
                      guests_count TINYINT UNSIGNED NOT NULL,
                      table_number VARCHAR(20) NULL,
                      table_id BIGINT UNSIGNED NULL,
                      status ENUM('PENDING', 'APPROVED', 'REJECTED', 'CANCELLED', 'COMPLETED') NOT NULL DEFAULT 'PENDING',
                      special_request VARCHAR(1000) NULL,
                      created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
                      PRIMARY KEY (reservation_id),
                      KEY idx_reservations_user_id (user_id),
                      KEY idx_reservations_table_id (table_id),
                      KEY idx_reservations_date_time (reservation_date, reservation_time),
                      KEY idx_reservations_status (status)
                    ) ENGINE=InnoDB
                    """);
        }

        try (Connection connection = DBConnection.getConnection()) {
            if (!columnExists(connection, "reservations", "table_id")) {
                try (Statement statement = connection.createStatement()) {
                    statement.executeUpdate("ALTER TABLE reservations ADD COLUMN table_id BIGINT UNSIGNED NULL AFTER table_number");
                    statement.executeUpdate("ALTER TABLE reservations ADD KEY idx_reservations_table_id (table_id)");
                }
            }
        }
    }

    private boolean columnExists(Connection connection, String tableName, String columnName) throws SQLException {
        DatabaseMetaData metaData = connection.getMetaData();
        try (ResultSet resultSet = metaData.getColumns(connection.getCatalog(), null, tableName, columnName)) {
            return resultSet.next();
        }
    }

    public List<RestaurantTable> getAllTables() throws SQLException {
        String sql = "SELECT table_id, table_number, capacity, is_active FROM restaurant_tables ORDER BY table_number";
        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql);
             ResultSet resultSet = statement.executeQuery()) {
            List<RestaurantTable> tables = new ArrayList<>();
            while (resultSet.next()) {
                tables.add(mapTable(resultSet, resultSet.getBoolean("is_active") ? "Available" : "Inactive"));
            }
            return tables;
        }
    }

    public List<RestaurantTable> getAvailableTables(LocalDate date, LocalTime time) throws SQLException {
        String sql = """
                SELECT t.table_id, t.table_number, t.capacity, t.is_active,
                       CASE
                         WHEN EXISTS (
                           SELECT 1 FROM reservations r
                           WHERE (r.table_id = t.table_id OR r.table_number = t.table_number)
                             AND r.reservation_date = ?
                             AND r.reservation_time = ?
                             AND r.status IN ('PENDING', 'APPROVED')
                         ) THEN 'Reserved'
                         ELSE 'Available'
                       END AS table_status
                FROM restaurant_tables t
                WHERE t.is_active = 1
                ORDER BY t.capacity, t.table_number
                """;
        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setDate(1, Date.valueOf(date));
            statement.setTime(2, Time.valueOf(time));
            try (ResultSet resultSet = statement.executeQuery()) {
                List<RestaurantTable> tables = new ArrayList<>();
                while (resultSet.next()) {
                    tables.add(mapTable(resultSet, resultSet.getString("table_status")));
                }
                return tables;
            }
        }
    }

    public RestaurantTable getTableById(long tableId) throws SQLException {
        String sql = "SELECT table_id, table_number, capacity, is_active FROM restaurant_tables WHERE table_id = ?";
        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setLong(1, tableId);
            try (ResultSet resultSet = statement.executeQuery()) {
                if (resultSet.next()) {
                    return mapTable(resultSet, resultSet.getBoolean("is_active") ? "Available" : "Inactive");
                }
            }
        }
        return null;
    }

    public boolean isTableAvailable(long tableId, LocalDate date, LocalTime time) throws SQLException {
        String sql = """
                SELECT COUNT(*) FROM reservations
                WHERE (table_id = ? OR table_number = (SELECT table_number FROM restaurant_tables WHERE table_id = ?))
                  AND reservation_date = ?
                  AND reservation_time = ?
                  AND status IN ('PENDING', 'APPROVED')
                """;
        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setLong(1, tableId);
            statement.setLong(2, tableId);
            statement.setDate(3, Date.valueOf(date));
            statement.setTime(4, Time.valueOf(time));
            try (ResultSet resultSet = statement.executeQuery()) {
                return resultSet.next() && resultSet.getInt(1) == 0;
            }
        }
    }

    public boolean addTable(RestaurantTable table) throws SQLException {
        String sql = "INSERT INTO restaurant_tables (table_number, capacity, is_active) VALUES (?, ?, ?)";
        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setString(1, table.getTableNumber());
            statement.setInt(2, table.getCapacity());
            statement.setBoolean(3, table.isActive());
            return statement.executeUpdate() > 0;
        }
    }

    public boolean setTableActive(long tableId, boolean active) throws SQLException {
        String sql = "UPDATE restaurant_tables SET is_active = ? WHERE table_id = ?";
        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setBoolean(1, active);
            statement.setLong(2, tableId);
            return statement.executeUpdate() > 0;
        }
    }

    public boolean createReservation(Reservation reservation) throws SQLException {
        String sql = """
                INSERT INTO reservations (
                  user_id, reservation_date, reservation_time, guests_count,
                  table_number, table_id, status, special_request
                ) VALUES (?, ?, ?, ?, ?, ?, 'PENDING', ?)
                """;
        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setLong(1, reservation.getUserId());
            statement.setDate(2, Date.valueOf(reservation.getReservationDate()));
            statement.setTime(3, Time.valueOf(reservation.getReservationTime()));
            statement.setInt(4, reservation.getGuests());
            statement.setString(5, reservation.getTableNumber());
            statement.setLong(6, reservation.getTableId());
            statement.setString(7, reservation.getSpecialRequest());
            return statement.executeUpdate() > 0;
        }
    }

    public List<Reservation> getReservationsByUser(long userId) throws SQLException {
        String sql = """
                SELECT r.reservation_id, r.user_id, r.table_id, COALESCE(t.table_number, r.table_number) AS table_number,
                       r.reservation_date, r.reservation_time, r.guests_count, r.status, r.special_request,
                       u.full_name, u.phone, u.email
                FROM reservations r
                JOIN users u ON u.user_id = r.user_id
                LEFT JOIN restaurant_tables t ON t.table_id = r.table_id
                WHERE r.user_id = ?
                ORDER BY r.reservation_date DESC, r.reservation_time DESC
                """;
        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setLong(1, userId);
            try (ResultSet resultSet = statement.executeQuery()) {
                return mapReservations(resultSet);
            }
        }
    }

    public List<Reservation> getAllReservations() throws SQLException {
        String sql = """
                SELECT r.reservation_id, r.user_id, r.table_id, COALESCE(t.table_number, r.table_number) AS table_number,
                       r.reservation_date, r.reservation_time, r.guests_count, r.status, r.special_request,
                       u.full_name, u.phone, u.email
                FROM reservations r
                JOIN users u ON u.user_id = r.user_id
                LEFT JOIN restaurant_tables t ON t.table_id = r.table_id
                ORDER BY r.reservation_date DESC, r.reservation_time DESC
                """;
        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql);
             ResultSet resultSet = statement.executeQuery()) {
            return mapReservations(resultSet);
        }
    }

    public int countReservations() throws SQLException {
        return count("SELECT COUNT(*) FROM reservations");
    }

    public int countPendingReservations() throws SQLException {
        return count("SELECT COUNT(*) FROM reservations WHERE status = 'PENDING'");
    }

    public int countApprovedToday() throws SQLException {
        return count("SELECT COUNT(*) FROM reservations WHERE status = 'APPROVED' AND reservation_date = CURDATE()");
    }

    public boolean updateReservationStatus(long reservationId, String status) throws SQLException {
        String sql = "UPDATE reservations SET status = ? WHERE reservation_id = ?";
        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setString(1, status);
            statement.setLong(2, reservationId);
            return statement.executeUpdate() > 0;
        }
    }

    private int count(String sql) throws SQLException {
        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql);
             ResultSet resultSet = statement.executeQuery()) {
            return resultSet.next() ? resultSet.getInt(1) : 0;
        }
    }

    private RestaurantTable mapTable(ResultSet resultSet, String status) throws SQLException {
        RestaurantTable table = new RestaurantTable();
        table.setTableId(resultSet.getLong("table_id"));
        table.setTableNumber(resultSet.getString("table_number"));
        table.setCapacity(resultSet.getInt("capacity"));
        table.setActive(resultSet.getBoolean("is_active"));
        table.setStatus(status);
        return table;
    }

    private List<Reservation> mapReservations(ResultSet resultSet) throws SQLException {
        List<Reservation> reservations = new ArrayList<>();
        while (resultSet.next()) {
            Reservation reservation = new Reservation();
            reservation.setReservationId(resultSet.getLong("reservation_id"));
            reservation.setUserId(resultSet.getLong("user_id"));
            long tableId = resultSet.getLong("table_id");
            if (!resultSet.wasNull()) {
                reservation.setTableId(tableId);
            }
            reservation.setTableNumber(resultSet.getString("table_number"));
            reservation.setReservationDate(resultSet.getDate("reservation_date").toLocalDate());
            reservation.setReservationTime(resultSet.getTime("reservation_time").toLocalTime());
            reservation.setGuests(resultSet.getInt("guests_count"));
            reservation.setStatus(toDisplayStatus(resultSet.getString("status")));
            reservation.setSpecialRequest(resultSet.getString("special_request"));
            reservation.setCustomerName(resultSet.getString("full_name"));
            reservation.setPhone(resultSet.getString("phone"));
            reservation.setEmail(resultSet.getString("email"));
            reservations.add(reservation);
        }
        return reservations;
    }

    private String toDisplayStatus(String status) {
        if (status == null || status.isBlank()) {
            return "Pending";
        }
        String lower = status.toLowerCase();
        return Character.toUpperCase(lower.charAt(0)) + lower.substring(1);
    }
}
