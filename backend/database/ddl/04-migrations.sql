-- ##################################################
-- #             SCRIPT DE MIGRACIONES              #
-- ##################################################
-- Ejecutar en orden sobre la base de datos ecommerce_db.
-- Cada bloque está protegido con DO $$ para no fallar si ya existe.

-- ── Migración 001 ─────────────────────────────────────────
-- Agrega constraint UNIQUE en carrito_item(id_carrito, id_producto)
-- Requerida para que el UPSERT en Cart.js (ON CONFLICT) funcione.
-- ATENCIÓN: si existen filas duplicadas, elimínalas antes con:
--   DELETE FROM ecommerce.carrito_item a
--   USING ecommerce.carrito_item b
--   WHERE a.id_carrito_item > b.id_carrito_item
--     AND a.id_carrito   = b.id_carrito
--     AND a.id_producto  = b.id_producto;

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

-- ── Migración 002 ─────────────────────────────────────────
-- UNIQUE en imagen(id_producto) requerido por el ON CONFLICT de Product.js
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_constraint
    WHERE conname = 'uq_imagen_producto'
  ) THEN
    -- Eliminar duplicados si existen antes de agregar el constraint
    DELETE FROM ecommerce.imagen a
    USING ecommerce.imagen b
    WHERE a.id_imagen > b.id_imagen
      AND a.id_producto = b.id_producto;

    ALTER TABLE ecommerce.imagen
      ADD CONSTRAINT uq_imagen_producto UNIQUE (id_producto);
  END IF;
END $$;
