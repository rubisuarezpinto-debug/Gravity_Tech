# Documentación Técnica: Gravity_Tech 🚀

Gravity_Tech es una plataforma de tienda virtual construida bajo el patrón arquitectónico de **Corto Plazo / MVC Simplificado** orientado al ámbito académico.

## 1. Stack Tecnológico

- **Frontend:** HTML5 Semántico, CSS3 Vainilla (Variables y utilitarios genéricos), JavaScript ES6+ (Fetch API). Todo 100% nativo y sin frameworks.
- **Backend:** Node.js, Express.js.
- **Base de Datos:** PostgreSQL (acceso directo mediante librería `pg`).
- **Autenticación:** JWT (JSON Web Tokens).

## 2. Diagrama de Arquitectura (Patrón Capas Simplificado)

El flujo de control sigue este camino estricto para cada petición:

`Cliente (Frontend JS)` ➡️ `Express (Rutas)` ➡️ `Controladores` ➡️ `Modelos (SQL Directo)` ➡️ `PostgreSQL`

```mermaid
graph TD
    A[Frontend: UI / JS Vainilla] -->|Fetch API / HTTPS| B(Backend: Rutas Express)
    B -->|Llama a función HTTP| C(Controlador: Validación de Request)
    C -->|Pide ejecutar consultas| D(Modelo: Módulo pg)
    D -->|Query SQL| E[(PostgreSQL)]
    E -->|Filas de Tabla| D
    D -->|Objeto JavaScript| C
    C -->|Envía a cliente JSON| A
```

## 3. Estructura del Código

### Backend
- `/src/routers/`: Entradas de la API (Endpoints RESTful protegidos y públicos).
- `/src/controllers/`: Funciones principales para el flujo lógico HTTP (`req` y `res`).
- `/src/models/`: Interacción exclusiva con PostgreSQL (Sentencias `SELECT`, `INSERT`, `UPDATE`).
- `/src/middlewares/`: Funciones interceptoras. `authenticate.js` verifica si un usuario tiene un JWT válido y `authorize.js` define políticas de control de acceso basados en Roles (Ej: bloquear una vista si no es admin).
- `/src/config/db.js`: Establecimiento del *Pool de Conexiones* hacia la BD.

### Frontend
- `/pages/`: Vistas de usuario.
- `/css/`: Sistema de diseño. `variables.css` sirve como token manager global (colores, fuentes) y `main.css` aplica los reset y componentes UI reutilizables (Botones, formularios).
- `/js/`:
  - `api.js`: Concentrador central de todas las peticiones `fetch`. Inserta automáticamente el Bearer Token en cada solicitud.
  - `auth.js`: Wrapper de seguridad del lado del Storage (`localStorage`) para login/logout automático.
  - `cart.js`: Lógica del carrito de compras offline-first.
  - `utils.js`: Helpers transversales (Moneda, alertas).

## 4. Diseño de Endpoints de la API

| Endpoint | Método | Privacidad | Descripción |
|----------|--------|------------|-------------|
| `/api/auth/register` | `POST` | Público | Registro de usuarios (Hasheando pass con bcrypt) |
| `/api/auth/login` | `POST` | Público | Autenticación y expedición de JWT |
| `/api/products` | `GET` | Público | Lista catálogo de productos activos |
| `/api/products/:id` | `GET` | Público | Detalle de producto individual |
| `/api/cart` | `GET/POST/PUT` | Protegido (Comprador) | Gestión y CRUD del carrito vinculado al UserID |
| `/api/orders` | `GET` | Protegido (Comprador) | Historial de compras |
| `/api/orders/checkout` | `POST` | Protegido (Comprador) | Toma el contenido del cart.js, liquida y genera una Orden en BD |
| `/api/admin/users` | `GET` | Protegido (Solo Admin) | Lista todos los clientes registrados |
| `/api/admin/orders` | `GET/PATCH` | Protegido (Solo Admin) | Administra despachos y cancelaciones |

## 5. Variables de Entorno (.env)

El archivo `.env` del backend requiere 3 configuraciones base de supervivencia:
- `PORT`: Puerto (Automáticamente 3000).
- `JWT_SECRET`: Llave asimétrica para firma del token.
- `DB_URL`: Protocolo PostgreSQL (postgres://user:password@localhost:5432/dbname).
