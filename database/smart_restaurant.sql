-- =========================================================
-- Smart Restaurant Management System - Step 2
-- Production-Ready MySQL 8+ Database Script
-- =========================================================

-- -----------------------------
-- 1) Database Creation
-- -----------------------------
DROP DATABASE IF EXISTS smart_restaurant;
CREATE DATABASE smart_restaurant
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_0900_ai_ci;
USE smart_restaurant;

SET NAMES utf8mb4;
SET time_zone = '+05:45';

-- -----------------------------
-- 2) Tables
-- -----------------------------

-- Admin accounts
CREATE TABLE admins (
  admin_id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  full_name VARCHAR(120) NOT NULL,
  email VARCHAR(191) NOT NULL,
  password VARCHAR(255) NOT NULL,
  status ENUM('ACTIVE', 'BLOCKED') NOT NULL DEFAULT 'ACTIVE',
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (admin_id),
  UNIQUE KEY uq_admins_email (email)
) ENGINE=InnoDB;

-- Customer users
CREATE TABLE users (
  user_id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  full_name VARCHAR(120) NOT NULL,
  email VARCHAR(191) NOT NULL,
  phone VARCHAR(20) NOT NULL,
  password VARCHAR(255) NOT NULL,
  address VARCHAR(400) NULL,
  status ENUM('ACTIVE', 'BLOCKED') NOT NULL DEFAULT 'ACTIVE',
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (user_id),
  UNIQUE KEY uq_users_email (email),
  UNIQUE KEY uq_users_phone (phone)
) ENGINE=InnoDB;

-- Menu categories
CREATE TABLE categories (
  category_id INT UNSIGNED NOT NULL AUTO_INCREMENT,
  category_name VARCHAR(100) NOT NULL,
  description VARCHAR(400) NULL,
  is_active TINYINT(1) NOT NULL DEFAULT 1,
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (category_id),
  UNIQUE KEY uq_categories_name (category_name),
  CONSTRAINT chk_categories_is_active CHECK (is_active IN (0, 1))
) ENGINE=InnoDB;

-- Menu items
CREATE TABLE menu_items (
  item_id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  category_id INT UNSIGNED NOT NULL,
  item_name VARCHAR(150) NOT NULL,
  description VARCHAR(800) NULL,
  price DECIMAL(10,2) NOT NULL,
  image_path VARCHAR(255) NULL,
  is_available TINYINT(1) NOT NULL DEFAULT 1,
  is_featured TINYINT(1) NOT NULL DEFAULT 0,
  prep_time_minutes SMALLINT UNSIGNED NOT NULL DEFAULT 15,
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (item_id),
  KEY idx_menu_items_category_id (category_id),
  KEY idx_menu_items_item_name (item_name),
  FULLTEXT KEY ftx_menu_items_search (item_name, description),
  CONSTRAINT fk_menu_items_category
    FOREIGN KEY (category_id) REFERENCES categories(category_id)
    ON UPDATE CASCADE
    ON DELETE RESTRICT,
  CONSTRAINT chk_menu_items_price CHECK (price >= 0),
  CONSTRAINT chk_menu_items_available CHECK (is_available IN (0, 1)),
  CONSTRAINT chk_menu_items_featured CHECK (is_featured IN (0, 1)),
  CONSTRAINT chk_menu_items_prep_time CHECK (prep_time_minutes BETWEEN 1 AND 240)
) ENGINE=InnoDB;

-- Shopping cart
CREATE TABLE cart (
  cart_id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  user_id BIGINT UNSIGNED NOT NULL,
  item_id BIGINT UNSIGNED NOT NULL,
  quantity INT UNSIGNED NOT NULL DEFAULT 1,
  unit_price DECIMAL(10,2) NOT NULL,
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (cart_id),
  UNIQUE KEY uq_cart_user_item (user_id, item_id),
  KEY idx_cart_user_id (user_id),
  KEY idx_cart_item_id (item_id),
  CONSTRAINT fk_cart_user
    FOREIGN KEY (user_id) REFERENCES users(user_id)
    ON UPDATE CASCADE
    ON DELETE CASCADE,
  CONSTRAINT fk_cart_item
    FOREIGN KEY (item_id) REFERENCES menu_items(item_id)
    ON UPDATE CASCADE
    ON DELETE CASCADE,
  CONSTRAINT chk_cart_quantity CHECK (quantity >= 1),
  CONSTRAINT chk_cart_unit_price CHECK (unit_price >= 0)
) ENGINE=InnoDB;

