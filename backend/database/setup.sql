-- ============================================================
--  GRAVITY TECH — Setup completo de la base de datos
--  Ejecutar en pgAdmin o psql como superusuario (postgres)
--
--  pgAdmin:  File > Open > selecciona este archivo > F5
--  psql:     psql -U postgres -f setup.sql
-- ============================================================

-- ── 1. Usuario y base de datos ────────────────────────────
DO $$
BEGIN
  IF NOT EXISTS (SELECT FROM pg_roles WHERE rolname = 'ecommerce_admin') THEN
    CREATE USER ecommerce_admin WITH PASSWORD 'gravity_pass';
  ELSE
    ALTER USER ecommerce_admin WITH PASSWORD 'gravity_pass';
  END IF;
END $$;

DROP DATABASE IF EXISTS ecommerce_db;

CREATE DATABASE ecommerce_db
  WITH ENCODING  = 'UTF8'
       TEMPLATE  = template0
       OWNER     = ecommerce_admin;

GRANT ALL PRIVILEGES ON DATABASE ecommerce_db TO ecommerce_admin;

-- ── 2. Conectar a la nueva base de datos ──────────────────
\connect ecommerce_db

-- ── 3. Esquema ────────────────────────────────────────────
CREATE SCHEMA IF NOT EXISTS ecommerce AUTHORIZATION ecommerce_admin;

-- ── 4. Tablas de catálogo ─────────────────────────────────
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

-- ── 5. Tablas de usuarios ─────────────────────────────────
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

-- ── 6. Tablas de productos ────────────────────────────────
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
    id_producto INTEGER NOT NULL UNIQUE,
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

-- ── 7. Tablas de carrito ──────────────────────────────────
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

-- ── 8. Tablas de órdenes ──────────────────────────────────
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

-- ── 9. Auditoría ──────────────────────────────────────────
CREATE TABLE IF NOT EXISTS ecommerce.auditoria (
    id_auditoria SERIAL PRIMARY KEY,
    id_usuario INTEGER NOT NULL,
    accion VARCHAR(100) NOT NULL,
    entidad VARCHAR(100) NOT NULL,
    timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    detalle TEXT
);

-- ── 10. Llaves foráneas ───────────────────────────────────
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

-- ── 11. Constraint único carrito_item ────────────────────
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_constraint WHERE conname = 'uq_carrito_item_carrito_producto'
  ) THEN
    ALTER TABLE ecommerce.carrito_item
      ADD CONSTRAINT uq_carrito_item_carrito_producto UNIQUE (id_carrito, id_producto);
  END IF;
END $$;

-- ── 12. Datos de catálogo ─────────────────────────────────
INSERT INTO ecommerce.categoria (nombre) VALUES
('Tecnología'), ('Calzado'), ('Ropa'), ('Deportes'), ('Hogar'), ('Accesorios'), ('Libros');

INSERT INTO ecommerce.marca (nombre) VALUES
('Sony'), ('Nike'), ('Samsung'), ('Apple'), ('Adidas'), ('Logitech'), ('Xiaomi'), ('LG');

INSERT INTO ecommerce.tipo_envio (nombre) VALUES
('Estándar (3-5 días)'), ('Express (24h)'), ('Recogida en Punto Físico');

INSERT INTO ecommerce.estado_orden (nombre) VALUES
('Pendiente'), ('Pago Confirmado'), ('En Proceso'), ('Enviado'), ('Entregado');

INSERT INTO ecommerce.metodo_pago (nombre) VALUES
('Tarjeta de Crédito'), ('Transferencia Bancaria'), ('PayPal'), ('Efectivo');

