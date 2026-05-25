-- ############################################################
-- GRAVITY TECH — Seed de datos para Neon
-- ############################################################
-- Ejecutar DESPUÉS de neon-setup.sql
-- ############################################################

-- ── 1. CATÁLOGOS ────────────────────────────────────────────

INSERT INTO ecommerce.categoria (id_categoria, nombre) VALUES
  (1, 'Tecnología'),
  (2, 'Calzado'),
  (3, 'Ropa'),
  (4, 'Deportes'),
  (5, 'Hogar'),
  (6, 'Accesorios'),
  (7, 'Libros');

INSERT INTO ecommerce.marca (id_marca, nombre) VALUES
  (1, 'Sony'),
  (2, 'Nike'),
  (3, 'Samsung'),
  (4, 'Apple'),
  (5, 'Adidas'),
  (6, 'Logitech'),
  (7, 'Xiaomi'),
  (8, 'LG');

INSERT INTO ecommerce.tipo_envio (id_tipo_envio, nombre) VALUES
  (1, 'Estándar (3-5 días)'),
  (2, 'Express (24h)'),
  (3, 'Recogida en Punto Físico');

INSERT INTO ecommerce.estado_orden (id_estado, nombre) VALUES
  (1, 'Pendiente'),
  (2, 'Pago Confirmado'),
  (3, 'En Proceso'),
  (4, 'Enviado'),
  (5, 'Entregado');

INSERT INTO ecommerce.metodo_pago (id_metodo_pago, nombre) VALUES
  (1, 'Tarjeta de Crédito'),
  (2, 'Transferencia Bancaria'),
  (3, 'PayPal'),
  (4, 'Efectivo');

INSERT INTO ecommerce.cupon (id_cupon, codigo, porcentaje_descuento, activo, fecha_expiracion) VALUES
  (1, 'BIENVENIDA20',     20.00, TRUE,  '2026-12-31'),
  (2, 'GRAVITY10',        10.00, TRUE,  '2026-06-30'),
  (3, 'DESCUENTONAVIDAD', 50.00, FALSE, '2025-12-25');

-- ── 2. USUARIOS ──────────────────────────────────────────────
-- Contraseñas de prueba (bcrypt cost 12). Para cambiarlas:
--   node -e "const b=require('bcryptjs'); b.hash('TuClave123!',12).then(console.log)"
--
-- Cuentas listas para usar:
--   admin:    rubi@gravitytech.com       / GravityAdmin2026!
--   empleado: rubisuarezpinto@gmail.com  / GravityWorker2026!
--   cliente:  juan.perez@gmail.com       / GravityClient2026!

INSERT INTO ecommerce.usuario (id_usuario, nombre, email, password_hash, rol, estado, telefono) VALUES
  (1, 'Rubi Suarez',     'rubi@gravitytech.com',          '$2b$12$LFi69S/YFbxwLKfsCPaNIeEwmemeqKEACr0sxF1nJleHAqaYgxxf6', 'admin',    'ACTIVO',   '+573001234567'),
  (2, 'Juan Perez',      'juan.perez@gmail.com',          '$2b$12$SQFzC/nt0p3zzYt4jREeKuiCV.kbHuv8S6vcDQSmTj93hsWivzYIO', 'cliente',  'ACTIVO',   '+573101112222'),
  (3, 'Maria Casas',     'maria.casas@outlook.com',       '$2b$12$5hcrdMSdnclLSo6RM1K1Q.7gspSJvcQE0AlmibV3GMdO0DG3H7UDu', 'cliente',  'ACTIVO',   '+573203334444'),
  (4, 'Roberto Guia',    'roberto.guia@yahoo.com',        '$2b$12$/8LQP4qDk6d0Dx4P8PNXFu5ZVH0gpyhcPw.5O5.rycv3p7HFc1Vk2', 'cliente',  'ACTIVO',   '+573155556666'),
  (5, 'Elena Vargas',    'elena.vargas@mail.com',         '$2b$12$6SNLu4lj01rl7psJ2kV3h.PXTbnwhBZEIHH0aILiuFshs.zIauEWq', 'cliente',  'ACTIVO',   '+573127778888'),
  (6, 'Soporte Tecnico', 'soporte@gravitytech.com',       '$2b$12$iyfs5pKT0ie4yduJ6P82NuibYd3rQra.5jsejoGwEp94pV1avsQXO', 'empleado', 'ACTIVO',   '+573009990000'),
  (7, 'Rubi',            'rubisuarezpinto@gmail.com',     '$2b$12$LFi69S/YFbxwLKfsCPaNIeEwmemeqKEACr0sxF1nJleHAqaYgxxf6', 'empleado', 'ACTIVO',   '3123598797');

-- Ajustar secuencia al máximo id insertado
SELECT setval('ecommerce.usuario_id_usuario_seq', 7);

-- ── 3. DIRECCIONES ───────────────────────────────────────────

