# Gravity_Tech

Gravity_Tech es una plataforma de tienda virtual desarrollada como proyecto académico. El enfoque principal está en comprender y construir la lógica subyacente sin depender de frameworks complejos en el cliente.

El proyecto está dividido en dos partes principales: un **Backend** robusto construido en Node.js y Express, con una base de datos PostgreSQL; y un **Frontend** ligero construido únicamente con HTML, CSS y JavaScript vainilla.

---

## Estructura del Proyecto

```text
Gravity_Tech/
├── frontend/                # Interfaz de usuario (HTML puro, CSS, Vanilla JS)
│   ├── css/                 # Hojas de estilo y tokens de diseño
│   ├── js/                  # Lógica del cliente y comunicación API (Fetch)
│   ├── index.html           # Página principal / catálogo
│   ├── product.html         # Detalle de producto
│   ├── login.html           # Inicio de sesión
│   ├── register.html        # Registro de usuario
│   ├── admin-products.html  # Panel de gestión de productos (admin)
│   └── admin-orders.html    # Panel de gestión de órdenes (admin)
│
├── backend/
│   ├── src/
│   │   ├── config/       # Configuración de base de datos y seguridad
│   │   ├── controllers/  # Controladores de la API
│   │   ├── middlewares/  # JWT, RBAC, rate limiting, manejo de errores
│   │   ├── models/       # Consultas SQL puras (módulo pg)
│   │   ├── routers/      # Definición de endpoints de Express
│   │   ├── utils/        # Helpers (bcrypt, JWT, sanitización)
│   │   └── validators/   # Esquemas de validación de entrada
│   ├── database/
│   │   ├── ddl/          # Scripts de creación de tablas y migraciones
│   │   ├── seed/         # Datos de prueba
│   │   └── Scripts/      # Pipeline automatizado de instalación de BD
│   ├── app.js
│   ├── server.js
│   └── package.json
│
├── docs/                 # Documentación del proyecto
├── .gitignore
├── CAMBIOS.md            # Registro de cambios por sesión
└── README.md
```

---

## Stack Tecnológico

- **Frontend:** HTML5, Vanilla CSS, Vanilla JavaScript (Fetch API)
- **Backend:** Node.js, Express.js
- **Base de Datos:** PostgreSQL (Driver `pg`)
- **Autenticación:** JSON Web Tokens (JWT)
- **Seguridad:** bcryptjs, Helmet, rate limiting, validación con express-validator

---

## Cómo correr el proyecto en tu máquina local

Sigue estos pasos en orden. No necesitas conocimientos avanzados, solo seguir cada paso con calma.

---

### Requisitos previos

Antes de empezar necesitas tener instalados estos programas. Si ya los tienes puedes saltar al Paso 1.