-- Orders
CREATE TABLE orders (
  order_id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  user_id BIGINT UNSIGNED NOT NULL,
  order_type ENUM('DINE_IN', 'DELIVERY', 'TAKEAWAY') NOT NULL,
  order_status ENUM('PENDING', 'PREPARING', 'READY', 'DELIVERED', 'CANCELLED') NOT NULL DEFAULT 'PENDING',
  payment_status ENUM('UNPAID', 'PAID', 'REFUNDED') NOT NULL DEFAULT 'UNPAID',
  subtotal DECIMAL(10,2) NOT NULL DEFAULT 0.00,
  tax DECIMAL(10,2) NOT NULL DEFAULT 0.00,
  delivery_fee DECIMAL(10,2) NOT NULL DEFAULT 0.00,
  discount DECIMAL(10,2) NOT NULL DEFAULT 0.00,
  grand_total DECIMAL(10,2) NOT NULL,
  delivery_address VARCHAR(500) NULL,
  notes VARCHAR(1000) NULL,
  ordered_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (order_id),
  KEY idx_orders_user_id (user_id),
  KEY idx_orders_order_status (order_status),
  KEY idx_orders_ordered_at (ordered_at),
  CONSTRAINT fk_orders_user
    FOREIGN KEY (user_id) REFERENCES users(user_id)
    ON UPDATE CASCADE
    ON DELETE RESTRICT,
  CONSTRAINT chk_orders_amounts_non_negative CHECK (
    subtotal >= 0 AND tax >= 0 AND delivery_fee >= 0 AND discount >= 0 AND grand_total >= 0
  ),
  CONSTRAINT chk_orders_discount_reasonable CHECK (
    discount <= (subtotal + tax + delivery_fee)
  )
) ENGINE=InnoDB;

-- Order line items
CREATE TABLE order_items (
  order_item_id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  order_id BIGINT UNSIGNED NOT NULL,
  item_id BIGINT UNSIGNED NOT NULL,
  quantity INT UNSIGNED NOT NULL,
  unit_price DECIMAL(10,2) NOT NULL,
  line_total DECIMAL(10,2) NOT NULL,
  PRIMARY KEY (order_item_id),
  KEY idx_order_items_order_id (order_id),
  KEY idx_order_items_item_id (item_id),
  CONSTRAINT fk_order_items_order
    FOREIGN KEY (order_id) REFERENCES orders(order_id)
    ON UPDATE CASCADE
    ON DELETE CASCADE,
  CONSTRAINT fk_order_items_item
    FOREIGN KEY (item_id) REFERENCES menu_items(item_id)
    ON UPDATE CASCADE
    ON DELETE RESTRICT,
  CONSTRAINT chk_order_items_quantity CHECK (quantity >= 1),
  CONSTRAINT chk_order_items_amounts CHECK (unit_price >= 0 AND line_total >= 0)
) ENGINE=InnoDB;

-- Payments (one payment row per order)
CREATE TABLE payments (
  payment_id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  order_id BIGINT UNSIGNED NOT NULL,
  payment_method ENUM('CASH', 'CARD', 'ESEWA', 'KHALTI') NOT NULL,
  transaction_ref VARCHAR(120) NULL,
  amount DECIMAL(10,2) NOT NULL,
  payment_status ENUM('PENDING', 'PAID', 'FAILED', 'REFUNDED') NOT NULL DEFAULT 'PENDING',
  paid_at DATETIME NULL,
  PRIMARY KEY (payment_id),
  UNIQUE KEY uq_payments_order_id (order_id),
  UNIQUE KEY uq_payments_transaction_ref (transaction_ref),
  KEY idx_payments_status (payment_status),
  CONSTRAINT fk_payments_order
    FOREIGN KEY (order_id) REFERENCES orders(order_id)
    ON UPDATE CASCADE
    ON DELETE RESTRICT,
  CONSTRAINT chk_payments_amount CHECK (amount >= 0)
) ENGINE=InnoDB;

