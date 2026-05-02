package com.restaurant.dao;

import com.restaurant.model.Admin;
import com.restaurant.util.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class AdminDAO {
    private static final String FIND_BY_EMAIL_SQL = "SELECT admin_id, full_name, email, password, status, created_at FROM admins WHERE email = ? LIMIT 1";

    public Admin findByEmail(String email) throws SQLException {
        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(FIND_BY_EMAIL_SQL)) {
            statement.setString(1, email);

            try (ResultSet resultSet = statement.executeQuery()) {
                if (!resultSet.next()) {
                    return null;
                }

                Admin admin = new Admin();
                admin.setAdminId(resultSet.getLong("admin_id"));
                admin.setFullName(resultSet.getString("full_name"));
                admin.setEmail(resultSet.getString("email"));
                admin.setPasswordHash(resultSet.getString("password"));
                admin.setStatus(resultSet.getString("status"));

                if (resultSet.getTimestamp("created_at") != null) {
                    admin.setCreatedAt(resultSet.getTimestamp("created_at").toLocalDateTime());
                }

                return admin;
            }
        }
    }
}
