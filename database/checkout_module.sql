-- =========================================================
-- Smart Restaurant - Checkout and Order Placement Module
-- MySQL 8+ / InnoDB / UTF8MB4
-- =========================================================

USE smart_restaurant;

SET FOREIGN_KEY_CHECKS = 0;
DROP TABLE IF EXISTS payments;
DROP TABLE IF EXISTS order_items;
DROP TABLE IF EXISTS orders;
SET FOREIGN_KEY_CHECKS = 1;

-- ---------------------------------------------------------
-- Orders Table
-- ---------------------------------------------------------
CREATE TABLE IF NOT EXISTS orders (
  order_id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  order_number VARCHAR(40) NOT NULL,
  user_id BIGINT UNSIGNED NOT NULL,
  order_type ENUM('DINE_IN', 'DELIVERY', 'TAKEAWAY') NOT NULL,
  order_status ENUM('PENDING', 'PREPARING', 'READY', 'DELIVERED', 'CANCELLED') NOT NULL DEFAULT 'PENDING',
  payment_status ENUM('UNPAID', 'PAID', 'FAILED', 'REFUNDED') NOT NULL DEFAULT 'UNPAID',
  subtotal DECIMAL(10,2) NOT NULL DEFAULT 0.00,
  tax DECIMAL(10,2) NOT NULL DEFAULT 0.00,
  delivery_fee DECIMAL(10,2) NOT NULL DEFAULT 0.00,
  discount DECIMAL(10,2) NOT NULL DEFAULT 0.00,
  grand_total DECIMAL(10,2) NOT NULL,
  delivery_address VARCHAR(500) NULL,
  phone_snapshot VARCHAR(20) NULL,
  notes VARCHAR(1000) NULL,
  ordered_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (order_id),
  UNIQUE KEY uq_orders_order_number (order_number),
  KEY idx_orders_user_id (user_id),
  KEY idx_orders_order_status (order_status),
  KEY idx_orders_ordered_at (ordered_at),
  CONSTRAINT fk_orders_user_checkout
    FOREIGN KEY (user_id) REFERENCES users(user_id)
    ON UPDATE CASCADE
    ON DELETE RESTRICT,
  CONSTRAINT chk_orders_total_positive CHECK (grand_total >= 0)
) ENGINE=InnoDB;

-- ---------------------------------------------------------
-- Order Items Table
-- ---------------------------------------------------------
CREATE TABLE IF NOT EXISTS order_items (
  order_item_id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  order_id BIGINT UNSIGNED NOT NULL,
  item_id BIGINT UNSIGNED NOT NULL,
  quantity INT UNSIGNED NOT NULL,
  unit_price DECIMAL(10,2) NOT NULL,
  line_total DECIMAL(10,2) NOT NULL,
  PRIMARY KEY (order_item_id),
  KEY idx_order_items_order_id (order_id),
  KEY idx_order_items_item_id (item_id),
  CONSTRAINT fk_order_items_order_checkout
    FOREIGN KEY (order_id) REFERENCES orders(order_id)
    ON UPDATE CASCADE
    ON DELETE CASCADE,
  CONSTRAINT fk_order_items_menu_item_checkout
    FOREIGN KEY (item_id) REFERENCES menu_items(item_id)
    ON UPDATE CASCADE
    ON DELETE RESTRICT,
  CONSTRAINT chk_order_items_qty CHECK (quantity > 0)
) ENGINE=InnoDB;

-- ---------------------------------------------------------
-- Payments Table
-- ---------------------------------------------------------
CREATE TABLE IF NOT EXISTS payments (
  payment_id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  order_id BIGINT UNSIGNED NOT NULL,
  payment_method ENUM('CASH', 'CARD', 'ESEWA', 'KHALTI') NOT NULL,
  transaction_ref VARCHAR(120) NULL,
  amount DECIMAL(10,2) NOT NULL,
  payment_status ENUM('PENDING', 'PAID', 'FAILED', 'REFUNDED') NOT NULL DEFAULT 'PENDING',
  paid_at DATETIME NULL,
  PRIMARY KEY (payment_id),
  UNIQUE KEY uq_payments_order_id_checkout (order_id),
  KEY idx_payments_method (payment_method),
  CONSTRAINT fk_payments_order_checkout
    FOREIGN KEY (order_id) REFERENCES orders(order_id)
    ON UPDATE CASCADE
    ON DELETE CASCADE
) ENGINE=InnoDB;