-- Restaurant dining tables
CREATE TABLE restaurant_tables (
  table_id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  table_number VARCHAR(20) NOT NULL,
  capacity TINYINT UNSIGNED NOT NULL,
  is_active TINYINT(1) NOT NULL DEFAULT 1,
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (table_id),
  UNIQUE KEY uq_restaurant_tables_number (table_number),
  CONSTRAINT chk_restaurant_tables_capacity CHECK (capacity BETWEEN 1 AND 30)
) ENGINE=InnoDB;

-- Table reservations
CREATE TABLE reservations (
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
  KEY idx_reservations_date (reservation_date),
  KEY idx_reservations_status (status),
  CONSTRAINT fk_reservations_user
    FOREIGN KEY (user_id) REFERENCES users(user_id)
    ON UPDATE CASCADE
    ON DELETE RESTRICT,
  CONSTRAINT fk_reservations_table
    FOREIGN KEY (table_id) REFERENCES restaurant_tables(table_id)
    ON UPDATE CASCADE
    ON DELETE SET NULL,
  CONSTRAINT chk_reservations_guests CHECK (guests_count BETWEEN 1 AND 30)
) ENGINE=InnoDB;

-- Customer feedback
CREATE TABLE feedback (
  feedback_id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  user_id BIGINT UNSIGNED NOT NULL,
  order_id BIGINT UNSIGNED NULL,
  rating TINYINT UNSIGNED NOT NULL,
  comments VARCHAR(1000) NULL,
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (feedback_id),
  KEY idx_feedback_user_id (user_id),
  KEY idx_feedback_order_id (order_id),
  CONSTRAINT fk_feedback_user
    FOREIGN KEY (user_id) REFERENCES users(user_id)
    ON UPDATE CASCADE
    ON DELETE RESTRICT,
  CONSTRAINT fk_feedback_order
    FOREIGN KEY (order_id) REFERENCES orders(order_id)
    ON UPDATE CASCADE
    ON DELETE SET NULL,
  CONSTRAINT chk_feedback_rating CHECK (rating BETWEEN 1 AND 5)
) ENGINE=InnoDB;

-- -----------------------------
-- 3) Sample Seed Data
-- -----------------------------

-- Admin accounts
-- Default login: admin@smartrestaurant.com / password
INSERT INTO admins (full_name, email, password, status, created_at) VALUES
('System Administrator', 'admin@smartrestaurant.com', '$2a$10$7EqJtq98hPqEX7fNZaFWoO.jR1uR6A7dBDEuDfSUdifYEYTbSsfXO', 'ACTIVE', '2026-01-01 08:00:00'),
('Himalayans Yaks', 'yaks@restro.com', '$2a$10$wzpG3.BLpZyQE69n9DckBeySQxZMdBVT9blkEFGwSSkNm40z8T8Xy', 'ACTIVE', '2026-01-01 08:05:00');

-- 5 users
INSERT INTO users (full_name, email, phone, password, address, status, created_at, updated_at) VALUES
('Aarav Shrestha', 'aarav.shrestha@gmail.com', '9801000001', '$2a$12$9tS7QmV1yF8uA3nX5dLq2eB4hR6kW0pJc7zN9vT1mY3sH8uL4rE2G', 'Baneshwor, Kathmandu', 'ACTIVE', '2026-01-05 09:10:00', '2026-01-05 09:10:00'),
('Sita Gurung', 'sita.gurung@gmail.com', '9801000002', '$2a$12$8kD6RmU2xE7vB4mW1pQz3nC5gT9hJ2sLq6yN1vF8rM4wP0aX7cD3H', 'Pokhara-8, Kaski', 'ACTIVE', '2026-01-06 10:00:00', '2026-01-06 10:00:00'),
('Ramesh Karki', 'ramesh.karki@gmail.com', '9801000003', '$2a$12$7jC5QlT3wD6uC5lV2oPy4mB6fS8gK1rMp5xM2uE7qL3vN9zW6bC4J', 'Bharatpur, Chitwan', 'ACTIVE', '2026-01-07 11:20:00', '2026-01-07 11:20:00'),
('Nima Tamang', 'nima.tamang@gmail.com', '9801000004', '$2a$12$6hB4PkS4vC5tD6kU3nOx5lA7eR7fL0qNo4wL3tD6pK2uM8yV5aB5K', 'Lalitpur, Jawalakhel', 'ACTIVE', '2026-01-08 12:15:00', '2026-01-08 12:15:00'),
('Priya Rai', 'priya.rai@gmail.com', '9801000005', '$2a$12$5gA3OjR5uB4sE7jT4mNw6kZ8dQ6eM9pMn3vK4sC5oJ1tL7xU4zA6L', 'Dharan, Sunsari', 'ACTIVE', '2026-01-09 14:30:00', '2026-01-09 14:30:00');

