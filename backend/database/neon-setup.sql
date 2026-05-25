-- ############################################################
-- GRAVITY TECH — Schema completo para Neon
-- ############################################################
-- 1. Pega todo en el SQL Editor de Neon y ejecuta.
-- 2. Después ejecuta neon-seed.sql
-- ############################################################

-- ── SCHEMA ──────────────────────────────────────────────────

CREATE SCHEMA IF NOT EXISTS ecommerce;
SET search_path TO ecommerce, public;

-- ── TABLAS DE CATÁLOGO ───────────────────────────────────────

CREATE TABLE ecommerce.categoria (
    id_categoria SERIAL PRIMARY KEY,
    nombre       VARCHAR(100) NOT NULL
);

CREATE TABLE ecommerce.marca (
    id_marca SERIAL PRIMARY KEY,
    nombre   VARCHAR(100) NOT NULL
);

CREATE TABLE ecommerce.tipo_envio (
    id_tipo_envio SERIAL PRIMARY KEY,
    nombre        VARCHAR(100) NOT NULL
);

CREATE TABLE ecommerce.estado_orden (
    id_estado SERIAL PRIMARY KEY,
    nombre    VARCHAR(100) NOT NULL
);

CREATE TABLE ecommerce.metodo_pago (
    id_metodo_pago SERIAL PRIMARY KEY,
    nombre         VARCHAR(100) NOT NULL
);

CREATE TABLE ecommerce.cupon (
    id_cupon              SERIAL PRIMARY KEY,
    codigo                VARCHAR(50)    NOT NULL UNIQUE,
    porcentaje_descuento  NUMERIC(5,2)   NOT NULL,
    activo                BOOLEAN        DEFAULT TRUE,
    fecha_expiracion      DATE,
    CONSTRAINT cupon_porcentaje_check CHECK (porcentaje_descuento > 0 AND porcentaje_descuento <= 100)
);

-- ── MÓDULO USUARIO ───────────────────────────────────────────

CREATE TABLE ecommerce.usuario (
    id_usuario          SERIAL PRIMARY KEY,
    nombre              VARCHAR(150),
    email               VARCHAR(150)   NOT NULL UNIQUE,
    password_hash       VARCHAR(255)   NOT NULL,
    rol                 VARCHAR(20)    DEFAULT 'cliente',
    estado              VARCHAR(20)    DEFAULT 'ACTIVO',
    telefono            VARCHAR(20),
    fecha_creacion      TIMESTAMP      DEFAULT CURRENT_TIMESTAMP,
    fecha_actualizacion TIMESTAMP      DEFAULT CURRENT_TIMESTAMP,
    sms_code            VARCHAR(6),
    sms_expires_at      TIMESTAMP
);