INSERT INTO ecommerce.direccion (id_direccion, id_usuario, direccion, ciudad, pais) VALUES
  (1, 2, 'Calle 100 #15-20',            'Bogotá',       'Colombia'),
  (2, 3, 'Carrera 80 #45-10',           'Medellín',     'Colombia'),
  (3, 4, 'Av. Paseo de la Reforma 222', 'CDMX',         'México'),
  (4, 5, 'Calle Florida 500',           'Buenos Aires', 'Argentina'),
  (5, 6, 'Av. Larco 123',              'Lima',          'Perú');

SELECT setval('ecommerce.direccion_id_direccion_seq', 5);

-- ── 4. MÉTODOS DE PAGO POR USUARIO ──────────────────────────

INSERT INTO ecommerce.usuario_metodo_pago (id_usuario, id_metodo_pago) VALUES
  (2, 1),
  (3, 2),
  (4, 3);

-- ── 5. PRODUCTOS ─────────────────────────────────────────────

INSERT INTO ecommerce.producto (id_producto, nombre, descripcion, precio, stock, sku, id_marca) VALUES
  (1,  'PlayStation 5 Slim',         'Consola con lector de discos 1TB',       499.99,  15, 'GA-PS5-SLIM',   1),
  (2,  'iPhone 15 Pro Max',          'Titanio Natural 256GB',                 1199.00,  10, 'AP-IP15PM',     4),
  (3,  'Zapatillas Air Max 90',      'Clásico diseño urbano',                  130.00,  45, 'NK-AM90-W',     2),
  (4,  'Monitor Samsung Odyssey G9', '49 pulgadas Ultra Wide',                1299.99,   5, 'SA-OD-G9',      3),
  (5,  'Mouse MX Master 3S',         'Ergonómico para productividad',           99.00,  30, 'LO-MX3S',       6),
  (6,  'Camiseta Real Madrid 2024',  'Equipación oficial local',                95.00, 100, 'AD-RM24-H',     5),
  (7,  'Xiaomi 14 Ultra',            'Cámara Leica 512GB',                     999.00,  12, 'XI-14U-BK',     7),
  (8,  'Audífonos Sony WH-1000XM5',  'Cancelación de ruido líder',             349.00,  20, 'SO-XM5-SL',     1),
  (9,  'Balón Adidas Al Rihla',      'Balón oficial FIFA',                      40.00,  60, 'AD-BAL-FIFA',   5),
  (10, 'Teclado Logitech G915',      'Mecánico inalámbrico RGB',               229.00,  18, 'LO-G915-BR',    6),
  (11, 'MacBook Air M3',             '13 pulgadas, 8GB RAM',                  1099.00,   8, 'AP-MBA-M3',     4),
  (12, 'Samsung Galaxy S24 Ultra',   'Pantalla plana 120Hz',                  1299.00,  15, 'SA-S24-ULT',    3),
  (13, 'Nike Tech Fleece',           'Sudadera con capucha negra',             110.00,  40, 'NK-TF-HD',      2),
  (14, 'Apple Watch Ultra 2',        'GPS + Celular 49mm',                     799.00,  25, 'AP-AW-U2',      4),
  (15, 'LG C3 OLED TV',              '55 pulgadas 4K Smart TV',               1499.00,   7, 'LG-C3-55',      8),
  (16, 'Cámara Sony A7 IV',          'Mirrorless Full Frame',                 2499.00,   4, 'SO-A7IV-B',     1),
  (17, 'Xiaomi Pad 6',               'Tablet 144Hz 256GB',                     399.00,  20, 'XI-PAD6-GR',    7),
  (18, 'Barra de Sonido Sony A5000', '5.1.2 canales Dolby Atmos',              799.00,  10, 'SO-HT-A5000',   1),
  (19, 'Zapatillas Nike Dunk Low',   'Panda colorway blanco y negro',          115.00,  50, 'NK-DUNK-PND',   2),
  (20, 'SSD Samsung 990 Pro 2TB',    'NVMe Gen4 ultra rápido',                 180.00, 100, 'SA-990P-2TB',   3);

SELECT setval('ecommerce.producto_id_producto_seq', 21);

-- ── 6. CATEGORÍAS POR PRODUCTO ───────────────────────────────

INSERT INTO ecommerce.producto_categoria (id_producto, id_categoria) VALUES
  (1,1),(2,1),(3,2),(4,1),(5,1),(6,3),(7,1),(8,1),(9,4),(10,1),
  (11,1),(12,1),(13,3),(14,1),(15,1),(16,1),(17,1),(18,1),(19,2),(20,1);

-- ── 7. IMÁGENES (es_principal = TRUE) ───────────────────────