-- 5 categories
INSERT INTO categories (category_name, description, is_active, created_at) VALUES
('Appetizers', 'Starters and light bites to begin your meal.', 1, '2026-01-01 08:30:00'),
('Main Course', 'Hearty and fulfilling main dishes.', 1, '2026-01-01 08:30:00'),
('Beverages', 'Hot and cold drinks.', 1, '2026-01-01 08:30:00'),
('Desserts', 'Sweet treats and bakery specials.', 1, '2026-01-01 08:30:00'),
('Nepali Specials', 'Authentic Nepali favorites.', 1, '2026-01-01 08:30:00');

-- 15 menu items
INSERT INTO menu_items (category_id, item_name, description, price, image_path, is_available, is_featured, prep_time_minutes, created_at, updated_at) VALUES
 (1, 'Chicken Momo (8 pcs)', 'Steamed dumplings with spiced chicken filling.', 220.00, 'assets/images/foods/chicken-momo.svg', 1, 1, 18, '2026-01-02 09:00:00', '2026-01-02 09:00:00'),
 (1, 'Veg Spring Rolls', 'Crispy rolls served with sweet chili dip.', 180.00, 'assets/images/foods/veg-spring-rolls.svg', 1, 0, 12, '2026-01-02 09:00:00', '2026-01-02 09:00:00'),
 (1, 'Paneer Chilli', 'Stir-fried paneer cubes with peppers and sauce.', 260.00, 'assets/images/foods/paneer-chilli.svg', 1, 0, 16, '2026-01-02 09:00:00', '2026-01-02 09:00:00'),

 (2, 'Grilled Chicken Sizzler', 'Grilled chicken with sauteed vegetables and fries.', 640.00, 'assets/images/foods/chicken-sizzler.svg', 1, 1, 25, '2026-01-02 09:05:00', '2026-01-02 09:05:00'),
 (2, 'Paneer Butter Masala', 'Creamy tomato gravy with paneer cubes.', 480.00, 'assets/images/foods/paneer-butter-masala.svg', 1, 0, 22, '2026-01-02 09:05:00', '2026-01-02 09:05:00'),
 (2, 'Mushroom Fried Rice', 'Wok-tossed rice with mushroom and vegetables.', 350.00, 'assets/images/foods/mushroom-fried-rice.svg', 1, 0, 15, '2026-01-02 09:05:00', '2026-01-02 09:05:00'),

 (3, 'Masala Tea', 'Traditional Nepali masala chiya.', 80.00, 'assets/images/foods/masala-tea.svg', 1, 0, 8, '2026-01-02 09:10:00', '2026-01-02 09:10:00'),
 (3, 'Lassi (Sweet)', 'Refreshing yogurt-based drink.', 140.00, 'assets/images/foods/lassi-sweet.svg', 1, 0, 7, '2026-01-02 09:10:00', '2026-01-02 09:10:00'),
 (3, 'Fresh Lime Soda', 'Sparkling lime soda with mint.', 130.00, 'assets/images/foods/fresh-lime-soda.svg', 1, 0, 6, '2026-01-02 09:10:00', '2026-01-02 09:10:00'),

 (4, 'Gulab Jamun (2 pcs)', 'Soft milk-solid dumplings in sugar syrup.', 150.00, 'assets/images/foods/gulab-jamun.svg', 1, 0, 10, '2026-01-02 09:15:00', '2026-01-02 09:15:00'),
 (4, 'Chocolate Brownie', 'Warm brownie served with vanilla scoop.', 220.00, 'assets/images/foods/chocolate-brownie.svg', 1, 1, 12, '2026-01-02 09:15:00', '2026-01-02 09:15:00'),
 (4, 'Yomari', 'Traditional Newari sweet steamed dumpling.', 170.00, 'assets/images/foods/yomari.svg', 1, 0, 14, '2026-01-02 09:15:00', '2026-01-02 09:15:00'),

 (5, 'Thakali Khana Set', 'Rice, lentils, curry, greens, pickle and meat/veg choice.', 690.00, 'assets/images/foods/thakali-set.svg', 1, 1, 28, '2026-01-02 09:20:00', '2026-01-02 09:20:00'),
 (5, 'Buff Choila', 'Smoky spiced buff cubes, Newari style.', 420.00, 'assets/images/foods/buff-choila.svg', 1, 1, 20, '2026-01-02 09:20:00', '2026-01-02 09:20:00'),
 (5, 'Sel Roti Set', 'Traditional sel roti served with aloo tarkari.', 240.00, 'assets/images/foods/sel-roti-set.svg', 1, 0, 18, '2026-01-02 09:20:00', '2026-01-02 09:20:00');

