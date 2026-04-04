-- ##################################################
-- #            DDL SCRIPT: ALTER TABLES            #
-- ##################################################
-- This script adds foreign keys strictly matching the ERD model.

-- Modulo Usuario
ALTER TABLE ecommerce.direccion 
    ADD CONSTRAINT fk_direccion_usuario FOREIGN KEY (id_usuario) REFERENCES ecommerce.usuario (id_usuario) ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE ecommerce.usuario_metodo_pago 
    ADD CONSTRAINT fk_ump_usuario FOREIGN KEY (id_usuario) REFERENCES ecommerce.usuario (id_usuario) ON UPDATE CASCADE ON DELETE CASCADE,
    ADD CONSTRAINT fk_ump_metodopago FOREIGN KEY (id_metodo_pago) REFERENCES ecommerce.metodo_pago (id_metodo_pago) ON UPDATE CASCADE ON DELETE RESTRICT;

-- Modulo Producto
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

-- Modulo Carrito
ALTER TABLE ecommerce.carrito 
    ADD CONSTRAINT fk_carrito_usuario FOREIGN KEY (id_usuario) REFERENCES ecommerce.usuario (id_usuario) ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE ecommerce.carrito_item 
    ADD CONSTRAINT fk_ci_carrito FOREIGN KEY (id_carrito) REFERENCES ecommerce.carrito (id_carrito) ON UPDATE CASCADE ON DELETE CASCADE,
    ADD CONSTRAINT fk_ci_producto FOREIGN KEY (id_producto) REFERENCES ecommerce.producto (id_producto) ON UPDATE CASCADE ON DELETE RESTRICT;

-- Modulo Ordenes
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

-- Modulo Auditoria
ALTER TABLE ecommerce.auditoria 
    ADD CONSTRAINT fk_auditoria_usuario FOREIGN KEY (id_usuario) REFERENCES ecommerce.usuario (id_usuario) ON UPDATE CASCADE ON DELETE RESTRICT;
