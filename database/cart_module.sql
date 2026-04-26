-- =========================================================
-- Smart Restaurant - Cart Management Module
-- MySQL 8+ / InnoDB / UTF8MB4
-- =========================================================

USE smart_restaurant;

DROP TABLE IF EXISTS cart;

CREATE TABLE cart (
  cart_id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  user_id BIGINT UNSIGNED NOT NULL,
  item_id BIGINT UNSIGNED NOT NULL,
  quantity INT UNSIGNED NOT NULL DEFAULT 1,
  unit_price DECIMAL(10,2) NOT NULL,
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (cart_id),
  UNIQUE KEY uq_cart_user_item (user_id, item_id),
  KEY idx_cart_user_id (user_id),
  KEY idx_cart_item_id (item_id),
  KEY idx_cart_user_item (user_id, item_id),
  CONSTRAINT fk_cart_user
    FOREIGN KEY (user_id) REFERENCES users(user_id)
    ON UPDATE CASCADE
    ON DELETE CASCADE,
  CONSTRAINT fk_cart_item
    FOREIGN KEY (item_id) REFERENCES menu_items(item_id)
    ON UPDATE CASCADE
    ON DELETE CASCADE,
  CONSTRAINT chk_cart_quantity_positive CHECK (quantity > 0)
) ENGINE=InnoDB;

-- Sample cart rows
INSERT INTO cart (user_id, item_id, quantity, unit_price) VALUES
(1, 1, 2, 240.00),
(1, 5, 1, 680.00),
(2, 8, 1, 720.00),
(2, 14, 2, 90.00),
(3, 17, 1, 240.00);
