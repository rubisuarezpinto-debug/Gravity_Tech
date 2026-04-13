# Instalación de la base de datos — Gravity Tech

Esta guía lleva paso a paso desde cero hasta tener la base de datos funcionando. No asume que ya tenés nada configurado.

---

## Requisitos previos

Antes de empezar, asegurate de tener instalado:

- **PostgreSQL 14 o superior** — [descargar aquí](https://www.postgresql.org/download/windows/)  
  Durante la instalación te va a pedir una contraseña para el usuario `postgres`. Anótala, la vas a necesitar.
- **Git Bash** (viene incluido con Git for Windows) — lo necesitás para correr el script `.sh`  
  Si no tenés Git: [descargar aquí](https://git-scm.com/download/win)

---

## Paso 1 — Abrir una terminal

Abrí **Git Bash** (no el CMD ni PowerShell normal, porque el script usa sintaxis bash).

**Cómo abrirlo:**
- Presioná `Windows + S`, escribí `Git Bash` y dale Enter.

Vas a ver una ventana negra con el prompt `$`.

---

## Paso 2 — Ir a la carpeta del proyecto

Escribí el siguiente comando, reemplazando la ruta por donde tenés el proyecto:

```bash
cd "/c/Users/TU_USUARIO/ruta/al/proyecto/Tienda virtual"
```

Por ejemplo, si el proyecto está en Documentos:

```bash
cd "/c/Users/jhoan/OneDrive/Documentos/Desarrollo orientado a plataformas/Tienda virtual"
```

Verificá que estás en el lugar correcto:

```bash
ls
```

Deberías ver carpetas como `backend/`, `frontend/`, `docs/`, etc.

---

## Paso 3 — Verificar que psql está disponible

Escribí:

```bash
psql --version
```

Deberías ver algo como:

```
psql (PostgreSQL) 16.2
```

Si aparece `command not found`, significa que PostgreSQL no está en el PATH. Solucionalo así:

1. Buscá dónde instalaste PostgreSQL (normalmente `C:\Program Files\PostgreSQL\16\bin`)
2. Abrí **Variables de entorno** en Windows → agregá esa ruta al PATH
3. Cerrá y volvé a abrir Git Bash

---

## Paso 4 — Revisar el archivo .env

El script de instalación lee las credenciales de la base de datos desde `backend/.env`.

Abrí el archivo con cualquier editor de texto y verificá que tenga estas líneas con los valores correctos:

```
DB_HOST=localhost
DB_PORT=5432
DB_NAME=ecommerce_db
DB_USER=ecommerce_admin
DB_PASSWORD=tu_contraseña_aqui
```

> Si alguna de esas líneas no existe o está en blanco, completala antes de continuar.

---

## Paso 5 — Correr el script de instalación

Desde la terminal (en la raíz del proyecto), ejecutá:

```bash
bash backend/database/install.sh
```

El script te va a pedir la contraseña del superusuario `postgres` (la que pusiste cuando instalaste PostgreSQL):

```
Contraseña del superusuario 'postgres': 
```

Escribí la contraseña y presioná Enter. **No va a aparecer nada mientras escribís** — eso es normal, es por seguridad.

---

## Paso 6 — Esperar la instalación

El script corre cuatro pasos automáticamente:

```
▶  [1/4] Creando usuario 'ecommerce_admin' y base de datos 'ecommerce_db'...
▶  [2/4] Creando esquema y tablas...
▶  [3/4] Aplicando llaves foráneas y migraciones...
▶  [4/4] Cargando datos de prueba...
    → Catálogo (categorías, marcas, estados, métodos de pago)...
    → Datos masivos (usuarios, productos, órdenes...)...
```

Cuando termina correctamente aparece:

```
✅  Listo. Base de datos 'ecommerce_db' instalada.
    Arranca el backend con:  cd backend && npm run dev
```

---

## Paso 7 — Verificar que todo quedó bien (opcional)

Para confirmar que la base de datos tiene las tablas y datos, conectate así:

```bash
psql -h localhost -p 5432 -U ecommerce_admin -d ecommerce_db
```

Te pide la contraseña del usuario `ecommerce_admin` (la que está en el `.env` como `DB_PASSWORD`).

Una vez dentro, podés correr:

```sql
-- Ver todas las tablas del esquema ecommerce
\dt ecommerce.*

-- Contar cuántos productos cargó
SELECT COUNT(*) FROM ecommerce.producto;

-- Ver las categorías disponibles
SELECT * FROM ecommerce.categoria;

-- Salir de psql
\q
```

---

## Paso 8 — Arrancar el backend

Con la base de datos lista, arrancá el servidor:

```bash
cd backend
npm install      # solo la primera vez
npm run dev
```

Deberías ver:

```
Server running on port 3000
Database connected
```

---

## Errores comunes

### "password authentication failed for user postgres"

La contraseña del superusuario `postgres` que escribiste es incorrecta. Intentá recordarla o resetéala desde pgAdmin.

---

### "could not connect to server"

PostgreSQL no está corriendo. Inicialo:

- Buscá **Services** en Windows (`Windows + R` → `services.msc`)
- Buscá el servicio `postgresql-x64-16` (o similar)
- Click derecho → **Iniciar**

---

### "invalid locale name: es_CO.UTF-8"

Tu sistema Windows no tiene instalado el locale en español de Colombia. Solucionalo así:

1. Abrí el archivo `backend/database/install.sh` con un editor de texto
2. Reemplazá las dos líneas de locale:
   ```
   LC_COLLATE = 'es_CO.UTF-8'
   LC_CTYPE   = 'es_CO.UTF-8'
   ```
   por:
   ```
   LC_COLLATE = 'Spanish_Colombia.1252'
   LC_CTYPE   = 'Spanish_Colombia.1252'
   ```
3. Corrés el script de nuevo

---

### "ERROR: DB_PASSWORD no está definida en backend/.env"

Abrí `backend/.env` y asegurate de que existe la línea `DB_PASSWORD=tu_contraseña` sin espacios ni comillas.

---

### El script falla a mitad

Si el script falla en el paso 2, 3 o 4 (después de crear la base de datos), podés relanzarlo directamente desde psql sin volver a crear el usuario:

```bash
# Solo tablas, constraints y datos (sin recrear la BD)
PGPASSWORD=tu_contraseña psql -h localhost -p 5432 -U ecommerce_admin -d ecommerce_db \
  -f backend/database/ddl/02-create-tables.sql \
  -f backend/database/ddl/03-alter-tables.sql \
  -f backend/database/ddl/04-migrations.sql
```

---

## Estructura de archivos de la base de datos

Por si necesitás entender qué hace cada archivo:

```
backend/database/
├── install.sh                  ← Script principal (este es el que corrés)
├── ddl/
│   ├── 01-create-database.sql  ← Referencia: crea usuario y BD (lo hace el script)
│   ├── 02-create-tables.sql    ← Define todas las tablas del esquema ecommerce
│   ├── 03-alter-tables.sql     ← Agrega las llaves foráneas entre tablas
│   └── 04-migrations.sql       ← Ajustes posteriores (constraints extras)
└── seed/
    ├── Catalogo/               ← Datos fijos: categorías, marcas, estados, etc.
    └── Bulk-Load/              ← Datos de prueba: usuarios, productos, órdenes, etc.
```
