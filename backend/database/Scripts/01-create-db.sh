# Cargar variables de entorno si existe el archivo .env
if [ -f .env ]; then
  export $(cat .env | grep -v '^#' | awk '/=/ {print $1}')
fi

# Primer Script: Crear base de datos
python .\01-sql-ddl-script-auto.py --sql-dir ../../ddl --user postgres --password "${POSTGRES_PASSWORD:-*}" --host "${DB_HOST:-localhost}" --port "${DB_PORT:-5432}" --database postgres --create-script true
# Segundo Script: Crear tablas y alterar tablas
python .\01-sql-ddl-script-auto.py --sql-dir ../../ddl --user "${DB_USER:-ecommerce_admin}" --password "${DB_PASSWORD}" --host "${DB_HOST:-localhost}" --port "${DB_PORT:-5432}" --database "${DB_NAME:-ecommerce_db}"
