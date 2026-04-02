-- ##################################################
-- #         ECOMMERCE DATABASE CREATION SCRIPT         #
-- ##################################################

-- RUN IN POSTGRES

-- 01. Create user
CREATE USER ecommerce_admin WITH PASSWORD '***REMOVED***';

-- 02. Create database
CREATE DATABASE ecommerce_db WITH 
    ENCODING='UTF8' 
    LC_COLLATE='es_CO.UTF-8' 
    LC_CTYPE='es_CO.UTF-8' 
    TEMPLATE=template0 
    OWNER = ecommerce_admin;

-- 03. Grant privileges
GRANT ALL PRIVILEGES ON DATABASE ecommerce_db TO ecommerce_admin;