-- 5 cart rows
INSERT INTO cart (user_id, item_id, quantity, unit_price, created_at) VALUES
(1, 1, 2, 220.00, '2026-02-01 12:05:00'),
(2, 13, 1, 690.00, '2026-02-01 12:10:00'),
(3, 4, 1, 640.00, '2026-02-01 12:15:00'),
(4, 8, 2, 140.00, '2026-02-01 12:18:00'),
(5, 15, 1, 240.00, '2026-02-01 12:20:00');

-- 8 orders
INSERT INTO orders (
  user_id, order_type, order_status, payment_status,
  subtotal, tax, delivery_fee, discount, grand_total,
  delivery_address, notes, ordered_at, updated_at
) VALUES
(1, 'DELIVERY', 'DELIVERED', 'PAID', 620.00, 80.60, 60.00, 50.00, 710.60, 'Baneshwor, Kathmandu', 'Extra spicy momo chutney', '2026-02-02 13:00:00', '2026-02-02 14:10:00'),
(2, 'DINE_IN', 'DELIVERED', 'PAID', 930.00, 120.90, 0.00, 0.00, 1050.90, NULL, 'Table near window', '2026-02-03 19:20:00', '2026-02-03 20:45:00'),
(3, 'TAKEAWAY', 'READY', 'PAID', 570.00, 74.10, 0.00, 20.00, 624.10, NULL, 'Call on arrival', '2026-02-04 18:05:00', '2026-02-04 18:50:00'),
(4, 'DELIVERY', 'PREPARING', 'UNPAID', 780.00, 101.40, 80.00, 0.00, 961.40, 'Jawalakhel, Lalitpur', 'No onion in fried rice', '2026-02-05 20:15:00', '2026-02-05 20:20:00'),
(5, 'DELIVERY', 'CANCELLED', 'REFUNDED', 860.00, 111.80, 60.00, 0.00, 1031.80, 'Dharan, Sunsari', 'Deliver before 8 PM', '2026-02-06 17:30:00', '2026-02-06 18:05:00'),
(1, 'DINE_IN', 'DELIVERED', 'PAID', 540.00, 70.20, 0.00, 40.00, 570.20, NULL, 'Birthday dinner', '2026-02-08 19:40:00', '2026-02-08 21:00:00'),
(2, 'TAKEAWAY', 'PENDING', 'UNPAID', 350.00, 45.50, 0.00, 0.00, 395.50, NULL, 'Pack cutlery', '2026-02-09 12:25:00', '2026-02-09 12:25:00'),
(3, 'DELIVERY', 'DELIVERED', 'PAID', 1140.00, 148.20, 80.00, 100.00, 1268.20, 'Bharatpur, Chitwan', 'Ring bell once', '2026-02-10 20:05:00', '2026-02-10 21:30:00');