INSERT INTO ecommerce.imagen (id_imagen, id_producto, url, es_principal) VALUES
  (1,  1,  'https://images.unsplash.com/photo-1606144042614-b2417e99c4e3', TRUE),
  (2,  2,  'https://images.unsplash.com/photo-1696446701796-da61225697cc', TRUE),
  (3,  3,  'https://images.unsplash.com/photo-1542291026-7eec264c27ff',    TRUE),
  (4,  4,  'https://images.unsplash.com/photo-1527443224154-c4a3942d3acf', TRUE),
  (5,  5,  'https://images.unsplash.com/photo-1615663245857-ac93bb7c39e7', TRUE),
  (6,  8,  'https://images.unsplash.com/photo-1505740420928-5e560c06d30e', TRUE),
  (7,  11, 'https://images.unsplash.com/photo-1517336714460-45732238469d', TRUE),
  (8,  15, 'https://images.unsplash.com/photo-1593359677879-a4bb92f829d1', TRUE),
  (9,  20, 'https://images.unsplash.com/photo-1591488320449-011701bb6704', TRUE),
  (10, 13, 'https://images.unsplash.com/photo-1518791841217-8f162f1e1131', TRUE),
  (11, 14, 'https://images.unsplash.com/photo-1558981403-c5f9899a28bc',    TRUE),
  (12, 16, 'https://images.unsplash.com/photo-1516035069371-29a1b244cc32', TRUE),
  (13, 17, 'https://images.unsplash.com/photo-1589739900297-a554c9870747', TRUE),
  (14, 18, 'https://images.unsplash.com/photo-1545454675-8841c8d515f4',    TRUE),
  (15, 19, 'https://images.unsplash.com/photo-1542291026-7eec264c27ff',    TRUE);

SELECT setval('ecommerce.imagen_id_imagen_seq', 16);

-- ── 8. FAVORITOS ─────────────────────────────────────────────

INSERT INTO ecommerce.favorito (id_favorito, id_usuario, id_producto) VALUES
  (1, 1, 1),
  (2, 1, 2);

SELECT setval('ecommerce.favorito_id_favorito_seq', 2);

-- ── 9. CARRITOS ──────────────────────────────────────────────

INSERT INTO ecommerce.carrito (id_carrito, id_usuario) VALUES
  (1, 2),
  (2, 3),
  (3, 4);

SELECT setval('ecommerce.carrito_id_carrito_seq', 3);

INSERT INTO ecommerce.carrito_item (id_carrito_item, id_carrito, id_producto, cantidad, precio_unitario) VALUES
  (1, 1, 1, 1,  499.99),
  (2, 1, 5, 2,   99.00),
  (3, 2, 2, 1, 1199.00);

SELECT setval('ecommerce.carrito_item_id_carrito_item_seq', 3);

-- ── 10. ÓRDENES ──────────────────────────────────────────────

INSERT INTO ecommerce.orden (id_orden, id_usuario, id_direccion, id_metodo_pago, id_tipo_envio, id_estado, total) VALUES
  (1, 2, 1, 1, 1, 4,  499.99),
  (2, 3, 2, 2, 2, 2, 1199.00);

SELECT setval('ecommerce.orden_id_orden_seq', 2);

INSERT INTO ecommerce.orden_item (id_orden_item, id_orden, id_producto, cantidad, precio_unitario) VALUES
  (1, 1, 1, 1,  499.99),
  (2, 2, 2, 1, 1199.00);

SELECT setval('ecommerce.orden_item_id_orden_item_seq', 2);

-- ── 11. PAGOS ────────────────────────────────────────────────

INSERT INTO ecommerce.pago (id_pago, id_orden, monto, referencia, estado) VALUES
  (1, 1,  499.99, 'REF-001-XYZ', 'APROBADO'),
  (2, 2, 1199.00, 'REF-002-ABC', 'PENDIENTE');

SELECT setval('ecommerce.pago_id_pago_seq', 2);

-- ── 12. RESEÑAS ──────────────────────────────────────────────

INSERT INTO ecommerce.resena (id_resena, id_usuario, id_producto, comentario, puntuacion) VALUES
  (1, 2, 1, 'Increíble consola, llegó muy rápido', 5),
  (2, 3, 2, 'El teléfono es genial pero muy caro',  4);

SELECT setval('ecommerce.resena_id_resena_seq', 2);

-- ── 13. AUDITORÍA INICIAL ────────────────────────────────────

INSERT INTO ecommerce.auditoria (id_auditoria, id_usuario, accion, entidad, detalle) VALUES
  (1, 1, 'INICIO', 'SISTEMA',   'Pipeline de datos ejecutado con éxito'),
  (2, 2, 'LOGIN',  'USUARIO',   'Juan Pérez entró desde Windows 11'),
  (3, 3, 'UPDATE', 'PRODUCTO',  'Se actualizó stock de iPhone 15 Pro Max'),
  (4, 1, 'CREATE', 'CATEGORIA', 'Nueva categoría Accesorios añadida'),
  (5, 6, 'LOGOUT', 'USUARIO',   'Sesión cerrada correctamente');

SELECT setval('ecommerce.auditoria_id_auditoria_seq', 5);

-- ── 14. AJUSTAR SECUENCIAS DE CATÁLOGOS ─────────────────────

SELECT setval('ecommerce.categoria_id_categoria_seq',    7);
SELECT setval('ecommerce.marca_id_marca_seq',            8);
SELECT setval('ecommerce.tipo_envio_id_tipo_envio_seq',  3);
SELECT setval('ecommerce.estado_orden_id_estado_seq',    5);
SELECT setval('ecommerce.metodo_pago_id_metodo_pago_seq', 4);
SELECT setval('ecommerce.cupon_id_cupon_seq',            3);
