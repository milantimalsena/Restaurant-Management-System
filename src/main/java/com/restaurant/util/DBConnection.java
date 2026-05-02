package com.restaurant.util;

import java.io.IOException;
import java.io.InputStream;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.util.Properties;

public final class DBConnection {
    private static final Properties PROPERTIES = new Properties();

    static {
        try (InputStream input = DBConnection.class.getClassLoader().getResourceAsStream("db.properties")) {
            if (input == null) {
                throw new IllegalStateException("db.properties file not found in classpath");
            }

            PROPERTIES.load(input);
            String driverClass = getConfig("db.driver", "com.mysql.cj.jdbc.Driver");
            Class.forName(driverClass);
        } catch (IOException | ClassNotFoundException ex) {
            ex.printStackTrace();
            throw new ExceptionInInitializerError("Failed to initialize database configuration: " + ex.getMessage());
        }
    }

    private DBConnection() {
    }

    public static Connection getConnection() throws SQLException {
        String url = getConfig("db.url", "jdbc:mysql://localhost:3306/smart_restaurant?useSSL=false&serverTimezone=UTC&allowPublicKeyRetrieval=true");
        String username = getConfig("db.username", "root");
        String password = getConfig("db.password", "");
        Connection connection = DriverManager.getConnection(url, username, password);
        System.out.println("DB CONNECTED");
        return connection;
    }

    private static String getConfig(String key, String defaultValue) {
        String property = PROPERTIES.getProperty(key);
        if (property != null && !property.isBlank()) {
            return property.trim();
        }

        String systemValue = System.getProperty(key);
        if (systemValue != null && !systemValue.isBlank()) {
            return systemValue.trim();
        }

        String envKey = key.toUpperCase().replace('.', '_');
        String envValue = System.getenv(envKey);
        if (envValue != null && !envValue.isBlank()) {
            return envValue.trim();
        }

        return defaultValue;
    }
}