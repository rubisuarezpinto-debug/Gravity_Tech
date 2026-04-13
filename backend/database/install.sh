#!/usr/bin/env bash
# ============================================================
#  install.sh — Instala la base de datos completa de Gravity Tech
# ============================================================
#
#  Uso (desde cualquier lugar del proyecto):
#    bash backend/database/install.sh
#
#  Requisitos:
#    - psql instalado y en el PATH
#    - backend/.env con: DB_HOST, DB_PORT, DB_NAME, DB_USER, DB_PASSWORD
#    - Contraseña del usuario 'postgres' (superusuario de PostgreSQL)
#
#  Qué hace:
#    [1/4] Crea el usuario y la base de datos (como postgres)
#    [2/4] Crea el esquema y todas las tablas   (como ecommerce_admin)
#    [3/4] Agrega llaves foráneas y migraciones (como ecommerce_admin)
#    [4/4] Carga todos los datos de prueba       (como ecommerce_admin)
# ============================================================

set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
ENV_FILE="$SCRIPT_DIR/../.env"

# ── Cargar variables del .env ────────────────────────────────
if [ -f "$ENV_FILE" ]; then
  set -a
  # shellcheck source=/dev/null
  source <(grep -v '^#' "$ENV_FILE" | grep '=')
  set +a
else
  echo "ERROR: No se encontró $ENV_FILE"
  echo "Crea el archivo backend/.env con DB_HOST, DB_PORT, DB_NAME, DB_USER, DB_PASSWORD"
  exit 1
fi

DB_HOST="${DB_HOST:-localhost}"
DB_PORT="${DB_PORT:-5432}"
DB_NAME="${DB_NAME:-ecommerce_db}"
DB_USER="${DB_USER:-ecommerce_admin}"

if [ -z "$DB_PASSWORD" ]; then
  echo "ERROR: DB_PASSWORD no está definida en backend/.env"
  exit 1
fi

# ── Contraseña de postgres (superusuario) ────────────────────
echo ""
read -rsp "Contraseña del superusuario 'postgres': " POSTGRES_PASSWORD
echo ""
echo ""

# ── Helpers ─────────────────────────────────────────────────
run_as_postgres() {
  PGPASSWORD="$POSTGRES_PASSWORD" psql -v ON_ERROR_STOP=1 \
    -h "$DB_HOST" -p "$DB_PORT" -U postgres "$@"
}

run_as_admin() {
  PGPASSWORD="$DB_PASSWORD" psql -v ON_ERROR_STOP=1 \
    -h "$DB_HOST" -p "$DB_PORT" -U "$DB_USER" -d "$DB_NAME" "$@"
}

# ── [1/4] Crear usuario y base de datos ─────────────────────
echo "▶  [1/4] Creando usuario '$DB_USER' y base de datos '$DB_NAME'..."

# Auto-detección de locale según el sistema operativo
# En Linux/Docker suele ser es_CO.UTF-8, en Windows suele ser Spanish_Colombia.1252
LOCALE="es_CO.UTF-8"
if [[ "$OSTYPE" == "msys" || "$OSTYPE" == "win32" ]]; then
  LOCALE="Spanish_Colombia.1252"
fi

run_as_postgres <<SQL
DO \$\$
BEGIN
  IF NOT EXISTS (SELECT FROM pg_roles WHERE rolname = '$DB_USER') THEN
    CREATE USER $DB_USER WITH PASSWORD '$DB_PASSWORD';
    RAISE NOTICE 'Usuario % creado.', '$DB_USER';
  ELSE
    ALTER USER $DB_USER WITH PASSWORD '$DB_PASSWORD';
    RAISE NOTICE 'Usuario % ya existía — contraseña actualizada.', '$DB_USER';
  END IF;
END
\$\$;

DROP DATABASE IF EXISTS $DB_NAME;

CREATE DATABASE $DB_NAME
  WITH ENCODING  = 'UTF8'
       LC_COLLATE = '$LOCALE'
       LC_CTYPE   = '$LOCALE'
       TEMPLATE   = template0
       OWNER      = $DB_USER;

GRANT ALL PRIVILEGES ON DATABASE $DB_NAME TO $DB_USER;
SQL

# ── [2/4] Crear tablas ───────────────────────────────────────
echo "▶  [2/4] Creando esquema y tablas..."
run_as_admin -f "$SCRIPT_DIR/ddl/02-create-tables.sql"

# ── [3/4] Llaves foráneas + migraciones ─────────────────────
echo "▶  [3/4] Aplicando llaves foráneas y migraciones..."
run_as_admin -f "$SCRIPT_DIR/ddl/03-alter-tables.sql"
run_as_admin -f "$SCRIPT_DIR/ddl/04-migrations.sql"

# ── [4/4] Datos de prueba ────────────────────────────────────
echo "▶  [4/4] Cargando datos de prueba..."

echo "    → Catálogo (categorías, marcas, estados, métodos de pago)..."
for f in "$SCRIPT_DIR/seed/Catalogo/"*.sql; do
  run_as_admin -f "$f" -q
done

echo "    → Datos masivos (usuarios, productos, órdenes...)..."
for f in "$SCRIPT_DIR/seed/Bulk-Load/"*.sql; do
  run_as_admin -f "$f" -q
done

echo ""
echo "✅  Listo. Base de datos '$DB_NAME' instalada."
echo "    Arranca el backend con:  cd backend && npm run dev"
echo ""
