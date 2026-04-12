-- ##################################################
-- #            DDL SCRIPT: CREATE TABLES           #
-- ##################################################
-- This script defines the database structure for the eCommerce platform.
-- Includes tables mapped from the ERD Diagram.
-- Foreign keys are specified in a separate script (03-alter-tables.sql)
-- to avoid circular dependencies during database creation.

-- ##################################################
-- #           SCHEMA CREATION (Optional)           #
-- ##################################################

-- RUN IN ecommerce_db - ecommerce_admin
CREATE SCHEMA IF NOT EXISTS ecommerce AUTHORIZATION ecommerce_admin;

COMMENT ON DATABASE ecommerce_db IS 'Base de datos del eCommerce';
COMMENT ON SCHEMA ecommerce IS 'Esquema principal para el eCommerce';

-- ##################################################
-- #                 CATALOG TABLES                 #
-- ##################################################

-- Table: categorias
CREATE TABLE IF NOT EXISTS ecommerce.categoria (
    id_categoria SERIAL PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL
);

-- Table: marca
CREATE TABLE IF NOT EXISTS ecommerce.marca (
    id_marca SERIAL PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL
);

-- Table: tipo_envio
CREATE TABLE IF NOT EXISTS ecommerce.tipo_envio (
    id_tipo_envio SERIAL PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL
);

-- Table: estado_orden
CREATE TABLE IF NOT EXISTS ecommerce.estado_orden (
    id_estado SERIAL PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL
);

-- Table: metodo_pago
CREATE TABLE IF NOT EXISTS ecommerce.metodo_pago (
    id_metodo_pago SERIAL PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL
);

-- ##################################################
-- #                  USER MODULE                   #
-- ##################################################

-- Table: usuario
CREATE TABLE IF NOT EXISTS ecommerce.usuario (
    id_usuario SERIAL PRIMARY KEY,
    nombre VARCHAR(150),
    email VARCHAR(150) NOT NULL UNIQUE,
    password_hash VARCHAR(255) NOT NULL,
    rol VARCHAR(20) DEFAULT 'cliente',
    estado VARCHAR(20) DEFAULT 'ACTIVO'
);

-- Table: direccion
CREATE TABLE IF NOT EXISTS ecommerce.direccion (
    id_direccion SERIAL PRIMARY KEY,
    id_usuario INTEGER NOT NULL,
    direccion VARCHAR(255) NOT NULL,
    ciudad VARCHAR(100) NOT NULL,
    pais VARCHAR(100) NOT NULL
);

-- Table: usuario_metodo_pago
CREATE TABLE IF NOT EXISTS ecommerce.usuario_metodo_pago (
    id_usuario INTEGER NOT NULL,
    id_metodo_pago INTEGER NOT NULL,
    estado VARCHAR(20) DEFAULT 'ACTIVO',
    PRIMARY KEY (id_usuario, id_metodo_pago)
);

-- ##################################################
-- #                PRODUCT MODULE                  #
-- ##################################################

-- Table: producto
CREATE TABLE IF NOT EXISTS ecommerce.producto (
    id_producto SERIAL PRIMARY KEY,
    nombre VARCHAR(200) NOT NULL,
    descripcion TEXT,
    precio DECIMAL(10, 2) NOT NULL,
    stock INTEGER DEFAULT 0,
    sku VARCHAR(50) UNIQUE,
    id_marca INTEGER NOT NULL,
    estado VARCHAR(20) DEFAULT 'DISPONIBLE'
);

-- Table: producto_categoria
CREATE TABLE IF NOT EXISTS ecommerce.producto_categoria (
    id_producto INTEGER NOT NULL,
    id_categoria INTEGER NOT NULL,
    PRIMARY KEY (id_producto, id_categoria)
);

-- Table: imagen
CREATE TABLE IF NOT EXISTS ecommerce.imagen (
    id_imagen SERIAL PRIMARY KEY,
    id_producto INTEGER NOT NULL,
    url VARCHAR(500) NOT NULL
);

-- Table: resena
CREATE TABLE IF NOT EXISTS ecommerce.resena (
    id_resena SERIAL PRIMARY KEY,
    id_usuario INTEGER NOT NULL,
    id_producto INTEGER NOT NULL,
    comentario TEXT,
    puntuacion INTEGER CHECK (puntuacion >= 1 AND puntuacion <= 5)
);

-- ##################################################
-- #                 CART MODULE                    #
-- ##################################################

-- Table: carrito
CREATE TABLE IF NOT EXISTS ecommerce.carrito (
    id_carrito SERIAL PRIMARY KEY,
    id_usuario INTEGER NOT NULL,
    estado VARCHAR(20) DEFAULT 'ABIERTO'
);

-- Table: carrito_item
CREATE TABLE IF NOT EXISTS ecommerce.carrito_item (
    id_carrito_item SERIAL PRIMARY KEY,
    id_carrito INTEGER NOT NULL,
    id_producto INTEGER NOT NULL,
    cantidad INTEGER NOT NULL DEFAULT 1,
    precio_unitario DECIMAL(10, 2) NOT NULL
);

-- ##################################################
-- #                 ORDER MODULE                   #
-- ##################################################

-- Table: orden
CREATE TABLE IF NOT EXISTS ecommerce.orden (
    id_orden SERIAL PRIMARY KEY,
    id_usuario INTEGER NOT NULL,
    id_direccion INTEGER NOT NULL,
    id_metodo_pago INTEGER NOT NULL,
    id_tipo_envio INTEGER NOT NULL,
    id_estado INTEGER NOT NULL,
    total DECIMAL(10, 2) NOT NULL DEFAULT 0.00,
    fecha_orden TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Table: orden_item
CREATE TABLE IF NOT EXISTS ecommerce.orden_item (
    id_orden_item SERIAL PRIMARY KEY,
    id_orden INTEGER NOT NULL,
    id_producto INTEGER NOT NULL,
    cantidad INTEGER NOT NULL DEFAULT 1,
    precio_unitario DECIMAL(10, 2) NOT NULL
);

-- Table: pago
CREATE TABLE IF NOT EXISTS ecommerce.pago (
    id_pago SERIAL PRIMARY KEY,
    id_orden INTEGER NOT NULL,
    monto DECIMAL(10, 2) NOT NULL,
    referencia VARCHAR(150),
    estado VARCHAR(50) NOT NULL,
    fecha TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- ##################################################
-- #                 AUDIT MODULE                   #
-- ##################################################

-- Table: auditoria
CREATE TABLE IF NOT EXISTS ecommerce.auditoria (
    id_auditoria SERIAL PRIMARY KEY,
    id_usuario INTEGER NOT NULL,
    accion VARCHAR(100) NOT NULL,
    entidad VARCHAR(100) NOT NULL,
    timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    detalle TEXT
);
