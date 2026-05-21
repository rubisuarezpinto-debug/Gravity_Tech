-- ##################################################
-- #             SCRIPT DE MIGRACIONES              #
-- ##################################################
-- Ejecutar en orden sobre la base de datos gravity_tech_rubi.
-- Cada bloque está protegido con DO $$ o condicionales para no fallar en ejecuciones consecutivas.

-- ── Migración 001 ─────────────────────────────────────────
-- Agrega constraint UNIQUE en carrito_item(id_carrito, id_producto)
-- Requerida para que el UPSERT en el backend (ON CONFLICT) funcione correctamente.

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

-- ── Migración 002 (Datos Semilla / Seeders) ───────────────
-- Inserta los estados de orden predeterminados para la App móvil si no existen.

INSERT INTO ecommerce.estado_orden (id_estado, nombre) VALUES
  (1, 'PENDIENTE'),
  (2, 'PAGADO'),
  (3, 'ENVIADO'),
  (4, 'ENTREGADO'),
  (5, 'CANCELADO')
ON CONFLICT (id_estado) DO NOTHING;

-- Inserta los métodos de pago estándar aceptados por la pasarela del backend.
INSERT INTO ecommerce.metodo_pago (id_metodo_pago, nombre) VALUES
  (1, 'EFECTIVO'),
  (2, 'TARJETA_CREDITO'),
  (3, 'TARJETA_DEBITO'),
  (4, 'TRANSFERENCIA_BANCARIA')
ON CONFLICT (id_metodo_pago) DO NOTHING;

-- Inserta los tipos de envío válidos para el cálculo de logística.
INSERT INTO ecommerce.tipo_envio (id_tipo_envio, nombre) VALUES
  (1, 'RETIRO_EN_TIENDA'),
  (2, 'ENVIO_ESTANDAR'),
  (3, 'ENVIO_EXPRESS')
ON CONFLICT (id_tipo_envio) DO NOTHING;

-- Sincronizar las secuencias de los IDs de catálogos para evitar errores en futuros inserts automáticos
SELECT setval('ecommerce.estado_orden_id_estado_seq', COALESCE((SELECT MAX(id_estado) FROM ecommerce.estado_orden), 1));
SELECT setval('ecommerce.metodo_pago_id_metodo_pago_seq', COALESCE((SELECT MAX(id_metodo_pago) FROM ecommerce.metodo_pago), 1));
SELECT setval('ecommerce.tipo_envio_id_tipo_envio_seq', COALESCE((SELECT MAX(id_tipo_envio) FROM ecommerce.tipo_envio), 1));