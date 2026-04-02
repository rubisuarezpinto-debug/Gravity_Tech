"""
setup.py - Orquestador de instalacion de base de datos ecommerce
Uso: python setup.py --user postgres --password "tupassword"
"""

import subprocess
import argparse
import sys
import os
from dotenv import load_dotenv

load_dotenv()

SCRIPTS_DIR = os.path.dirname(os.path.abspath(__file__))

def run_script(script_name, args_list):
    script_path = os.path.join(SCRIPTS_DIR, script_name)
    if not os.path.exists(script_path):
        print(f"  Archivo no encontrado, saltando: {script_name}")
        return True
    cmd = [sys.executable, script_path] + args_list
    result = subprocess.run(cmd, capture_output=False, text=True)
    return result.returncode == 0

def main():
    parser = argparse.ArgumentParser(description="Instala la base de datos ecommerce")
    parser.add_argument("--host",     default="localhost")
    parser.add_argument("--port",     default="5432")
    parser.add_argument("--user",     required=True)
    parser.add_argument("--password", required=True)
    args = parser.parse_args()

    ddl_dir = os.path.join(SCRIPTS_DIR, "..", "ddl")

    steps = [
        {
            "nombre": "Crear base de datos",
            "script": "01-create-db.py",
            "extra_args": [
                "--sql-dir", ddl_dir,
                "--user", "postgres",
                "--password", args.password,
                "--host", args.host,
                "--port", args.port,
                "--database", "postgres",
                "--create-script", "true"
            ]
        },
        {
            "nombre": "Crear tablas y aplicar migraciones",
            "script": "02-run-ddl.py",
            "extra_args": [
                "--sql-dir", ddl_dir,
                "--user", os.getenv("DB_USER", "ecommerce_admin"),
                "--password", os.getenv("DB_PASSWORD", ""),
                "--host", args.host,
                "--port", args.port,
                "--database", os.getenv("DB_NAME", "ecommerce_db")
            ]
        },
       {
            "nombre": "Insertar datos de prueba (seed)",
            "script": "02-run-seed.py",
            "extra_args": [
                "--host",       args.host,
                "--port",       args.port,
                "--user",       os.getenv("DB_USER", "ecommerce_admin"),
                "--password",   os.getenv("DB_PASSWORD", ""),
                "--db-name",    os.getenv("DB_NAME", "ecommerce_db"),
                "--sql-dir",    os.path.join(SCRIPTS_DIR, "..", "seed")
            ]
        },
    ]

    print("\n========================================")
    print("  Instalacion de BD ecommerce")
    print("========================================\n")

    ok = 0
    for i, step in enumerate(steps, 1):
        print(f"[{i}/{len(steps)}] {step['nombre']}...")
        exito = run_script(step["script"], step["extra_args"])
        if exito:
            print(f"  OK - Completado\n")
            ok += 1
        else:
            print(f"  ERROR en '{step['nombre']}'. Proceso detenido.\n")
            print(f"Resultado: {ok}/{len(steps)} pasos completados.")
            sys.exit(1)

    print(f"========================================")
    print(f"Todo listo. {ok}/{len(steps)} pasos completados.")
    print(f"Base de datos ecommerce_db instalada correctamente.")
    print(f"========================================\n")

if __name__ == "__main__":
    main()
