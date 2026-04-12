# Primer Script: Crear base de datos
python .\01-sql-ddl-script-auto.py --sql-dir ../../ddl --user postgres --password "*" --host localhost --port 5432 --database postgres --create-script true
# Segundo Script: Crear tablas y alterar tablas
python .\01-sql-ddl-script-auto.py --sql-dir ../../ddl --user ecommerce_admin --password "ec2026" --host localhost --port 5432 --database ecommerce_db
