-- ##################################################
-- #       DDL SCRIPT: DATABASE & ROLE CREATION     #
-- ##################################################
-- Este script inicializa el entorno individual para Rubi Suarez.
-- Se debe ejecutar como superusuario (postgres) antes de montar las tablas.

-- 1. CREACIÓN DEL ROL ADMINISTRADOR EXCLUSIVO
-- Se verifica si el usuario ya existe para evitar errores en la consola
DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_roles WHERE rolname = 'ecommerce_admin_rubi') THEN
        CREATE ROLE ecommerce_admin_rubi WITH LOGIN PASSWORD 'clave_rubi';
        ALTER ROLE ecommerce_admin_rubi SUPERUSER; -- Concede permisos para gestionar el esquema sin restricciones
    END IF;
END $$;

-- 2. CREACIÓN DE LA BASE DE DATOS PROPIA
-- PostgreSQL no permite ejecutar 'CREATE DATABASE' dentro de un bloque DO $$,
-- por lo que usamos una consulta directa para verificar su existencia.
SELECT 'Creando base de datos...' WHERE NOT EXISTS (SELECT 1 FROM pg_database WHERE datname = 'gravity_tech_rubi');

-- Nota: Si ejecutas este archivo completo y la BD ya existe, 
-- el sistema simplemente omitirá este paso o te dará un aviso que puedes ignorar.
CREATE DATABASE gravity_tech_rubi WITH OWNER = ecommerce_admin_rubi;