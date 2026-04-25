-- =========================================================
-- Smart Restaurant - Menu Management Module
-- MySQL 8+ / InnoDB / UTF8MB4
-- =========================================================

USE smart_restaurant;

SET FOREIGN_KEY_CHECKS = 0;
DROP TABLE IF EXISTS menu_items;
DROP TABLE IF EXISTS categories;
SET FOREIGN_KEY_CHECKS = 1;

-- -----------------------------
-- Categories Table
-- -----------------------------
CREATE TABLE categories (
  category_id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  category_name VARCHAR(100) NOT NULL,
  description VARCHAR(400) NULL,
  is_active TINYINT(1) NOT NULL DEFAULT 1,
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (category_id),
  UNIQUE KEY uq_categories_name (category_name),
  CONSTRAINT chk_categories_active CHECK (is_active IN (0, 1))
) ENGINE=InnoDB;

-- -----------------------------
-- Menu Items Table
-- -----------------------------
CREATE TABLE menu_items (
  item_id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  category_id BIGINT UNSIGNED NOT NULL,
  item_name VARCHAR(160) NOT NULL,
  description VARCHAR(1000) NULL,
  price DECIMAL(10,2) NOT NULL,
  image_path VARCHAR(255) NULL,
  is_available TINYINT(1) NOT NULL DEFAULT 1,
  is_featured TINYINT(1) NOT NULL DEFAULT 0,
  prep_time_minutes SMALLINT UNSIGNED NOT NULL DEFAULT 15,
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (item_id),
  CONSTRAINT fk_menu_items_category
    FOREIGN KEY (category_id) REFERENCES categories(category_id)
    ON UPDATE CASCADE
    ON DELETE RESTRICT,
  CONSTRAINT chk_menu_item_price CHECK (price >= 0),
  CONSTRAINT chk_menu_item_available CHECK (is_available IN (0, 1)),
  CONSTRAINT chk_menu_item_featured CHECK (is_featured IN (0, 1)),
  CONSTRAINT chk_menu_item_prep CHECK (prep_time_minutes BETWEEN 1 AND 240)
) ENGINE=InnoDB;

-- Required Indexes
CREATE INDEX idx_menu_items_category_id ON menu_items(category_id);
CREATE INDEX idx_menu_items_item_name ON menu_items(item_name);
CREATE INDEX idx_menu_items_is_available ON menu_items(is_available);

-- -----------------------------
-- Seed Categories (8)
-- -----------------------------
INSERT INTO categories (category_name, description, is_active) VALUES
('Appetizers', 'Starters and shareable bites', 1),
('Soups', 'Warm and comforting soups', 1),
('Main Course', 'Hearty mains and chef specials', 1),
('Nepali Specials', 'Traditional Nepali delicacies', 1),
('Fast Food', 'Quick snacks and street favorites', 1),
('Beverages', 'Hot and cold drinks', 1),
('Desserts', 'Sweet endings and bakery treats', 1),
('Salads', 'Fresh and healthy bowls', 1);

-- -----------------------------
-- Seed Menu Items (20)
-- -----------------------------
INSERT INTO menu_items (category_id, item_name, description, price, image_path, is_available, is_featured, prep_time_minutes) VALUES
(1, 'Chicken Momo (8 pcs)', 'Steamed dumplings with spicy house chutney.', 240.00, 'uploads/menu/sample-chicken-momo.jpg', 1, 1, 18),
(1, 'Paneer Tikka Bites', 'Char-grilled paneer cubes with mint yogurt dip.', 310.00, 'uploads/menu/sample-paneer-tikka.jpg', 1, 0, 16),
(2, 'Hot and Sour Soup', 'Classic veg soup with mild tang and spice.', 190.00, 'uploads/menu/sample-hot-sour.jpg', 1, 0, 10),
(2, 'Chicken Corn Soup', 'Creamy soup with shredded chicken and sweet corn.', 210.00, 'uploads/menu/sample-chicken-corn.jpg', 1, 0, 12),
(3, 'Grilled Chicken Sizzler', 'Sizzling grilled chicken with sauteed vegetables.', 680.00, 'uploads/menu/sample-sizzler.jpg', 1, 1, 25),
(3, 'Paneer Butter Masala', 'Creamy tomato-cashew gravy with paneer cubes.', 520.00, 'uploads/menu/sample-paneer-butter.jpg', 1, 0, 22),
(3, 'Mushroom Fried Rice', 'Wok-tossed rice with mushrooms and herbs.', 380.00, 'uploads/menu/sample-mushroom-rice.jpg', 1, 0, 15),
(4, 'Thakali Khana Set', 'Complete thali with rice, dal, curry, achar, and greens.', 720.00, 'uploads/menu/sample-thakali.jpg', 1, 1, 28),
(4, 'Buff Choila', 'Smoky buff cubes tossed in Newari spices.', 450.00, 'uploads/menu/sample-choila.jpg', 1, 1, 20),
(4, 'Sel Roti Set', 'Traditional sel roti with aloo tarkari.', 260.00, 'uploads/menu/sample-sel-roti.jpg', 1, 0, 18),
(5, 'Crispy Chicken Burger', 'Juicy chicken patty with lettuce and signature sauce.', 340.00, 'uploads/menu/sample-burger.jpg', 1, 0, 14),
(5, 'Loaded French Fries', 'Cheese, jalapeno, and herb-seasoned fries.', 260.00, 'uploads/menu/sample-fries.jpg', 1, 0, 12),
(5, 'Veg Wrap', 'Soft wrap with grilled veggies and garlic mayo.', 280.00, 'uploads/menu/sample-wrap.jpg', 1, 0, 13),
(6, 'Masala Chiya', 'Traditional Nepali milk tea with spices.', 90.00, 'uploads/menu/sample-chiya.jpg', 1, 0, 7),
(6, 'Fresh Lime Soda', 'Sparkling lime and mint refresher.', 150.00, 'uploads/menu/sample-lime-soda.jpg', 1, 0, 6),
(6, 'Mango Lassi', 'Thick yogurt smoothie with ripe mango pulp.', 180.00, 'uploads/menu/sample-lassi.jpg', 1, 0, 8),
(7, 'Chocolate Brownie', 'Warm brownie topped with vanilla cream.', 240.00, 'uploads/menu/sample-brownie.jpg', 1, 1, 12),
(7, 'Gulab Jamun (2 pcs)', 'Soft syrup-soaked milk dumplings.', 160.00, 'uploads/menu/sample-gulab-jamun.jpg', 1, 0, 8),
(8, 'Grilled Chicken Salad', 'Greens, grilled chicken, olives, and citrus dressing.', 390.00, 'uploads/menu/sample-chicken-salad.jpg', 1, 0, 14),
(8, 'Quinoa Veg Salad', 'Protein-rich quinoa with fresh seasonal vegetables.', 360.00, 'uploads/menu/sample-quinoa-salad.jpg', 0, 0, 11);
