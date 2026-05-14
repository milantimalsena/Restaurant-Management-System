package com.restaurant.dao;

import com.restaurant.model.User;
import com.restaurant.util.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class UserDAO {
    private static final String INSERT_USER_SQL = "INSERT INTO users (full_name, email, phone, password, address, status) VALUES (?, ?, ?, ?, ?, ?)";
    private static final String FIND_BY_EMAIL_SQL = "SELECT user_id, full_name, email, phone, password, address, status, created_at, updated_at FROM users WHERE email = ? LIMIT 1";
    private static final String CHECK_EMAIL_EXISTS_SQL = "SELECT 1 FROM users WHERE email = ? LIMIT 1";
    private static final String CHECK_PHONE_EXISTS_SQL = "SELECT 1 FROM users WHERE phone = ? LIMIT 1";

    public boolean emailExists(String email) throws SQLException {
        System.out.println("DAO EXECUTING QUERY: emailExists");
        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(CHECK_EMAIL_EXISTS_SQL)) {
            statement.setString(1, email);
            try (ResultSet resultSet = statement.executeQuery()) {
                return resultSet.next();
            }
        }
    }

    public boolean phoneExists(String phone) throws SQLException {
        System.out.println("DAO EXECUTING QUERY: phoneExists");
        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(CHECK_PHONE_EXISTS_SQL)) {
            statement.setString(1, phone);
            try (ResultSet resultSet = statement.executeQuery()) {
                return resultSet.next();
            }
        }
    }

    public boolean createUser(User user) throws SQLException {
        System.out.println("DAO EXECUTING QUERY: createUser");
        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(INSERT_USER_SQL)) {
            statement.setString(1, user.getFullName());
            statement.setString(2, user.getEmail());
            statement.setString(3, user.getPhone());
            statement.setString(4, user.getPasswordHash());
            statement.setString(5, user.getAddress());
            statement.setString(6, user.getStatus() == null ? "ACTIVE" : user.getStatus());
            return statement.executeUpdate() > 0;
        }
    }

    public int countUsers() throws SQLException {
        System.out.println("DAO EXECUTING QUERY: countUsers");
        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement("SELECT COUNT(*) FROM users");
             ResultSet resultSet = statement.executeQuery()) {
            return resultSet.next() ? resultSet.getInt(1) : 0;
        }
    }

    public User findByEmail(String email) throws SQLException {
        System.out.println("DAO EXECUTING QUERY: findByEmail");
        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(FIND_BY_EMAIL_SQL)) {
            statement.setString(1, email);
            try (ResultSet resultSet = statement.executeQuery()) {
                if (!resultSet.next()) {
                    return null;
                }

                User user = new User();
                user.setUserId(resultSet.getLong("user_id"));
                user.setFullName(resultSet.getString("full_name"));
                user.setEmail(resultSet.getString("email"));
                user.setPhone(resultSet.getString("phone"));
                user.setPasswordHash(resultSet.getString("password"));
                user.setAddress(resultSet.getString("address"));
                user.setStatus(resultSet.getString("status"));

                if (resultSet.getTimestamp("created_at") != null) {
                    user.setCreatedAt(resultSet.getTimestamp("created_at").toLocalDateTime());
                }
                if (resultSet.getTimestamp("updated_at") != null) {
                    user.setUpdatedAt(resultSet.getTimestamp("updated_at").toLocalDateTime());
                }

                return user;
            }
        }
    }
}