CREATE TABLE ecommerce.direccion (
    id_direccion   SERIAL PRIMARY KEY,
    id_usuario     INTEGER        NOT NULL,
    direccion      VARCHAR(255)   NOT NULL,
    ciudad         VARCHAR(100)   NOT NULL,
    pais           VARCHAR(100)   NOT NULL,
    latitud        NUMERIC(10,8),
    longitud       NUMERIC(11,8),
    fecha_creacion TIMESTAMP      DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE ecommerce.usuario_metodo_pago (
    id_usuario     INTEGER        NOT NULL,
    id_metodo_pago INTEGER        NOT NULL,
    estado         VARCHAR(20)    DEFAULT 'ACTIVO',
    fecha_creacion TIMESTAMP      DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (id_usuario, id_metodo_pago)
);

-- ── MÓDULO PRODUCTO ──────────────────────────────────────────

CREATE TABLE ecommerce.producto (
    id_producto         SERIAL PRIMARY KEY,
    nombre              VARCHAR(200)   NOT NULL,
    descripcion         TEXT,
    precio              NUMERIC(10,2)  NOT NULL,
    stock               INTEGER        DEFAULT 0,
    sku                 VARCHAR(50)    UNIQUE,
    id_marca            INTEGER        NOT NULL,
    estado              VARCHAR(20)    DEFAULT 'DISPONIBLE',
    fecha_creacion      TIMESTAMP      DEFAULT CURRENT_TIMESTAMP,
    fecha_actualizacion TIMESTAMP      DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT producto_precio_check CHECK (precio >= 0),
    CONSTRAINT producto_stock_check  CHECK (stock >= 0)
);

CREATE TABLE ecommerce.producto_categoria (
    id_producto  INTEGER NOT NULL,
    id_categoria INTEGER NOT NULL,
    PRIMARY KEY (id_producto, id_categoria)
);

CREATE TABLE ecommerce.imagen (
    id_imagen      SERIAL PRIMARY KEY,
    id_producto    INTEGER        NOT NULL,
    url            VARCHAR(500)   NOT NULL,
    es_principal   BOOLEAN        DEFAULT FALSE,
    fecha_creacion TIMESTAMP      DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE ecommerce.resena (
    id_resena      SERIAL PRIMARY KEY,
    id_usuario     INTEGER        NOT NULL,
    id_producto    INTEGER        NOT NULL,
    comentario     TEXT,
    puntuacion     INTEGER,
    fecha_creacion TIMESTAMP      DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT resena_puntuacion_check CHECK (puntuacion >= 1 AND puntuacion <= 5)
);

CREATE TABLE ecommerce.favorito (
    id_favorito    SERIAL PRIMARY KEY,
    id_usuario     INTEGER   NOT NULL,
    id_producto    INTEGER   NOT NULL,
    fecha_agregado TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE (id_usuario, id_producto)
);

-- ── MÓDULO CARRITO ───────────────────────────────────────────

CREATE TABLE ecommerce.carrito (
    id_carrito          SERIAL PRIMARY KEY,
    id_usuario          INTEGER        NOT NULL,
    estado              VARCHAR(20)    DEFAULT 'ABIERTO',
    fecha_creacion      TIMESTAMP      DEFAULT CURRENT_TIMESTAMP,
    fecha_actualizacion TIMESTAMP      DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE ecommerce.carrito_item (
    id_carrito_item SERIAL PRIMARY KEY,
    id_carrito      INTEGER        NOT NULL,
    id_producto     INTEGER        NOT NULL,
    cantidad        INTEGER        NOT NULL DEFAULT 1,
    precio_unitario NUMERIC(10,2)  NOT NULL,
    fecha_creacion  TIMESTAMP      DEFAULT CURRENT_TIMESTAMP,
    UNIQUE (id_carrito, id_producto)
);

-- ── MÓDULO ÓRDENES ───────────────────────────────────────────

CREATE TABLE ecommerce.orden (
    id_orden       SERIAL PRIMARY KEY,
    id_usuario     INTEGER        NOT NULL,
    id_direccion   INTEGER        NOT NULL,
    id_metodo_pago INTEGER        NOT NULL,
    id_tipo_envio  INTEGER        NOT NULL,
    id_estado      INTEGER        NOT NULL,
    total          NUMERIC(10,2)  NOT NULL DEFAULT 0.00,
    fecha_orden    TIMESTAMP      DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE ecommerce.orden_item (
    id_orden_item   SERIAL PRIMARY KEY,
    id_orden        INTEGER        NOT NULL,
    id_producto     INTEGER        NOT NULL,
    cantidad        INTEGER        NOT NULL DEFAULT 1,
    precio_unitario NUMERIC(10,2)  NOT NULL
);

CREATE TABLE ecommerce.pago (
    id_pago    SERIAL PRIMARY KEY,
    id_orden   INTEGER        NOT NULL,
    monto      NUMERIC(10,2)  NOT NULL,
    referencia VARCHAR(150),
    estado     VARCHAR(50)    NOT NULL,
    fecha      TIMESTAMP      DEFAULT CURRENT_TIMESTAMP
);

-- ── MÓDULO AUDITORÍA ─────────────────────────────────────────

CREATE TABLE ecommerce.auditoria (
    id_auditoria SERIAL PRIMARY KEY,
    id_usuario   INTEGER        NOT NULL,
    accion       VARCHAR(100)   NOT NULL,
    entidad      VARCHAR(100)   NOT NULL,
    timestamp    TIMESTAMP      DEFAULT CURRENT_TIMESTAMP,
    detalle      TEXT
);

-- ── FOREIGN KEYS ─────────────────────────────────────────────

ALTER TABLE ecommerce.direccion
    ADD CONSTRAINT fk_direccion_usuario
        FOREIGN KEY (id_usuario) REFERENCES ecommerce.usuario(id_usuario)
        ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE ecommerce.usuario_metodo_pago
    ADD CONSTRAINT fk_ump_usuario
        FOREIGN KEY (id_usuario) REFERENCES ecommerce.usuario(id_usuario)
        ON UPDATE CASCADE ON DELETE CASCADE,
    ADD CONSTRAINT fk_ump_metodopago
        FOREIGN KEY (id_metodo_pago) REFERENCES ecommerce.metodo_pago(id_metodo_pago)
        ON UPDATE CASCADE ON DELETE RESTRICT;

ALTER TABLE ecommerce.producto
    ADD CONSTRAINT fk_producto_marca
        FOREIGN KEY (id_marca) REFERENCES ecommerce.marca(id_marca)
        ON UPDATE CASCADE ON DELETE RESTRICT;

ALTER TABLE ecommerce.producto_categoria
    ADD CONSTRAINT fk_pc_producto
        FOREIGN KEY (id_producto) REFERENCES ecommerce.producto(id_producto)
        ON UPDATE CASCADE ON DELETE CASCADE,
    ADD CONSTRAINT fk_pc_categoria
        FOREIGN KEY (id_categoria) REFERENCES ecommerce.categoria(id_categoria)
        ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE ecommerce.imagen
    ADD CONSTRAINT fk_imagen_producto
        FOREIGN KEY (id_producto) REFERENCES ecommerce.producto(id_producto)
        ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE ecommerce.resena
    ADD CONSTRAINT fk_resena_usuario
        FOREIGN KEY (id_usuario) REFERENCES ecommerce.usuario(id_usuario)
        ON UPDATE CASCADE ON DELETE CASCADE,
    ADD CONSTRAINT fk_resena_producto
        FOREIGN KEY (id_producto) REFERENCES ecommerce.producto(id_producto)
        ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE ecommerce.favorito
    ADD CONSTRAINT fk_favorito_usuario
        FOREIGN KEY (id_usuario) REFERENCES ecommerce.usuario(id_usuario)
        ON UPDATE CASCADE ON DELETE CASCADE,
    ADD CONSTRAINT fk_favorito_producto
        FOREIGN KEY (id_producto) REFERENCES ecommerce.producto(id_producto)
        ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE ecommerce.carrito
    ADD CONSTRAINT fk_carrito_usuario
        FOREIGN KEY (id_usuario) REFERENCES ecommerce.usuario(id_usuario)
        ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE ecommerce.carrito_item
    ADD CONSTRAINT fk_ci_carrito
        FOREIGN KEY (id_carrito) REFERENCES ecommerce.carrito(id_carrito)
        ON UPDATE CASCADE ON DELETE CASCADE,
    ADD CONSTRAINT fk_ci_producto
        FOREIGN KEY (id_producto) REFERENCES ecommerce.producto(id_producto)
        ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE ecommerce.orden
    ADD CONSTRAINT fk_orden_usuario
        FOREIGN KEY (id_usuario) REFERENCES ecommerce.usuario(id_usuario)
        ON UPDATE CASCADE ON DELETE CASCADE,
    ADD CONSTRAINT fk_orden_direccion
        FOREIGN KEY (id_direccion) REFERENCES ecommerce.direccion(id_direccion)
        ON UPDATE CASCADE ON DELETE RESTRICT,
    ADD CONSTRAINT fk_orden_metodopago
        FOREIGN KEY (id_metodo_pago) REFERENCES ecommerce.metodo_pago(id_metodo_pago)
        ON UPDATE CASCADE ON DELETE RESTRICT,
    ADD CONSTRAINT fk_orden_tipoenvio
        FOREIGN KEY (id_tipo_envio) REFERENCES ecommerce.tipo_envio(id_tipo_envio)
        ON UPDATE CASCADE ON DELETE RESTRICT,
    ADD CONSTRAINT fk_orden_estado
        FOREIGN KEY (id_estado) REFERENCES ecommerce.estado_orden(id_estado)
        ON UPDATE CASCADE ON DELETE RESTRICT;

ALTER TABLE ecommerce.orden_item
    ADD CONSTRAINT fk_oi_orden
        FOREIGN KEY (id_orden) REFERENCES ecommerce.orden(id_orden)
        ON UPDATE CASCADE ON DELETE CASCADE,
    ADD CONSTRAINT fk_oi_producto
        FOREIGN KEY (id_producto) REFERENCES ecommerce.producto(id_producto)
        ON UPDATE CASCADE ON DELETE RESTRICT;

ALTER TABLE ecommerce.pago
    ADD CONSTRAINT fk_pago_orden
        FOREIGN KEY (id_orden) REFERENCES ecommerce.orden(id_orden)
        ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE ecommerce.auditoria
    ADD CONSTRAINT fk_auditoria_usuario
        FOREIGN KEY (id_usuario) REFERENCES ecommerce.usuario(id_usuario)
        ON UPDATE CASCADE ON DELETE SET NULL;