-- ── 13. Usuarios de prueba ────────────────────────────────
-- Hashes bcrypt cost=12. Para regenerarlos con tu propia contraseña:
--   node -e "const b=require('bcryptjs'); b.hash('TuPass123',12).then(console.log)"
INSERT INTO ecommerce.usuario (nombre, email, password_hash, rol) VALUES
  ('Admin Store',     'admin@gravitytech.com',   '$2b$12$/8LQP4qDk6d0Dx4P8PNXFu5ZVH0gpyhcPw.5O5.rycv3p7HFc1Vk2', 'administrador'),
  ('Cliente Demo',    'cliente@gravitytech.com', '$2b$12$SQFzC/nt0p3zzYt4jREeKuiCV.kbHuv8S6vcDQSmTj93hsWivzYIO', 'cliente'),
  ('Trabajador Demo', 'worker@gravitytech.com',  '$2b$12$5hcrdMSdnclLSo6RM1K1Q.7gspSJvcQE0AlmibV3GMdO0DG3H7UDu', 'trabajador')
ON CONFLICT (email) DO NOTHING;

INSERT INTO ecommerce.direccion (id_usuario, direccion, ciudad, pais) VALUES
(1, 'Calle 100 #15-20', 'Bogotá', 'Colombia'),
(2, 'Carrera 80 #45-10', 'Medellín', 'Colombia'),
(3, 'Av. Paseo de la Reforma 222', 'CDMX', 'México');

INSERT INTO ecommerce.usuario_metodo_pago (id_usuario, id_metodo_pago) VALUES
(2, 1), (3, 2);

-- ── 14. Productos ─────────────────────────────────────────
INSERT INTO ecommerce.producto (nombre, descripcion, precio, stock, sku, id_marca) VALUES
('PlayStation 5 Slim',         'Consola con lector de discos 1TB',       499.99,  15, 'GA-PS5-SLIM',  1),
('iPhone 15 Pro Max',          'Titanio Natural 256GB',                  1199.00, 10, 'AP-IP15PM',    4),
('Zapatillas Air Max 90',      'Clásico diseño urbano',                   130.00, 45, 'NK-AM90-W',    2),
('Monitor Samsung Odyssey G9', '49 pulgadas Ultra Wide',                 1299.99,  5, 'SA-OD-G9',     3),
('Mouse MX Master 3S',         'Ergonómico para productividad',            99.00, 30, 'LO-MX3S',      6),
('Camiseta Real Madrid 2024',  'Equipación oficial local',                 95.00,100, 'AD-RM24-H',    5),
('Xiaomi 14 Ultra',            'Cámara Leica 512GB',                      999.00, 12, 'XI-14U-BK',    7),
('Audífonos Sony WH-1000XM5',  'Cancelación de ruido líder',              349.00, 20, 'SO-XM5-SL',    1),
('Balón Adidas Al Rihla',      'Balón oficial FIFA',                       40.00, 60, 'AD-BAL-FIFA',  5),
('Teclado Logitech G915',      'Mecánico inalámbrico RGB',                229.00, 18, 'LO-G915-BR',   6),
('MacBook Air M3',             '13 pulgadas, 8GB RAM',                   1099.00,  8, 'AP-MBA-M3',    4),
('Samsung Galaxy S24 Ultra',   'Pantalla plana 120Hz',                   1299.00, 15, 'SA-S24-ULT',   3),
('Nike Tech Fleece',           'Sudadera con capucha negra',              110.00, 40, 'NK-TF-HD',     2),
('Apple Watch Ultra 2',        'GPS + Celular 49mm',                      799.00, 25, 'AP-AW-U2',     4),
('LG C3 OLED TV',              '55 pulgadas 4K Smart TV',                1499.00,  7, 'LG-C3-55',     8),
('Cámara Sony A7 IV',          'Mirrorless Full Frame',                  2499.00,  4, 'SO-A7IV-B',    1),
('Xiaomi Pad 6',               'Tablet 144Hz 256GB',                      399.00, 20, 'XI-PAD6-GR',   7),
('Barra de Sonido Sony A5000', '5.1.2 canales Dolby Atmos',              799.00, 10, 'SO-HT-A5000',  1),
('Zapatillas Nike Dunk Low',   'Panda colorway blanco y negro',           115.00, 50, 'NK-DUNK-PND',  2),
('SSD Samsung 990 Pro 2TB',    'NVMe Gen4 ultra rápido',                  180.00,100, 'SA-990P-2TB',  3);

