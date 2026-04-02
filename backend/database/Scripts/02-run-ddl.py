"""
02-run-ddl.py - Ejecuta los scripts DDL (crear tablas y alteraciones)
Uso: python 02-run-ddl.py --sql-dir ../../ddl --user ecommerce_admin --password "***REMOVED***" --host localhost --port 5432 --database ecommerce_db
Este archivo es un alias del script original renombrado para consistencia.
Si el script original ya maneja DDL, este archivo simplemente lo invoca.
"""

import subprocess
import argparse
import sys
import os

def main():
    parser = argparse.ArgumentParser(description="Ejecuta scripts DDL sobre la base de datos")
    parser.add_argument("--sql-dir",  required=True)
    parser.add_argument("--user",     required=True)
    parser.add_argument("--password", required=True)
    parser.add_argument("--host",     default="localhost")
    parser.add_argument("--port",     default="5432")
    parser.add_argument("--database", required=True)
    args = parser.parse_args()

    script_dir = os.path.dirname(os.path.abspath(__file__))
    original = os.path.join(script_dir, "01-create-db.py")

    cmd = [
        sys.executable, original,
        "--sql-dir",  args.sql_dir,
        "--user",     args.user,
        "--password", args.password,
        "--host",     args.host,
        "--port",     args.port,
        "--database", args.database
    ]

    result = subprocess.run(cmd)
    sys.exit(result.returncode)

if __name__ == "__main__":
    main()
