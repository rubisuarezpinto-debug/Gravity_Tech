-- ##################################################
-- #         ECOMMERCE DATABASE CREATION SCRIPT         #
-- ##################################################

-- RUN IN POSTGRES

-- 00. Drop existing to allow fresh start
DROP DATABASE IF EXISTS <DB_NAME>;
DROP USER IF EXISTS <DB_USER>;

-- 01. Create user
CREATE USER <DB_USER> WITH PASSWORD '<DB_PASSWORD>';

-- 02. Create database
CREATE DATABASE <DB_NAME> WITH 
    ENCODING='UTF8' 
    LC_COLLATE='es_CO.UTF-8' 
    LC_CTYPE='es_CO.UTF-8' 
    TEMPLATE=template0 
    OWNER = <DB_USER>;

-- 03. Grant privileges
GRANT ALL PRIVILEGES ON DATABASE <DB_NAME> TO <DB_USER>;
