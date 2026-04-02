# Backlog del Proyecto: Gravity_Tech

Este documento consolida las tareas y épicas restantes (Backlog) necesarias para que la solución pase del estado actual ("Andamiaje y Estructura Mínima") a ser completamente operativa.

## Épica 1: Base de Datos 🛢️
- `[ ]` **Instalación:** Levantar motor PostgreSQL localmente o mediante contenedor Docker.
- `[ ]` **Diseño de Esquema (Schema):** Modelar y escribir el script `schema.sql` que cree las tablas: `users`, `products`, `cart_items`, `orders`, `order_items` y `payments`.
- `[ ]` **Restricciones:** Configurar correctamente Foreign Keys (Ej: `order_items` -> `products`), y el uso de transacciones con `BEGIN` y `COMMIT` asegurando integridad ACID.
- `[ ]` **Seeders:** Insertar datos falsos iniciales para testear. Crear al menos un usuario administrador, dos clientes y cinco productos en el catálogo inicial.

## Épica 2: Desarrollo Frontend e Interfaces Dinámicas 🎨
- `[ ]` **Maquetación CSS:** Crear un estilo base "Premium" sin Tailwind en `main.css` y la declaración estructurada global de la tipografía/colores en `variables.css`.
- `[ ]` **Home / Catálogo (`index.html`):** Desarrollar grillas de productos, menú superior de navegación estático. Incluir botón en el encabezado dinámico para `Login` o `Logout`.
- `[ ]` **Vista Producto (`product.html`):** Diseño de tarjeta aumentada de detalles físicos, carrusel de imágenes, inputs para asignar cantidades e inyectores DOM.
- `[ ]` **Páginas de Sesión (`login/register`):** Formularios seguros con validación en frontend y redireccionamientos basados en comprobantes de JWT validados a través de `api.js` y protegidos por método `auth.setSession()`.
- `[ ]` **Checkout Flow (`cart`/`checkout`):** Desarrollar panel deslizable o una landing completa para revisar pedido, ingresar información de envío y método de tarjeta simulado. 

## Épica 3: Integración de API (Ligazón) 🔗
- `[ ]` **Conexión de Promesas:** Reemplazar el Mocking data del frontend invocando `api.getProducts()` e iterando en el DOM el mapeo JSON.
- `[ ]` **Manejo de Errores UX:** Vincular las alertas `utils.showAlert()` del DOM a las respuestas 4xx o 5xx provenientes del `catch()` de nuestra API. Validar los mensajes con colores según la alerta (`danger` para password rechazadas).
- `[ ]` **Seguridad Frontend:** Añadir `auth.requireAuth()` y `auth.requireAdmin()` a las vistas protegidas para re-enrutar intrusos.

## Épica 4: Pruebas y Bugfixing 🐛
- `[ ]` Prevenir duplicación en base de datos en endpoints `register` o inyecciones SQL imprevistas.
- `[ ]` Validar limpieza de estado Storage en el checkout (vaciado de carrito una vez finalizada y confirmada su transacción respectiva para pasarlo del array a un log histórico).
- `[ ]` Verificar los status dinámicos de las solicitudes (del `PENDIENTE` predeterminado a un `PAGADO` procesado).

## Épica 5 (Largo Plazo Opcional basado en la doc extraída):
- `[ ]` Refactorización: Mover la lógica del backend fuera de los Controladores a una capa de "Services".
- `[ ]` Implementación del ORM Sequelize en vez del módulo PostgreSQL directo.
- `[ ]` Dockerización de la plataforma y migración de Assets y Servidor usando arquitectura con `Nginx`.
