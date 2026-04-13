# Funcionamiento del sistema — TechStore

## Tabla de contenidos

1. [Arquitectura general](#1-arquitectura-general)
2. [Estructura de carpetas](#2-estructura-de-carpetas)
3. [Base de datos](#3-base-de-datos)
4. [Flujo de datos completo](#4-flujo-de-datos-completo)
5. [Sistema de autenticación y tokenización (JWT)](#5-sistema-de-autenticación-y-tokenización-jwt)
6. [Formatos JSON de la API](#6-formatos-json-de-la-api)
7. [Pipeline de seguridad por request](#7-pipeline-de-seguridad-por-request)
8. [Conexión en la nube](#8-conexión-en-la-nube)

---

## 1. Arquitectura general

```
┌─────────────────────────────────────────────────────────┐
│  USUARIO (navegador)                                    │
│  HTML + CSS + JavaScript vanilla                        │
└───────────────────────┬─────────────────────────────────┘
                        │  fetch() HTTP con JWT en header
                        ▼
┌─────────────────────────────────────────────────────────┐
│  BACKEND — Node.js + Express                            │
│  Hosting: Render.com                                    │
│  URL: https://techstore-backend-a4e2.onrender.com       │
└───────────────────────┬─────────────────────────────────┘
                        │  Pool de conexiones (pg)
                        ▼
┌─────────────────────────────────────────────────────────┐
│  BASE DE DATOS — PostgreSQL serverless                  │
│  Hosting: Neon DB                                       │
│  Schema: ecommerce                                      │
└─────────────────────────────────────────────────────────┘
```

El frontend es **estático** (sin framework, sin build step). El backend es una **API REST** con Node.js. La base de datos vive en **Neon DB** (PostgreSQL serverless en la nube).

---

## 2. Estructura de carpetas

### Frontend (`/frontend/`)

```
frontend/page
├── index.html              ← Página principal / catálogo
├── product.html            ← Detalle de producto
├── cart.html               ← Carrito de compras
├── checkout.html           ← Finalizar compra
├── login.html              ← Login
├── register.html           ← Registro
├── admin.html              ← Panel admin (productos)
├── admin-orders.html       ← Panel admin (órdenes)
├── admin-products.html     ← Panel admin (gestión productos)
│
├── css/
│   ├── variables.css       ← Variables CSS globales (colores, tipografía)
│   ├── main.css            ← Estilos base compartidos
│   ├── auth.css            ← Login y registro
│   ├── cart.css            ← Carrito
│   ├── checkout.css        ← Checkout
│   ├── product.css         ← Detalle de producto
│   ├── orders.css          ← Historial de órdenes
│   └── admin.css           ← Panel de administración
│
└── js/
    ├── config.js           ← Detecta entorno: local vs producción → define window.CONFIG
    ├── auth.js             ← Gestión de sesión (localStorage) + UI de modales
    ├── api.js              ← Todas las llamadas fetch al backend (capa centralizada)
    ├── index.js            ← Lógica del catálogo de productos
    ├── cart.js             ← Lógica del carrito
    ├── checkout.js         ← Lógica del pago/checkout
    ├── admin.js            ← Panel admin: gestión de productos
    ├── ordersAdmin.js      ← Panel admin: gestión de órdenes
    └── utils.js            ← Helpers compartidos (formateo de precios, fechas, etc.)
```

**Orden de carga de scripts en cada HTML** (el orden importa):
```
1. config.js   → define window.CONFIG.API_URL
2. auth.js     → define window.auth (usa window.CONFIG)
3. api.js      → define window.api (usa window.CONFIG y window.auth)
4. *.js        → lógica de la página (usa window.api y window.auth)
```

---

### Backend (`/backend/`)

```
backend/
├── server.js               ← Punto de entrada: carga .env y levanta Express en PORT
├── app.js                  ← Configura middlewares globales y registra todos los routers
├── package.json            ← Dependencias: express, pg, jsonwebtoken, bcryptjs, helmet...
│
└── src/
    ├── config/
    │   ├── db.js           ← Pool de conexiones a PostgreSQL (usa env DB_URL)
    │   └── security.js     ← Config centralizada: JWT, CORS, rate limits, Helmet, bcrypt
    │
    ├── middlewares/
    │   ├── authenticate.js ← Verifica JWT del header → adjunta req.user
    │   ├── authorize.js    ← RBAC: verifica que req.user.role sea el requerido
    │   ├── rateLimiter.js  ← Límites por IP/email (global, auth, register, orders)
    │   └── errorHandler.js ← Captura errores globales → respuesta JSON uniforme y segura
    │
    ├── routers/            ← Define URLs y aplica middlewares antes del controller
    │   ├── auth.router.js
    │   ├── products.router.js
    │   ├── cart.router.js
    │   ├── orders.router.js
    │   ├── admin.router.js
    │   └── reviews.router.js
    │
    ├── controllers/        ← Lógica de cada endpoint (recibe req, llama modelo, devuelve JSON)
    │   ├── auth.controller.js
    │   ├── products.controller.js
    │   ├── cart.controller.js
    │   ├── orders.controller.js
    │   ├── admin.controller.js
    │   └── reviews.controller.js
    │
    ├── models/             ← Queries SQL directas a la base de datos
    │   ├── User.js
    │   ├── Product.js
    │   ├── Cart.js
    │   ├── Order.js
    │   ├── Payment.js
    │   └── Review.js
    │
    ├── validators/         ← Validación de cuerpo de request (express-validator)
    │
    └── utils/
        ├── jwt.js          ← sign(payload) y verify(token) usando jsonwebtoken
        ├── hash.js         ← hash(password) y compare() usando bcryptjs
        └── sanitizer.js    ← sanitizeUser(), escapeHtml(), sanitizeString(), etc.
```

---

## 3. Base de datos

### 3.1 Tecnología y hosting

- **Motor:** PostgreSQL 15 (serverless)
- **Hosting:** Neon DB (cloud)
- **Schema:** `ecommerce` (todas las tablas viven aquí, separadas del schema `public`)
- **Conexión:** Pool de conexiones vía librería `pg` usando la variable de entorno `DB_URL`

Al conectar cada cliente del pool se ejecuta automáticamente:
```sql
SET search_path TO ecommerce, public;
```
Esto permite escribir queries sin prefijo (`producto` en vez de `ecommerce.producto`), aunque el código usa el prefijo explícito para mayor claridad.

---

### 3.2 Diagrama de tablas (ERD simplificado)

```
CATÁLOGOS (tablas de referencia)
─────────────────────────────────────────────────────────────────────
 categoria          marca              tipo_envio
 id_categoria PK    id_marca PK        id_tipo_envio PK
 nombre             nombre             nombre

 estado_orden       metodo_pago
 id_estado PK       id_metodo_pago PK
 nombre             nombre


MÓDULO USUARIO
─────────────────────────────────────────────────────────────────────
 usuario
 id_usuario PK
 nombre
 email UNIQUE
 password_hash          ← contraseña hasheada con bcrypt (nunca en texto plano)
 rol                    ← 'cliente' | 'admin'
 estado                 ← 'ACTIVO' | ...
 fecha_creacion
 fecha_actualizacion
      │
      ├──► direccion
      │    id_direccion PK
      │    id_usuario FK
      │    direccion, ciudad, pais
      │
      └──► usuario_metodo_pago  (tabla pivot N:N)
           id_usuario FK
           id_metodo_pago FK
           estado


MÓDULO PRODUCTO
─────────────────────────────────────────────────────────────────────
 producto
 id_producto PK
 nombre
 descripcion
 precio DECIMAL(10,2)
 stock INT
 sku UNIQUE
 id_marca FK
 estado                 ← 'DISPONIBLE' | 'NO_DISPONIBLE' (soft-delete)
 fecha_creacion
 fecha_actualizacion
      │
      ├──► imagen                    ← un producto puede tener varias imágenes
      │    id_imagen PK
      │    id_producto FK
      │    url
      │
      ├──► producto_categoria  (tabla pivot N:N)
      │    id_producto FK
      │    id_categoria FK
      │
      └──► resena
           id_resena PK
           id_usuario FK
           id_producto FK
           comentario
           puntuacion INT  CHECK (1..5)
           fecha_creacion


MÓDULO CARRITO
─────────────────────────────────────────────────────────────────────
 carrito
 id_carrito PK
 id_usuario FK
 estado                 ← 'ABIERTO' | 'CERRADO'
 fecha_creacion
 fecha_actualizacion
      │
      └──► carrito_item
           id_carrito_item PK
           id_carrito FK
           id_producto FK
           cantidad INT
           precio_unitario DECIMAL(10,2)   ← precio en el momento de agregar
           UNIQUE (id_carrito, id_producto) ← permite el UPSERT


MÓDULO ÓRDENES
─────────────────────────────────────────────────────────────────────
 orden
 id_orden PK
 id_usuario FK
 id_direccion FK
 id_metodo_pago FK
 id_tipo_envio FK
 id_estado FK           ← referencia a estado_orden
 total DECIMAL(10,2)
 fecha_orden
      │
      ├──► orden_item
      │    id_orden_item PK
      │    id_orden FK
      │    id_producto FK
      │    cantidad INT
      │    precio_unitario DECIMAL(10,2)   ← precio histórico al momento de compra
      │
      └──► pago
           id_pago PK
           id_orden FK
           monto DECIMAL(10,2)
           referencia VARCHAR
           estado VARCHAR
           fecha


MÓDULO AUDITORÍA
─────────────────────────────────────────────────────────────────────
 auditoria
 id_auditoria PK
 id_usuario FK
 accion VARCHAR         ← qué hizo el usuario
 entidad VARCHAR        ← sobre qué tabla/entidad
 timestamp
 detalle TEXT
```

---

### 3.3 Relaciones clave y por qué existen

| Relación | Tipo | Por qué |
|---|---|---|
| `usuario` → `carrito` | 1:N | Un usuario puede tener múltiples carritos, pero solo uno `ABIERTO` activo |
| `carrito` → `carrito_item` | 1:N | Un carrito tiene muchos productos |
| `carrito_item` UNIQUE `(id_carrito, id_producto)` | constraint | Habilita el `ON CONFLICT DO UPDATE` para sumar cantidad en vez de duplicar |
| `producto` → `imagen` | 1:N | Un producto puede tener varias fotos |
| `producto` ↔ `categoria` | N:N via `producto_categoria` | Un producto puede estar en varias categorías |
| `orden` → `orden_item` | 1:N | Una orden contiene varios productos |
| `orden_item.precio_unitario` | campo histórico | Guarda el precio al momento de compra, independiente de futuros cambios |
| `producto.estado = 'NO_DISPONIBLE'` | soft-delete | No se borra el producto de la DB para preservar el historial de órdenes |

---

### 3.4 Módulos y sus tablas

| Módulo | Tablas |
|---|---|
| Catálogos | `categoria`, `marca`, `tipo_envio`, `estado_orden`, `metodo_pago` |
| Usuarios | `usuario`, `direccion`, `usuario_metodo_pago` |
| Productos | `producto`, `imagen`, `producto_categoria`, `resena` |
| Carrito | `carrito`, `carrito_item` |
| Órdenes | `orden`, `orden_item`, `pago` |
| Auditoría | `auditoria` |

---

### 3.5 Convenciones de la base de datos

| Convención | Ejemplo |
|---|---|
| PKs con prefijo `id_` + nombre tabla | `id_producto`, `id_usuario` |
| FKs con el mismo nombre que la PK referenciada | `id_usuario` en `carrito` apunta a `usuario.id_usuario` |
| Estados como `VARCHAR` con valores en mayúsculas | `'DISPONIBLE'`, `'ABIERTO'`, `'PENDIENTE'` |
| Timestamps de auditoría en todas las tablas principales | `fecha_creacion`, `fecha_actualizacion` |
| Eliminación lógica (soft-delete) en `producto` | `estado = 'NO_DISPONIBLE'` en vez de `DELETE` |
| Precios como `DECIMAL(10,2)` | Precisión monetaria, evita errores de punto flotante |

---

### 3.6 Cómo se instala la base de datos

Los scripts en `backend/database/ddl/` deben ejecutarse en orden:

```
01-create-database.sql   ← crea la DB y el schema ecommerce
02-create-tables.sql     ← crea todas las tablas (sin FK para evitar dependencias circulares)
03-alter-tables.sql      ← agrega todas las foreign keys
04-migrations.sql        ← migraciones posteriores (UNIQUE en carrito_item, etc.)
```

Para Neon DB en producción existe `backend/database/neon-setup.sql` con el script adaptado al entorno serverless.

---

### 3.7 Cómo el backend se comunica con la DB

Archivo: `backend/src/config/db.js`

```
DB_URL (env var)
    │
    ▼
Pool de pg (conexiones reutilizables)
    │
    ├─ pool.on('connect') → SET search_path TO ecommerce, public
    │
    └─ query(text, params)   ← función exportada usada por todos los modelos
              │
              ▼  Queries parametrizadas (previene SQL injection)
         db.query('SELECT * FROM producto WHERE id_producto = $1', [id])
```

Los modelos en `src/models/` **nunca** construyen SQL con concatenación de strings. Siempre usan `$1, $2, ...` como placeholders y pasan los valores como array separado.

---

## 4. Flujo de datos completo


### 3.1 Flujo de lectura pública — "usuario ve el catálogo"

```
index.html
  └─ index.js (DOMContentLoaded)
       └─ api.getProducts()
            └─ fetch GET /api/products         ← sin token (ruta pública)
                 │
                 ▼ Backend: app.js
                 globalLimiter
                 └─ productRouter.get('/')
                      └─ products.controller#getAll()
                           └─ Product.findAll()
                                └─ db.query(SELECT p.*, i.url, c.nombre FROM ecommerce.producto...)
                                     │
                                     ▼ Neon DB devuelve filas
                                └─ retorna array de productos JS
                           └─ res.json({ products: [...] })
                 │
                 ▼ Frontend
            api.js parsea JSON
       └─ index.js renderiza tarjetas en el DOM
```

---

### 3.2 Flujo de autenticación — "usuario hace login"

```
login.html
  └─ auth.js#handleLogin()
       └─ api.login({ email, password })
            └─ fetch POST /api/auth/login
               body: { "email": "...", "password": "..." }
                    │
                    ▼ Backend
                    authLimiter (máx. 5 intentos / 15 min)
                    └─ auth.router.post('/login')
                         └─ auth.controller#login()
                              └─ User.findByEmail(email)
                                   └─ SELECT id, nombre, email, password_hash, rol
                                        FROM ecommerce.usuario WHERE email = $1
                              └─ hash.compare(password, user.password_hash)  ← bcrypt
                              └─ jwt.sign({ id: user.id, role: user.rol })   ← genera token
                              └─ sanitizer.sanitizeUser(user)                ← elimina password_hash
                              └─ res.json({ success: true, data: { token, user } })
                    │
                    ▼ Frontend
            api.js recibe { token, user }
       └─ auth.setSession(token, user)
            └─ localStorage.setItem('token', token)
            └─ localStorage.setItem('user', JSON.stringify(user))
       └─ updateHeaderAuth() → muestra nombre del usuario
```

---

### 3.3 Flujo de ruta protegida — "usuario agrega al carrito"

```
cart.js
  └─ api.addToCart(productId, quantity)
       └─ fetch POST /api/cart
          headers: { Authorization: "Bearer eyJhbGci..." }
          body: { "product_id": 5, "quantity": 2 }
               │
               ▼ Backend pipeline
               globalLimiter
               authenticate.js
                 ├─ extrae token del header Authorization
                 ├─ jwt.verify(token) → decodifica payload { id, role, iat, exp }
                 └─ adjunta req.user = { id: 42, role: "cliente" }
               └─ cart.router.post('/')
                    └─ cart.controller#add()
                         └─ Cart.addItem(req.user.id, product_id, quantity)
                              └─ transacción SQL:
                                 1. busca/crea carrito ABIERTO del usuario
                                 2. consulta precio actual del producto
                                 3. UPSERT en carrito_item (suma cantidad si ya existe)
                         └─ res.json({ item })
               │
               ▼ Frontend
          api.js retorna item guardado
  └─ cart.js actualiza contador del header
```

---

### 3.4 Flujo admin — "admin crea un producto" (doble protección)

```
admin-products.html
  └─ admin.js llama api.createProduct(data)
       └─ fetch POST /api/products
          headers: { Authorization: "Bearer <token-admin>" }
               │
               ▼ Backend: 3 middlewares en cadena
               authenticate.js  → verifica JWT → req.user = { id, role: "admin" }
               authorize('admin') → si role !== "admin" → 403 Forbidden
               └─ products.controller#create()
                    └─ Product.create({ name, description, price, stock, image_url })
                         └─ transacción SQL:
                            BEGIN
                              INSERT INTO ecommerce.producto → retorna id
                              INSERT INTO ecommerce.imagen (si hay image_url)
                            COMMIT  (o ROLLBACK si falla)
                    └─ res.status(201).json({ product })
```

---

### 3.5 Flujo de checkout — "usuario crea una orden"

```
checkout.js
  └─ api.createOrder({ payment_method })
       └─ fetch POST /api/orders/checkout
               │
               ▼ Backend
               orderLimiter (máx. 10 órdenes / hora)
               authenticate.js → req.user
               └─ orders.controller#checkout()
                    1. Cart.findByUser(userId)     ← obtiene items del carrito
                    2. calcula total
                    3. Order.create(userId, items, total)
                         └─ transacción SQL:
                            BEGIN
                              INSERT INTO ecommerce.orden (usuario, total, estado='PENDIENTE')
                              INSERT INTO ecommerce.orden_item por cada item
                            COMMIT
                    4. Cart.clearCart(userId)      ← vacía el carrito
                    └─ res.json({ order })
```

---

## 5. Sistema de autenticación y tokenización (JWT)

### 4.1 ¿Qué es un JWT?

Un **JSON Web Token** tiene 3 partes separadas por puntos, todo en Base64URL:

```
eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9   ← HEADER
.eyJpZCI6NDIsInJvbGUiOiJjbGllbnRlIiwiaWF0IjoxNzEwMDAwMDAwLCJleHAiOjE3MTA2MDQ4MDB9  ← PAYLOAD
.SflKxwRJSMeKKF2QT4fwpMeJf36POk6yJV_adQssw5c  ← SIGNATURE
```

**Decodificado:**

```json
// HEADER
{
  "alg": "HS256",
  "typ": "JWT"
}

// PAYLOAD (lo que guarda este proyecto)
{
  "id": 42,
  "role": "cliente",
  "iat": 1710000000,   ← issued at (cuándo se creó)
  "exp": 1710604800    ← expira en 7 días
}
```

### 4.2 Generación del token

Archivo: `backend/src/utils/jwt.js`

```
jwt.sign(payload, JWT_SECRET, { expiresIn: '7d' })
          │           │
          │           └─ Clave secreta desde env JWT_SECRET
          └─ { id: user.id, role: user.rol }   ← solo lo mínimo necesario
```

El token se firma con **algoritmo HS256** (HMAC-SHA256). Cualquier modificación al payload invalida la firma.

### 4.3 Verificación del token

Archivo: `backend/src/middlewares/authenticate.js`

```
Request entrante
  │
  ├─ ¿Tiene header Authorization?          → NO → 401
  ├─ ¿Formato "Bearer <token>"?            → NO → 401
  ├─ jwt.verify(token, JWT_SECRET)
  │    ├─ Token expirado (TokenExpiredError) → 401 + expiredAt
  │    ├─ Token inválido (JsonWebTokenError) → 401
  │    └─ OK → req.user = { id, role, iat, exp }
  └─ next() → continúa al controller
```

### 4.4 Ciclo de vida del token en el frontend

```
Login/Register exitoso
    │
    ▼
auth.setSession(token, user)
    ├─ localStorage.setItem('token', token)    ← persiste entre pestañas
    └─ localStorage.setItem('user', JSON.stringify(user))

Cada request API
    │
    ▼
auth.getToken() → localStorage.getItem('token')
    └─ headers: { Authorization: `Bearer ${token}` }

Logout
    │
    ▼
auth.logout()
    ├─ localStorage.removeItem('token')
    └─ localStorage.removeItem('user')
```

### 4.5 Hashing de contraseñas (bcrypt)

Las contraseñas **nunca se guardan en texto plano**. Archivo: `backend/src/utils/hash.js`

```
Registro:
  plainPassword  →  bcrypt.hash(password, 12 salt rounds)  →  "$2b$12$..." (guardado en DB)

Login:
  plainPassword + hash_en_DB  →  bcrypt.compare()  →  true / false
```

El número de **salt rounds = 12** hace que cada hash tarde ~250ms, lo que hace los ataques de fuerza bruta computacionalmente costosos.

---

## 6. Formatos JSON de la API

### 5.1 Formato estándar de respuesta

Todas las respuestas siguen el mismo envelope:

```json
// Éxito
{
  "success": true,
  "data": { ... }
}

// Error
{
  "success": false,
  "error": "Mensaje descriptivo del error"
}
```

### 5.2 Auth — Login / Registro

**Request:**
```json
POST /api/auth/login
{
  "email": "usuario@example.com",
  "password": "MiPass123!"
}
```

**Response exitosa (200):**
```json
{
  "success": true,
  "data": {
    "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
    "user": {
      "id": 42,
      "nombre": "Juan Pérez",
      "email": "usuario@example.com",
      "rol": "cliente"
    }
  }
}
```

> `password_hash` es eliminado por `sanitizeUser()` antes de enviarse. Nunca viaja al frontend.

**Response de error (401):**
```json
{
  "success": false,
  "error": "Correo o contraseña incorrectos"
}
```

---

### 5.3 Productos

**GET /api/products — lista de productos:**
```json
{
  "products": [
    {
      "id": 1,
      "name": "Laptop Pro X",
      "description": "Procesador Intel i7...",
      "price": "1299.99",
      "stock": 15,
      "image_url": "https://...",
      "category": "Laptops"
    }
  ]
}
```

**POST /api/products — crear producto (admin):**
```json
// Request
{
  "name": "Laptop Pro X",
  "description": "...",
  "price": 1299.99,
  "stock": 15,
  "image_url": "https://...",
  "brand_id": 1
}

// Response 201
{
  "product": {
    "id": 10,
    "nombre": "Laptop Pro X",
    "descripcion": "...",
    "precio": "1299.99",
    "stock": 15,
    "image_url": "https://..."
  }
}
```

---

### 5.4 Carrito

**GET /api/cart:**
```json
{
  "items": [
    {
      "id": 7,
      "quantity": 2,
      "product_id": 1,
      "name": "Laptop Pro X",
      "price": "1299.99",
      "image_url": "https://...",
      "subtotal": "2599.98"
    }
  ]
}
```

**POST /api/cart — agregar item:**
```json
// Request
{ "product_id": 1, "quantity": 2 }

// Response 200
{
  "item": {
    "id_carrito_item": 7,
    "id_carrito": 3,
    "id_producto": 1,
    "cantidad": 2,
    "precio_unitario": "1299.99"
  }
}
```

---

### 5.5 Órdenes

**GET /api/orders — historial del usuario:**
```json
{
  "orders": [
    {
      "id": 5,
      "status": "PENDIENTE",
      "total": "2599.98",
      "created_at": "2026-04-13T10:30:00.000Z",
      "items": [
        {
          "product_id": 1,
          "quantity": 2,
          "unit_price": "1299.99"
        }
      ]
    }
  ]
}
```

**POST /api/orders/checkout:**
```json
// Request
{ "payment_method": "credit_card" }

// Response 201
{
  "order": {
    "id": 5,
    "total": "2599.98",
    "id_estado": 1,
    "created_at": "2026-04-13T10:30:00.000Z"
  }
}
```

---

### 5.6 Errores de rate limiting

```json
// 429 Too Many Requests
{
  "success": false,
  "error": "Too many login attempts. Please try again after 15 minutes."
}
```

### 5.7 Errores de autorización

```json
// 401 — Sin token
{ "success": false, "error": "Authorization header is required" }

// 401 — Token expirado
{ "success": false, "error": "Token has expired", "expiredAt": "2026-04-10T..." }

// 403 — Rol insuficiente
{ "success": false, "error": "Insufficient permissions to access this resource" }
```

---

## 7. Pipeline de seguridad por request

Cada request que llega al backend pasa por capas en este orden:

```
Request HTTP
    │
    ▼ 1. Helmet
       Agrega headers HTTP de seguridad:
       - Content-Security-Policy
       - X-Frame-Options: DENY
       - Strict-Transport-Security (HSTS)
       - X-Content-Type-Options: nosniff
    │
    ▼ 2. CORS
       Acepta solo orígenes permitidos (variable CORS_ORIGIN)
       Método + headers permitidos configurados en security.js
    │
    ▼ 3. Body Parser
       Limita el tamaño del body a 10mb
    │
    ▼ 4. Global Rate Limiter
       100 requests / 15 min por IP
       (excepto /api/health)
    │
    ▼ 5. Router
       Despacha a la ruta correcta
    │
    ▼ 6. Rate Limiter específico (si aplica)
       - Auth: 5 intentos / 15 min (por email)
       - Register: 100 / hora (por IP)
       - Orders: 10 / hora (por IP)
    │
    ▼ 7. authenticate (si la ruta lo requiere)
       Verifica JWT → extrae req.user
    │
    ▼ 8. authorize('rol') (si la ruta lo requiere)
       Verifica req.user.role
    │
    ▼ 9. Controller
       Lógica de negocio
    │
    ▼ 10. Model
        Query SQL parametrizada (previene SQL injection)
    │
    ▼ 11. sanitizer (antes de responder)
        Elimina password_hash y campos sensibles
    │
    ▼ 12. errorHandler (si hubo error en cualquier paso)
        En producción: mensaje genérico, sin stack traces
        En desarrollo: incluye detalles del error
    │
    ▼ Response JSON
```

---

## 8. Conexión en la nube

### Variables de entorno necesarias

| Variable          | Dónde se usa          | Descripción                                      |
|-------------------|-----------------------|--------------------------------------------------|
| `DB_URL`          | `config/db.js`        | Connection string de Neon DB (PostgreSQL)        |
| `JWT_SECRET`      | `utils/jwt.js`        | Clave para firmar/verificar tokens               |
| `JWT_EXPIRES_IN`  | `utils/jwt.js`        | Duración del token (default: `7d`)               |
| `CORS_ORIGIN`     | `config/security.js`  | URLs del frontend permitidas (separadas por `,`) |
| `PORT`            | `server.js`           | Puerto del servidor (Render lo asigna)           |
| `NODE_ENV`        | `config/security.js`  | `production` o `development`                     |
| `FRONTEND_URL`    | `config/security.js`  | URL del frontend para CSP headers                |

### Detección automática de entorno (frontend)

Archivo: `frontend/js/config.js`

```
¿window.location.hostname === "localhost" o "127.0.0.1"?
    ├─ SÍ → API_URL = "http://localhost:3000/api"
    └─ NO → API_URL = "https://techstore-backend-a4e2.onrender.com/api"
```

Esto permite que el mismo código funcione en local y en producción sin modificar nada.

### Diagrama de servicios en la nube

```
                        Internet
                            │
              ┌─────────────┴──────────────┐
              │                            │
   ┌──────────▼──────────┐     ┌──────────▼──────────┐
   │  Frontend           │     │  Backend             │
   │  (archivos estáticos│     │  Node.js + Express   │
   │   GitHub Pages /    │     │  Render.com          │
   │   cualquier CDN)    │     │  Puerto: asignado    │
   └─────────────────────┘     └──────────┬──────────┘
                                          │ SSL/TLS
                                          │ pg Pool
                                ┌─────────▼──────────┐
                                │  Neon DB            │
                                │  PostgreSQL 15      │
                                │  Schema: ecommerce  │
                                └─────────────────────┘
```

### Pool de conexiones a la base de datos

Archivo: `backend/src/config/db.js`

```javascript
// Se crea UN pool compartido para toda la app
const pool = new Pool({ connectionString: process.env.DB_URL });

// Al conectar cada cliente, setea el schema por defecto
pool.on('connect', client => {
  client.query("SET search_path TO ecommerce, public");
});

// Función de query reutilizable
const query = (text, params) => pool.query(text, params);
```

El pool reutiliza conexiones en lugar de abrir/cerrar una por cada request, lo que hace la app eficiente bajo carga.

### Transacciones en operaciones críticas

Las operaciones que tocan múltiples tablas usan transacciones SQL para garantizar consistencia:

| Operación          | Tablas afectadas                            | Transacción |
|--------------------|---------------------------------------------|-------------|
| Crear producto     | `producto` + `imagen`                       | BEGIN/COMMIT |
| Agregar al carrito | `carrito` (crea si no existe) + `carrito_item` | BEGIN/COMMIT |
| Crear orden        | `orden` + `orden_item` (N filas)            | BEGIN/COMMIT |

Si cualquier INSERT falla dentro de una transacción, se ejecuta **ROLLBACK** y la base de datos queda en el estado anterior.