INSERT INTO ecommerce.producto_categoria (id_producto, id_categoria) VALUES
(1,1),(2,1),(3,2),(4,1),(5,1),(6,3),(7,1),(8,1),(9,4),(10,1),
(11,1),(12,1),(13,3),(14,1),(15,1),(16,1),(17,1),(18,1),(19,2),(20,1);

INSERT INTO ecommerce.imagen (id_producto, url) VALUES
(1,  'https://images.unsplash.com/photo-1606144042614-b2417e99c4e3'),
(2,  'https://images.unsplash.com/photo-1696446701796-da61225697cc'),
(3,  'https://images.unsplash.com/photo-1542291026-7eec264c27ff'),
(4,  'https://images.unsplash.com/photo-1527443224154-c4a3942d3acf'),
(5,  'https://images.unsplash.com/photo-1615663245857-ac93bb7c39e7'),
(8,  'https://images.unsplash.com/photo-1505740420928-5e560c06d30e'),
(11, 'https://images.unsplash.com/photo-1517336714460-45732238469d'),
(15, 'https://images.unsplash.com/photo-1593359677879-a4bb92f829d1'),
(20, 'https://images.unsplash.com/photo-1591488320449-011701bb6704');

-- ── 15. Datos de prueba (carritos, órdenes, pagos) ───────
INSERT INTO ecommerce.carrito (id_usuario) VALUES (2), (3);

INSERT INTO ecommerce.carrito_item (id_carrito, id_producto, cantidad, precio_unitario) VALUES
(1, 1, 1, 499.99),
(1, 5, 2,  99.00),
(2, 2, 1, 1199.00);

INSERT INTO ecommerce.orden (id_usuario, id_direccion, id_metodo_pago, id_tipo_envio, id_estado, total) VALUES
(2, 2, 1, 1, 4, 499.99),
(3, 3, 2, 2, 2, 1199.00);

INSERT INTO ecommerce.orden_item (id_orden, id_producto, cantidad, precio_unitario) VALUES
(1, 1, 1, 499.99),
(2, 2, 1, 1199.00);

INSERT INTO ecommerce.pago (id_orden, monto, referencia, estado) VALUES
(1, 499.99,  'REF-001-XYZ', 'APROBADO'),
(2, 1199.00, 'REF-002-ABC', 'PENDIENTE');

INSERT INTO ecommerce.resena (id_usuario, id_producto, comentario, puntuacion) VALUES
(2, 1, 'Increíble consola, llegó muy rápido', 5),
(3, 2, 'El teléfono es genial pero muy caro',  4);

INSERT INTO ecommerce.auditoria (id_usuario, accion, entidad, detalle) VALUES
(1, 'INICIO',  'SISTEMA',   'Pipeline de datos ejecutado con éxito'),
(2, 'LOGIN',   'USUARIO',   'Cliente Demo entró al sistema'),
(3, 'UPDATE',  'PRODUCTO',  'Se actualizó stock de iPhone 15 Pro Max'),
(1, 'CREATE',  'CATEGORIA', 'Nueva categoría Accesorios añadida');

-- ── Permisos finales ──────────────────────────────────────
GRANT ALL ON SCHEMA ecommerce TO ecommerce_admin;
GRANT ALL ON ALL TABLES IN SCHEMA ecommerce TO ecommerce_admin;
GRANT ALL ON ALL SEQUENCES IN SCHEMA ecommerce TO ecommerce_admin;

-- ============================================================
--  Listo. Base de datos creada con:
--    Usuario DB:  ecommerce_admin / gravity_pass
--    DB:          ecommerce_db
--    Cuentas de prueba:
--      admin@gravitytech.com    rol: admin
--      cliente@gravitytech.com  rol: cliente
--      worker@gravitytech.com   rol: trabajador
--    (contraseñas según los hashes en seed/Bulk-Load/06-INSERT-USUARIOS.sql)
-- ============================================================