#### Node.js
1. Ve a [https://nodejs.org](https://nodejs.org)
2. Descarga el **Windows Installer (.msi)** — es la opción recomendada para Windows
3. Instálalo con todas las opciones por defecto
4. Cierra y vuelve a abrir la terminal después de instalar
5. Verifica que quedó bien ejecutando:
```bash
node --version
npm --version
```
Deberías ver algo como `v20.x.x` y `10.x.x`.

#### PostgreSQL
Descárgalo desde [https://www.postgresql.org/download/](https://www.postgresql.org/download/) e instálalo con las opciones por defecto. Durante la instalación te pedirá una contraseña para el superusuario `postgres` — **anótala**, la necesitarás más adelante.

#### Python
Descárgalo desde [https://www.python.org](https://www.python.org) e instálalo. Durante la instalación marca la opción **"Add Python to PATH"**.

---

### Paso 1 — Clonar el repositorio

Abre una terminal (Git Bash o CMD) y ejecuta:

```bash
git clone git@github.com:Warzerp/Gravity_Tech.git
cd Gravity_Tech
```

---

### Paso 2 — Configurar las variables de entorno

Las variables de entorno le dicen al backend cómo conectarse a la base de datos. El archivo `.env` nunca se sube a GitHub por seguridad, así que hay que crearlo manualmente.

1. Abre la carpeta `backend/` en VS Code
2. Verás un archivo llamado `.env.example` — ábrelo
3. Crea un archivo nuevo en la misma carpeta llamado exactamente `.env` (sin extensión adicional)
4. Copia todo el contenido de `.env.example` y pégalo en el nuevo `.env`
5. Solo necesitas cambiar los valores que dicen `your_...` por tus datos reales. El resto puedes dejarlo igual.

El archivo `.env` debería quedar así:

```env
PORT=3000
NODE_ENV=development

JWT_SECRET=pega_aqui_el_resultado_del_comando_de_abajo
JWT_EXPIRATION=7d

DB_HOST=localhost
DB_PORT=5432
DB_NAME=ecommerce_db
DB_USER=ecommerce_admin
DB_PASSWORD=tu_contraseña_de_ecommerce_admin

DB_URL=postgresql://ecommerce_admin:tu_contraseña@localhost:5432/ecommerce_db

RATE_LIMIT_WINDOW_MS=900000
RATE_LIMIT_MAX_REQUESTS=100

LOG_LEVEL=info
LOG_FILE=logs/app.log

CORS_ORIGIN=http://localhost:3000,http://localhost:5000,http://127.0.0.1:5500,http://localhost:5500
```

Para generar el `JWT_SECRET` abre una terminal y ejecuta:

```bash
node -e "console.log(require('crypto').randomBytes(32).toString('hex'))"
```

Copia el resultado y pégalo como valor de `JWT_SECRET`.

> **Nota:** La contraseña de `DB_PASSWORD` es la que se creará para el usuario `ecommerce_admin` de la base de datos. Puedes elegir la que quieras, solo asegúrate de usar la misma en el Paso 3.

---

### Paso 3 — Instalar la base de datos

> **Si necesitas reinstalar la base de datos desde cero**, primero ejecuta esto en psql conectado como superusuario:
> ```sql
> DROP DATABASE IF EXISTS ecommerce_db;
> DROP ROLE IF EXISTS ecommerce_admin;
> ```

Abre una terminal y navega a la carpeta de la base de datos:

```bash
cd backend/database
```

Crea y activa un entorno virtual de Python:

```bash
python -m venv venv
venv\Scripts\activate
cd Scripts
```

Instala las dependencias de Python:

```bash
pip install -r requirements.txt
```

Ejecuta el script de instalación (reemplaza `AQUI_TU_CLAVE` por la contraseña del superusuario `postgres` que anotaste al instalar PostgreSQL):

```bash
python setup.py --user postgres --password "AQUI_TU_CLAVE"
```

El script creará automáticamente la base de datos, las tablas y los datos de prueba.

#### Migración adicional requerida

Una vez termine el script, abre **pgAdmin**, conéctate a `ecommerce_db` y ejecuta esto en el Query Tool:

```sql
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_constraint
    WHERE conname = 'uq_carrito_item_carrito_producto'
  ) THEN
    ALTER TABLE ecommerce.carrito_item
      ADD CONSTRAINT uq_carrito_item_carrito_producto
      UNIQUE (id_carrito, id_producto);
  END IF;
END $$;
```

---

### Paso 4 — Instalar dependencias del backend

Abre una terminal en la carpeta `backend/` y ejecuta:

```bash
npm install
```

---

### Paso 5 — Lanzar el servidor

```bash
npm run dev
```

Si todo está bien verás en la terminal:

```
TechStore server running on http://localhost:3000
[OK] Conectado a PostgreSQL
```

Puedes verificar que el servidor responde abriendo en el navegador:
```
http://localhost:3000/api/health
```

Debe mostrar: `{"status":"ok","timestamp":"..."}`.

---

### Paso 6 — Lanzar el frontend

Abre la carpeta `frontend/` en VS Code e instala la extensión **Live Server** si no la tienes. Luego haz clic derecho sobre `index.html` y selecciona **"Open with Live Server"**.

> **Importante:** El backend debe estar corriendo antes de abrir el frontend.

---

### Solución de problemas comunes

**Error: "Error al cargar productos" en el navegador**

Esto es un error de CORS. Ocurre cuando el frontend corre en una dirección que el backend no tiene permitida. Abre el `.env` y asegúrate de que `CORS_ORIGIN` incluye la dirección que muestra tu Live Server en la barra del navegador. Por ejemplo si ves `127.0.0.1:5500` agrega esa dirección:

```env
CORS_ORIGIN=http://localhost:3000,http://localhost:5000,http://127.0.0.1:5500,http://localhost:5500
```

Luego reinicia el servidor con `Ctrl+C` y vuelve a ejecutar `npm run dev`.

**Error: "npm no se reconoce como comando"**

Node.js no está instalado o no se agregó al PATH. Reinstálalo desde [https://nodejs.org](https://nodejs.org) y reinicia la terminal.

**Error de conexión a PostgreSQL**

Verifica que PostgreSQL está corriendo y que las credenciales en el `.env` son correctas.

---

## API Endpoints principales

| Método | Endpoint | Descripción |
|--------|----------|-------------|
| POST | `/api/auth/register` | Registrar usuario |
| POST | `/api/auth/login` | Iniciar sesión |
| GET | `/api/products` | Listar productos |
| GET | `/api/products/:id` | Detalle de producto |
| GET | `/api/cart` | Ver carrito |
| POST | `/api/cart` | Agregar al carrito |
| POST | `/api/orders/checkout` | Crear orden |
| GET | `/api/admin/orders` | Listar órdenes (admin) |
| GET | `/api/admin/users` | Listar usuarios (admin) |

---

## Control de versiones

El flujo de trabajo del proyecto sigue el modelo:

```
dev_[nombre] → PR → QA → PR → main
```

Los cambios realizados en cada sesión están documentados en `CAMBIOS.md`.