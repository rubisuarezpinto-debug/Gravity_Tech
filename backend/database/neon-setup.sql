-- ############################################################
-- TECHSTORE — Script de instalación para Neon
-- ############################################################
-- Pega TODO este contenido en el SQL Editor de Neon y ejecuta.
-- El schema 'ecommerce' se crea sin AUTHORIZATION para que
-- funcione con el usuario predeterminado de Neon.
-- ############################################################

-- ── 1. SCHEMA ───────────────────────────────────────────────
CREATE SCHEMA IF NOT EXISTS ecommerce;

SET search_path TO ecommerce, public;

-- ── 2. TABLAS DE CATÁLOGO ────────────────────────────────────

CREATE TABLE IF NOT EXISTS ecommerce.categoria (
    id_categoria SERIAL PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL
);

CREATE TABLE IF NOT EXISTS ecommerce.marca (
    id_marca SERIAL PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL
);

CREATE TABLE IF NOT EXISTS ecommerce.tipo_envio (
    id_tipo_envio SERIAL PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL
);

CREATE TABLE IF NOT EXISTS ecommerce.estado_orden (
    id_estado SERIAL PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL
);

CREATE TABLE IF NOT EXISTS ecommerce.metodo_pago (
    id_metodo_pago SERIAL PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL
);

-- ── 3. MÓDULO USUARIO ────────────────────────────────────────