-- related order_items
INSERT INTO order_items (order_id, item_id, quantity, unit_price, line_total) VALUES
(1, 1, 2, 220.00, 440.00),
(1, 9, 1, 130.00, 130.00),
(1, 10, 1, 150.00, 150.00),

(2, 13, 1, 690.00, 690.00),
(2, 7, 2, 80.00, 160.00),
(2, 12, 1, 170.00, 170.00),

(3, 5, 1, 480.00, 480.00),
(3, 8, 1, 140.00, 140.00),

(4, 4, 1, 640.00, 640.00),
(4, 8, 1, 140.00, 140.00),

(5, 13, 1, 690.00, 690.00),
(5, 14, 1, 420.00, 420.00),

(6, 6, 1, 350.00, 350.00),
(6, 11, 1, 220.00, 220.00),

(7, 6, 1, 350.00, 350.00),

(8, 13, 1, 690.00, 690.00),
(8, 4, 1, 640.00, 640.00),
(8, 3, 1, 260.00, 260.00);

-- 8 payments (one per order)
INSERT INTO payments (order_id, payment_method, transaction_ref, amount, payment_status, paid_at) VALUES
(1, 'ESEWA', 'ESEWA-20260202-0001', 710.60, 'PAID', '2026-02-02 14:05:00'),
(2, 'CARD', 'CARD-20260203-0002', 1050.90, 'PAID', '2026-02-03 20:40:00'),
(3, 'KHALTI', 'KHALTI-20260204-0003', 624.10, 'PAID', '2026-02-04 18:45:00'),
(4, 'CASH', NULL, 961.40, 'PENDING', NULL),
(5, 'ESEWA', 'ESEWA-20260206-0005', 1031.80, 'REFUNDED', '2026-02-06 17:45:00'),
(6, 'CARD', 'CARD-20260208-0006', 570.20, 'PAID', '2026-02-08 20:58:00'),
(7, 'KHALTI', 'KHALTI-20260209-0007', 395.50, 'FAILED', NULL),
(8, 'ESEWA', 'ESEWA-20260210-0008', 1268.20, 'PAID', '2026-02-10 21:25:00');

-- Restaurant tables
INSERT INTO restaurant_tables (table_number, capacity, is_active) VALUES
('T01', 2, 1),
('T02', 2, 1),
('T03', 4, 1),
('T04', 4, 1),
('T05', 6, 1),
('T06', 8, 1);

-- 5 reservations
INSERT INTO reservations (
  user_id, reservation_date, reservation_time, guests_count,
  table_number, table_id, status, special_request, created_at
) VALUES
(1, '2026-02-15', '19:30:00', 4, 'T03', 3, 'APPROVED', 'Birthday decoration required', '2026-02-11 10:00:00'),
(2, '2026-02-16', '13:00:00', 2, 'T01', 1, 'APPROVED', 'Non-smoking area', '2026-02-11 10:05:00'),
(3, '2026-02-17', '20:00:00', 6, 'T05', 5, 'PENDING', 'High chair for child', '2026-02-11 10:10:00'),
(4, '2026-02-18', '18:45:00', 3, 'T04', 4, 'REJECTED', 'Requested rooftop seating', '2026-02-11 10:15:00'),
(5, '2026-02-19', '19:00:00', 5, 'T05', 5, 'CANCELLED', 'Late arrival by 15 minutes', '2026-02-11 10:20:00');

-- 5 feedback rows
INSERT INTO feedback (user_id, order_id, rating, comments, created_at) VALUES
(1, 1, 5, 'Fast delivery and momo tasted excellent.', '2026-02-03 09:00:00'),
(2, 2, 4, 'Great Thakali set, service was polite and quick.', '2026-02-04 10:30:00'),
(3, 3, 4, 'Takeaway was neatly packed and still warm.', '2026-02-05 11:45:00'),
(5, 5, 2, 'Order was cancelled after long wait, refund was processed.', '2026-02-07 08:20:00'),
(3, NULL, 5, 'Loved the ambiance and menu variety overall.', '2026-02-11 19:40:00');

-- =========================================================
-- End of Script
-- =========================================================
