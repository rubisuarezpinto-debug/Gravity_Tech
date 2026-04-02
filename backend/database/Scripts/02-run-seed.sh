# Ejecutar pipeline de insercion para eCommerce
python .\sql_insert_pipeline_auto.py --sql-dir ../../dml --user ecommerce_admin --password "***REMOVED***" --host localhost --port 5432 --db-name ecommerce_db --schema-name ecommerce