CREATE TABLE IF NOT EXISTS ecommerce.usuario (
    id_usuario SERIAL PRIMARY KEY,
    nombre VARCHAR(150),
    email VARCHAR(150) NOT NULL UNIQUE,
    password_hash VARCHAR(255) NOT NULL,
    rol VARCHAR(20) DEFAULT 'cliente',
    estado VARCHAR(20) DEFAULT 'ACTIVO',
    fecha_creacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    fecha_actualizacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS ecommerce.direccion (
    id_direccion SERIAL PRIMARY KEY,
    id_usuario INTEGER NOT NULL,
    direccion VARCHAR(255) NOT NULL,
    ciudad VARCHAR(100) NOT NULL,
    pais VARCHAR(100) NOT NULL,
    fecha_creacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS ecommerce.usuario_metodo_pago (
    id_usuario INTEGER NOT NULL,
    id_metodo_pago INTEGER NOT NULL,
    estado VARCHAR(20) DEFAULT 'ACTIVO',
    fecha_creacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (id_usuario, id_metodo_pago)
);

-- ── 4. MÓDULO PRODUCTO ───────────────────────────────────────

CREATE TABLE IF NOT EXISTS ecommerce.producto (
    id_producto SERIAL PRIMARY KEY,
    nombre VARCHAR(200) NOT NULL,
    descripcion TEXT,
    precio DECIMAL(10, 2) NOT NULL,
    stock INTEGER DEFAULT 0,
    sku VARCHAR(50) UNIQUE,
    id_marca INTEGER NOT NULL,
    estado VARCHAR(20) DEFAULT 'DISPONIBLE',
    fecha_creacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    fecha_actualizacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS ecommerce.producto_categoria (
    id_producto INTEGER NOT NULL,
    id_categoria INTEGER NOT NULL,
    PRIMARY KEY (id_producto, id_categoria)
);

CREATE TABLE IF NOT EXISTS ecommerce.imagen (
    id_imagen SERIAL PRIMARY KEY,
    id_producto INTEGER NOT NULL,
    url VARCHAR(500) NOT NULL,
    fecha_creacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS ecommerce.resena (
    id_resena SERIAL PRIMARY KEY,
    id_usuario INTEGER NOT NULL,
    id_producto INTEGER NOT NULL,
    comentario TEXT,
    puntuacion INTEGER CHECK (puntuacion >= 1 AND puntuacion <= 5),
    fecha_creacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- ── 5. MÓDULO CARRITO ────────────────────────────────────────

CREATE TABLE IF NOT EXISTS ecommerce.carrito (
    id_carrito SERIAL PRIMARY KEY,
    id_usuario INTEGER NOT NULL,
    estado VARCHAR(20) DEFAULT 'ABIERTO',
    fecha_creacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    fecha_actualizacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS ecommerce.carrito_item (
    id_carrito_item SERIAL PRIMARY KEY,
    id_carrito INTEGER NOT NULL,
    id_producto INTEGER NOT NULL,
    cantidad INTEGER NOT NULL DEFAULT 1,
    precio_unitario DECIMAL(10, 2) NOT NULL,
    fecha_creacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- ── 6. MÓDULO ÓRDENES ────────────────────────────────────────

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

CREATE TABLE IF NOT EXISTS ecommerce.orden_item (
    id_orden_item SERIAL PRIMARY KEY,
    id_orden INTEGER NOT NULL,
    id_producto INTEGER NOT NULL,
    cantidad INTEGER NOT NULL DEFAULT 1,
    precio_unitario DECIMAL(10, 2) NOT NULL
);

CREATE TABLE IF NOT EXISTS ecommerce.pago (
    id_pago SERIAL PRIMARY KEY,
    id_orden INTEGER NOT NULL,
    monto DECIMAL(10, 2) NOT NULL,
    referencia VARCHAR(150),
    estado VARCHAR(50) NOT NULL,
    fecha TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- ── 7. MÓDULO AUDITORÍA ──────────────────────────────────────

CREATE TABLE IF NOT EXISTS ecommerce.auditoria (
    id_auditoria SERIAL PRIMARY KEY,
    id_usuario INTEGER NOT NULL,
    accion VARCHAR(100) NOT NULL,
    entidad VARCHAR(100) NOT NULL,
    timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    detalle TEXT
);

-- ── 8. FOREIGN KEYS ──────────────────────────────────────────

ALTER TABLE ecommerce.direccion
    ADD CONSTRAINT fk_direccion_usuario FOREIGN KEY (id_usuario) REFERENCES ecommerce.usuario (id_usuario) ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE ecommerce.usuario_metodo_pago
    ADD CONSTRAINT fk_ump_usuario FOREIGN KEY (id_usuario) REFERENCES ecommerce.usuario (id_usuario) ON UPDATE CASCADE ON DELETE CASCADE,
    ADD CONSTRAINT fk_ump_metodopago FOREIGN KEY (id_metodo_pago) REFERENCES ecommerce.metodo_pago (id_metodo_pago) ON UPDATE CASCADE ON DELETE RESTRICT;

ALTER TABLE ecommerce.producto
    ADD CONSTRAINT fk_producto_marca FOREIGN KEY (id_marca) REFERENCES ecommerce.marca (id_marca) ON UPDATE CASCADE ON DELETE RESTRICT;

ALTER TABLE ecommerce.producto_categoria
    ADD CONSTRAINT fk_pc_producto FOREIGN KEY (id_producto) REFERENCES ecommerce.producto (id_producto) ON UPDATE CASCADE ON DELETE CASCADE,
    ADD CONSTRAINT fk_pc_categoria FOREIGN KEY (id_categoria) REFERENCES ecommerce.categoria (id_categoria) ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE ecommerce.imagen
    ADD CONSTRAINT fk_imagen_producto FOREIGN KEY (id_producto) REFERENCES ecommerce.producto (id_producto) ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE ecommerce.resena
    ADD CONSTRAINT fk_resena_usuario FOREIGN KEY (id_usuario) REFERENCES ecommerce.usuario (id_usuario) ON UPDATE CASCADE ON DELETE CASCADE,
    ADD CONSTRAINT fk_resena_producto FOREIGN KEY (id_producto) REFERENCES ecommerce.producto (id_producto) ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE ecommerce.carrito
    ADD CONSTRAINT fk_carrito_usuario FOREIGN KEY (id_usuario) REFERENCES ecommerce.usuario (id_usuario) ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE ecommerce.carrito_item
    ADD CONSTRAINT fk_ci_carrito FOREIGN KEY (id_carrito) REFERENCES ecommerce.carrito (id_carrito) ON UPDATE CASCADE ON DELETE CASCADE,
    ADD CONSTRAINT fk_ci_producto FOREIGN KEY (id_producto) REFERENCES ecommerce.producto (id_producto) ON UPDATE CASCADE ON DELETE RESTRICT;

ALTER TABLE ecommerce.orden
    ADD CONSTRAINT fk_orden_usuario FOREIGN KEY (id_usuario) REFERENCES ecommerce.usuario (id_usuario) ON UPDATE CASCADE ON DELETE CASCADE,
    ADD CONSTRAINT fk_orden_direccion FOREIGN KEY (id_direccion) REFERENCES ecommerce.direccion (id_direccion) ON UPDATE CASCADE ON DELETE RESTRICT,
    ADD CONSTRAINT fk_orden_metodopago FOREIGN KEY (id_metodo_pago) REFERENCES ecommerce.metodo_pago (id_metodo_pago) ON UPDATE CASCADE ON DELETE RESTRICT,
    ADD CONSTRAINT fk_orden_tipoenvio FOREIGN KEY (id_tipo_envio) REFERENCES ecommerce.tipo_envio (id_tipo_envio) ON UPDATE CASCADE ON DELETE RESTRICT,
    ADD CONSTRAINT fk_orden_estado FOREIGN KEY (id_estado) REFERENCES ecommerce.estado_orden (id_estado) ON UPDATE CASCADE ON DELETE RESTRICT;

ALTER TABLE ecommerce.orden_item
    ADD CONSTRAINT fk_oi_orden FOREIGN KEY (id_orden) REFERENCES ecommerce.orden (id_orden) ON UPDATE CASCADE ON DELETE CASCADE,
    ADD CONSTRAINT fk_oi_producto FOREIGN KEY (id_producto) REFERENCES ecommerce.producto (id_producto) ON UPDATE CASCADE ON DELETE RESTRICT;

ALTER TABLE ecommerce.pago
    ADD CONSTRAINT fk_pago_orden FOREIGN KEY (id_orden) REFERENCES ecommerce.orden (id_orden) ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE ecommerce.auditoria
    ADD CONSTRAINT fk_auditoria_usuario FOREIGN KEY (id_usuario) REFERENCES ecommerce.usuario (id_usuario) ON UPDATE CASCADE ON DELETE RESTRICT;

-- ── 9. MIGRACIÓN: constraint UNIQUE en carrito_item ─────────

DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_constraint
    WHERE conname = 'uq_carrito_item_carrito_producto'
  ) THEN
    ALTER TABLE ecommerce.carrito_item
      ADD CONSTRAINT uq_carrito_item_carrito_producto
      UNIQUE (id_carrito, id_producto);
  END IF;
END $$;
