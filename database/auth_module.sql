-- =========================================================
-- Smart Restaurant - Feature 1 Authentication Module
-- MySQL 8+ / InnoDB / UTF8MB4
-- =========================================================

USE smart_restaurant;

-- -----------------------------
-- Admins Table
-- -----------------------------
CREATE TABLE IF NOT EXISTS admins (
  admin_id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  full_name VARCHAR(120) NOT NULL,
  email VARCHAR(191) NOT NULL,
  password_hash VARCHAR(255) NOT NULL,
  status ENUM('ACTIVE', 'BLOCKED') NOT NULL DEFAULT 'ACTIVE',
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (admin_id),
  UNIQUE KEY uq_admins_email (email)
) ENGINE=InnoDB;

-- -----------------------------
-- Users Table
-- -----------------------------
CREATE TABLE IF NOT EXISTS users (
  user_id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  full_name VARCHAR(120) NOT NULL,
  email VARCHAR(191) NOT NULL,
  phone VARCHAR(20) NOT NULL,
  password_hash VARCHAR(255) NOT NULL,
  address VARCHAR(400) NULL,
  status ENUM('ACTIVE', 'BLOCKED') NOT NULL DEFAULT 'ACTIVE',
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (user_id),
  UNIQUE KEY uq_users_email (email),
  UNIQUE KEY uq_users_phone (phone)
) ENGINE=InnoDB;

-- -----------------------------
-- Sample Accounts
-- Password for both: password
-- -----------------------------
INSERT INTO admins (full_name, email, password_hash, status)
VALUES
('System Admin', 'admin@smartrestaurant.com', '$2a$10$7EqJtq98hPqEX7fNZaFWoO.jR1uR6A7dBDEuDfSUdifYEYTbSsfXO', 'ACTIVE')
ON DUPLICATE KEY UPDATE
  full_name = VALUES(full_name),
  password_hash = VALUES(password_hash),
  status = VALUES(status);

INSERT INTO users (full_name, email, phone, password_hash, address, status)
VALUES
('Demo Customer', 'customer@smartrestaurant.com', '9801000010', '$2a$10$7EqJtq98hPqEX7fNZaFWoO.jR1uR6A7dBDEuDfSUdifYEYTbSsfXO', 'New Baneshwor, Kathmandu', 'ACTIVE')
ON DUPLICATE KEY UPDATE
  full_name = VALUES(full_name),
  phone = VALUES(phone),
  password_hash = VALUES(password_hash),
  address = VALUES(address),
  status = VALUES(status);
