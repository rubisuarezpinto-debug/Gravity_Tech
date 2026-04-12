# Gravity_Tech 

Gravity_Tech es una plataforma de tienda virtual desarrollada como proyecto académico. El enfoque principal está en comprender y construir la lógica subyacente sin depender de frameworks complejos en el cliente.

El proyecto está dividido en dos partes principales: un **Backend** robusto construido en Node.js y Express, con una base de datos PostgreSQL; y un **Frontend** ligero construido únicamente con HTML, CSS y JavaScript vainilla.

## Estructura del Proyecto

La arquitectura base del proyecto sigue el modelo de "Corto Plazo", diseñado para el aprendizaje y la simplicidad:

```text
Gravity_Tech/
├── frontend/             # Interfaz de usuario (HTML puro, CSS, Vanilla JS)
│   ├── pages/            # Vistas HTML (index, product, cart, checkout, login...)
│   ├── css/              # Hojas de estilo y Tokens de diseño (variables.css, main.css)
│   ├── js/               # Lógica del cliente, carrito local y comunicación API (Fetch)
│   └── assets/           # Recursos estáticos (imágenes, iconos)
│
├── backend/              # Lógica de servidor y API
│   ├── src/
│   │   ├── config/       # Configuración de base de datos PostgreSQL
│   │   ├── controllers/  # Controladores de la API (Lógica de autenticación, productos, órdenes)
│   │   ├── middlewares/  # Validaciones (Autenticación JWT, RBAC de admin, control de errores)
│   │   ├── models/       # Adaptadores de base de datos con consultas SQL puras (Módulo pg)
│   │   ├── routers/      # Definición de Endpoints de Express
│   │   └── utils/        # Funciones helpers (Hashing con bcrypt, firmado de JWT)
│   ├── app.js            # Instanciación y middlewares globales de Express
│   ├── server.js         # Entrada principal del servidor web (Puerto 3000)
│   └── package.json      # Dependencias
│
├── .gitignore            # Reglas globales de exclusión para Git
└── README.md             # Documentación del proyecto
```

## Stack Tecnológico

- **Frontend:** HTML5, Vanilla CSS, Vanilla JavaScript (Fetch API).
- **Backend:** Node.js, Express.js.
- **Base de Datos:** PostgreSQL (Driver `pg`).
- **Autenticación:** JSON Web Tokens (JWT).
- **Seguridad:** contraseñas encriptadas con `bcryptjs`.

## Guía de Instalación Rápida

Sigue estos pasos para arrancar el entorno local de desarrollo:

### 1. Configurar la Base de Datos

El motor requerido es [PostgreSQL](https://www.postgresql.org/download/). Una vez instalado, asegúrate de tener una base de datos creada para este proyecto.

### 2. Variables de Entorno

Ve a la carpeta del `backend/` y copia la plantilla `.env.example` para crear tu archivo `.env` local:

```bash
cd backend
cp .env.example .env
```
Abre el nuevo archivo `.env` en tu editor e ingresa tus credenciales reales de la base de datos PostgreSQL, así como tu clave secreta JWT.

### 3. Instalar Dependencias del Backend

Dentro de la carpeta `backend`, ejecuta el comando estándar de instalación de NPM para descargar `express`, `pg`, `cors`, etc.

```bash
npm install
```

### 4. Lanzar el Servidor

Inicia el entorno de desarrollo usando `nodemon` (que reiniciará el servidor automáticamente frente a cualquier cambio):

```bash
npm run dev
```

Si la conexión es exitosa, la consola te mostrará un mensaje indicando que el servidor está corriendo y se ha contactado con PostgreSQL.

### 5. Lanzar el Frontend

Dado que el frontend está hecho en Vanilla JS y HTML estático, puedes abrir, por ejemplo, `frontend/pages/index.html` con la extensión **Live Server** de Visual Studio Code o desde tu navegador (asegurándote de que el backend esté encendido para que el frontend pueda extraer los productos).