-- ---------------------------------------------------------
-- Sample Data
-- ---------------------------------------------------------
INSERT INTO orders (
  order_number, user_id, order_type, order_status, payment_status,
  subtotal, tax, delivery_fee, discount, grand_total,
  delivery_address, phone_snapshot, notes, ordered_at
) VALUES
('ORD-202604280915-AB12CD', 1, 'DELIVERY', 'PENDING', 'UNPAID', 980.00, 127.40, 100.00, 50.00, 1157.40, 'Baneshwor, Kathmandu', '9801000001', 'Ring bell once', NOW() - INTERVAL 2 DAY),
('ORD-202604281030-EF34GH', 2, 'DINE_IN', 'READY', 'PAID', 760.00, 98.80, 0.00, 0.00, 858.80, NULL, NULL, 'Window table preferred', NOW() - INTERVAL 1 DAY),
('ORD-202604281245-IJ56KL', 3, 'TAKEAWAY', 'DELIVERED', 'PAID', 540.00, 70.20, 0.00, 0.00, 610.20, NULL, NULL, 'Pickup after 20 mins', NOW() - INTERVAL 6 HOUR)
ON DUPLICATE KEY UPDATE
  order_status = VALUES(order_status),
  payment_status = VALUES(payment_status),
  grand_total = VALUES(grand_total),
  updated_at = CURRENT_TIMESTAMP;

INSERT INTO order_items (order_id, item_id, quantity, unit_price, line_total)
SELECT o.order_id, m.item_id, x.qty, x.unit_price, (x.qty * x.unit_price)
FROM (
  SELECT 'ORD-202604280915-AB12CD' AS order_number, 1 AS menu_idx, 2 AS qty, 240.00 AS unit_price
  UNION ALL SELECT 'ORD-202604280915-AB12CD', 5, 1, 680.00
  UNION ALL SELECT 'ORD-202604281030-EF34GH', 8, 1, 720.00
  UNION ALL SELECT 'ORD-202604281030-EF34GH', 14, 2, 90.00
  UNION ALL SELECT 'ORD-202604281245-IJ56KL', 17, 1, 240.00
  UNION ALL SELECT 'ORD-202604281245-IJ56KL', 11, 1, 300.00
) x
JOIN orders o ON o.order_number = x.order_number
JOIN menu_items m ON m.item_id = x.menu_idx;

INSERT INTO payments (order_id, payment_method, transaction_ref, amount, payment_status, paid_at)
SELECT o.order_id, p.payment_method, p.transaction_ref, p.amount, p.payment_status, p.paid_at
FROM (
  SELECT 'ORD-202604280915-AB12CD' AS order_number, 'CASH' AS payment_method, NULL AS transaction_ref, 1157.40 AS amount, 'PENDING' AS payment_status, NULL AS paid_at
  UNION ALL SELECT 'ORD-202604281030-EF34GH', 'ESEWA', 'TXN-ORD-202604281030-EF34GH', 858.80, 'PAID', NOW() - INTERVAL 1 DAY
  UNION ALL SELECT 'ORD-202604281245-IJ56KL', 'KHALTI', 'TXN-ORD-202604281245-IJ56KL', 610.20, 'PAID', NOW() - INTERVAL 5 HOUR
) p
JOIN orders o ON o.order_number = p.order_number
ON DUPLICATE KEY UPDATE
  payment_status = VALUES(payment_status),
  amount = VALUES(amount),
  paid_at = VALUES(paid_at);
