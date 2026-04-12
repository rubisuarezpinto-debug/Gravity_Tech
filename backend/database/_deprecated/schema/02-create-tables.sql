-- ##################################################
-- #            DDL SCRIPT: CREATE TABLES           #
-- ##################################################
-- Estructura adaptada al Backend (Node.js/Express)
-- Sincronizada con modelos: User, Product, Order, etc.

-- ##################################################
-- #                 CATALOG TABLES                 #
-- ##################################################

-- Table: categories
CREATE TABLE IF NOT EXISTS categories (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL
);

-- Table: brands
CREATE TABLE IF NOT EXISTS brands (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL
);

-- Table: shipping_types
CREATE TABLE IF NOT EXISTS shipping_types (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL
);

-- Table: order_statuses
CREATE TABLE IF NOT EXISTS order_statuses (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL
);

-- Table: payment_methods
CREATE TABLE IF NOT EXISTS payment_methods (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL
);

-- ##################################################
-- #                  USER MODULE                   #
-- ##################################################

-- Table: users
CREATE TABLE IF NOT EXISTS users (
    id SERIAL PRIMARY KEY,
    name VARCHAR(150),
    email VARCHAR(150) NOT NULL UNIQUE,
    password_hash VARCHAR(255) NOT NULL,
    role VARCHAR(20) DEFAULT 'cliente',
    active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Table: addresses
CREATE TABLE IF NOT EXISTS addresses (
    id SERIAL PRIMARY KEY,
    user_id INTEGER NOT NULL,
    address VARCHAR(255) NOT NULL,
    city VARCHAR(100) NOT NULL,
    country VARCHAR(100) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Table: user_payment_methods
CREATE TABLE IF NOT EXISTS user_payment_methods (
    user_id INTEGER NOT NULL,
    payment_method_id INTEGER NOT NULL,
    active BOOLEAN DEFAULT TRUE,
    PRIMARY KEY (user_id, payment_method_id)
);

-- ##################################################
-- #                PRODUCT MODULE                  #
-- ##################################################

-- Table: products
CREATE TABLE IF NOT EXISTS products (
    id SERIAL PRIMARY KEY,
    name VARCHAR(200) NOT NULL,
    description TEXT,
    price DECIMAL(10, 2) NOT NULL,
    stock INTEGER DEFAULT 0,
    sku VARCHAR(50) UNIQUE,
    image_url VARCHAR(500),
    brand_id INTEGER,
    active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Table: product_categories
CREATE TABLE IF NOT EXISTS product_categories (
    product_id INTEGER NOT NULL,
    category_id INTEGER NOT NULL,
    PRIMARY KEY (product_id, category_id)
);

-- Table: images
CREATE TABLE IF NOT EXISTS images (
    id SERIAL PRIMARY KEY,
    product_id INTEGER NOT NULL,
    url VARCHAR(500) NOT NULL
);

-- Table: reviews
CREATE TABLE IF NOT EXISTS reviews (
    id SERIAL PRIMARY KEY,
    user_id INTEGER NOT NULL,
    product_id INTEGER NOT NULL,
    comment TEXT,
    rating INTEGER CHECK (rating >= 1 AND rating <= 5),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- ##################################################
-- #                 CART MODULE                    #
-- ##################################################

-- Table: carts
CREATE TABLE IF NOT EXISTS carts (
    id SERIAL PRIMARY KEY,
    user_id INTEGER NOT NULL,
    status VARCHAR(20) DEFAULT 'ABIERTO',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Table: cart_items
-- Nota: El modelo Cart.js usa user_id directamente en cart_items en algunas queries
CREATE TABLE IF NOT EXISTS cart_items (
    id SERIAL PRIMARY KEY,
    user_id INTEGER, -- Agregado para compatibilidad con Cart.js
    cart_id INTEGER,
    product_id INTEGER NOT NULL,
    quantity INTEGER NOT NULL DEFAULT 1,
    unit_price DECIMAL(10, 2),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE (user_id, product_id) -- Para ON CONFLICT en Cart.js
);

-- ##################################################
-- #                 ORDER MODULE                   #
-- ##################################################

-- Table: orders
CREATE TABLE IF NOT EXISTS orders (
    id SERIAL PRIMARY KEY,
    user_id INTEGER NOT NULL,
    address_id INTEGER,
    payment_method_id INTEGER,
    shipping_type_id INTEGER,
    status_id INTEGER, -- FK a order_statuses
    status VARCHAR(50) DEFAULT 'pending', -- Usado directamente en Order.js
    total DECIMAL(10, 2) NOT NULL DEFAULT 0.00,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Table: order_items
CREATE TABLE IF NOT EXISTS order_items (
    id SERIAL PRIMARY KEY,
    order_id INTEGER NOT NULL,
    product_id INTEGER NOT NULL,
    quantity INTEGER NOT NULL DEFAULT 1,
    unit_price DECIMAL(10, 2) NOT NULL
);

-- Table: payments
CREATE TABLE IF NOT EXISTS payments (
    id SERIAL PRIMARY KEY,
    order_id INTEGER NOT NULL,
    amount DECIMAL(10, 2) NOT NULL,
    method VARCHAR(50), -- card, cash, transfer
    reference VARCHAR(150),
    status VARCHAR(50) NOT NULL DEFAULT 'completed',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- ##################################################
-- #                 AUDIT MODULE                   #
-- ##################################################

-- Table: audits
CREATE TABLE IF NOT EXISTS audits (
    id SERIAL PRIMARY KEY,
    user_id INTEGER,
    action VARCHAR(100) NOT NULL,
    entity VARCHAR(100) NOT NULL,
    details TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

