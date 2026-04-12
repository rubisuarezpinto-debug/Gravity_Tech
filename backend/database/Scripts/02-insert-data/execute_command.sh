# Ejecutar pipeline de insercion para eCommerce
# Cargar variables de entorno si existe el archivo .env
if [ -f .env ]; then
  export $(cat .env | grep -v '^#' | awk '/=/ {print $1}')
fi

# Ejecutar pipeline de insercion para eCommerce
python .\sql_insert_pipeline_auto.py --sql-dir ../../ddl --user "${DB_USER:-ecommerce_admin}" --password "${DB_PASSWORD}" --host "${DB_HOST:-localhost}" --port "${DB_PORT:-5432}" --db-name "${DB_NAME:-ecommerce_db}" --schema-name ecommerce







































