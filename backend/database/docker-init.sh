#!/bin/bash
# Runs automatically when Postgres container starts for the first time.
# Called by docker-entrypoint-initdb.d — do not run manually.
set -e

DB_DIR="/db"

run() {
  psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "$POSTGRES_DB" -f "$1" -q
}

echo "▶  [1/3] Creando tablas..."
run "$DB_DIR/ddl/02-create-tables.sql"
run "$DB_DIR/ddl/03-alter-tables.sql"
run "$DB_DIR/ddl/04-migrations.sql"

echo "▶  [2/3] Cargando catálogo (categorías, marcas, etc.)..."
for f in "$DB_DIR/seed/Catalogo/"*.sql; do
  run "$f"
done

echo "▶  [3/3] Cargando datos de prueba (usuarios, productos, órdenes)..."
for f in "$DB_DIR/seed/Bulk-Load/"*.sql; do
  run "$f"
done

echo "✅  Base de datos lista."
