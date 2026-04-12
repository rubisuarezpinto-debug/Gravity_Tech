# Registro de Cambios — Gravity Tech TechStore

Este documento describe en lenguaje natural todos los cambios realizados en esta sesión de trabajo.
Su propósito es que cualquier miembro del equipo entienda **qué se cambió**, **por qué estaba roto** y **cómo quedó**.

---

## Resumen general

Se corrigieron errores críticos que impedían que la aplicación funcionara, se alineó el backend con la base de datos, se conectaron funcionalidades que estaban desconectadas del servidor y se hicieron pequeñas mejoras visuales sin alterar la identidad de la tienda.

---

## Errores críticos corregidos

### 1. Conflictos de merge sin resolver en `checkout.js`

**Qué estaba mal:** El archivo tenía marcadores de conflicto de Git (`<<<<<<< HEAD`, `=======`, `>>>>>>>`) sin resolver. Eso es código inválido — el navegador no puede ejecutar el archivo, así que el checkout estaba completamente roto para todos los usuarios.

**Qué se hizo:**
- En la función `openCheckout`, se conservó la versión que valida si el usuario está logueado antes de abrir el modal. Si no hay sesión activa, redirige al login. Esto es el comportamiento correcto.
- Para mostrar el precio total, se usa `formatPrice()` (la función centralizada de `utils.js`) en lugar de duplicar el formato a mano.

**Archivo:** `frontend/js/checkout.js`

---

### 2. Conflictos de merge sin resolver en `ordersAdmin.js`

**Qué estaba mal:** Mismo problema — marcadores de conflicto en múltiples lugares del archivo. El panel de órdenes del administrador no cargaba.

**Qué se hizo:**
- Se unificó el archivo tomando lo mejor de ambas ramas: la función `closeOrdersPanel` ahora funciona tanto cuando el panel está como modal (en `admin-products.html`) como cuando es una página dedicada (`admin-orders.html`).
- Se corrigió el filtro de búsqueda por email: antes usaba `o.user?.email` (un campo anidado que no existe en la respuesta del backend), ahora usa correctamente `o.user_email` que es lo que el servidor devuelve.
- Se muestran correctamente el nombre y el email del cliente en cada tarjeta de orden, usando los campos planos `order.user_name` y `order.user_email`.
- Se usa `formatPrice()` para todos los totales y subtotales.

**Archivo:** `frontend/js/ordersAdmin.js`

---

### 3. Función `formatPrice` duplicada en `cart.js`

**Qué estaba mal:** Existían dos versiones de `formatPrice` — una en `utils.js` (sincrónica, correcta) y otra en `cart.js` (asíncrona, incorrecta). La versión de `cart.js` sobreescribía la de `utils.js` porque se cargaba después. Como era `async`, al llamarla devolvía una Promesa en lugar de un texto, y los precios en el carrito aparecían como `[object Promise]` en lugar del valor real.

**Qué se hizo:** Se eliminó la función duplicada de `cart.js`. Toda la aplicación usa la versión centralizada de `utils.js`.

**Archivo:** `frontend/js/cart.js`

---

### 4. Rutas de scripts rotas en `product.html`

**Qué estaba mal:** Los scripts se cargaban con rutas `../js/archivo.js`, pero `product.html` está en la carpeta `frontend/` al mismo nivel que la carpeta `js/`. La ruta correcta es `js/archivo.js`. El error hacía que la página de detalle de producto no cargara ningún script y estuviera completamente sin funcionalidad.

**Qué se hizo:** Se corrigieron todas las rutas de `../js/` a `js/`. También se corrigió el orden de carga: `auth.js` ahora se carga antes que `api.js` porque `api.js` necesita `window.auth` para funcionar.

**Archivo:** `frontend/product.html`

---

### 5. Cart sidebar y checkout modal faltantes en `index.html`

**Qué estaba mal:** `index.html` cargaba `cart.js` y `checkout.js`, pero no tenía el HTML del carrito lateral (sidebar) ni del modal de checkout. Cuando un usuario hacía clic en "Agregar al carrito" o "Finalizar Compra", el JavaScript intentaba encontrar elementos HTML que no existían, así que no pasaba nada visible.

**Qué se hizo:** Se añadió el HTML completo del sidebar del carrito y del modal de checkout en `index.html`, copiando la misma estructura que ya existía y funcionaba en `product.html`.

**Archivo:** `frontend/index.html`

---

### 6. Orden de carga de scripts incorrecto en `index.html`

**Qué estaba mal:** `api.js` se cargaba antes que `auth.js`, pero `api.js` usa `window.auth` para obtener el token JWT en cada petición. Si `auth.js` no se ha ejecutado primero, `auth` no existe y las llamadas al servidor fallaban.

**Qué se hizo:** Se reordenaron los scripts: `utils.js` → `auth.js` → `api.js` → `cart.js` → `checkout.js` → `index.js`.

**Archivo:** `frontend/index.html`

---

## Mejoras de integridad backend-base de datos

### 7. El panel admin de órdenes no mostraba los productos de cada orden

**Qué estaba mal:** El endpoint `GET /api/admin/orders` devolvía solo los datos de la orden (total, fecha, cliente) pero **no los productos** que compró el cliente. El frontend esperaba esa información para mostrar la sección "Productos" dentro de cada tarjeta de orden.

**Qué se hizo:** Se modificó la consulta SQL del endpoint para hacer un JOIN con las tablas `ecommerce.orden_item` y `ecommerce.producto`, y devolver los items como una lista JSON con nombre, cantidad y precio unitario. Si una orden no tiene items, devuelve una lista vacía `[]` en lugar de nulo.

**Archivos:** `backend/src/controllers/admin.controller.js`

---

### 8. Constraint UNIQUE faltante en `carrito_item`

**Qué estaba mal:** El modelo `Cart.js` usa una instrucción SQL `ON CONFLICT (id_carrito, id_producto)` para hacer "upsert" (insertar o actualizar la cantidad si el producto ya estaba en el carrito). Pero esa instrucción requiere que exista una restricción UNIQUE en esas dos columnas, y el DDL original no la tenía. En producción esto causa un error de base de datos cada vez que se intenta agregar un producto que ya está en el carrito.

**Qué se hizo:** Se creó el archivo `backend/database/ddl/04-migrations.sql` con el script para agregar esa restricción de forma segura. **Debe ejecutarse manualmente una vez en la base de datos.**

> ⚠️ **Antes de ejecutar:** Si ya existen filas duplicadas en `carrito_item` (mismo carrito + mismo producto), hay que limpiarlas primero. El script incluye el comando para hacerlo como comentario.

**Archivo nuevo:** `backend/database/ddl/04-migrations.sql`

---

### 9. Categorías de productos no llegaban al frontend

**Qué estaba mal:** La consulta `findAll` de `Product.js` no incluía la categoría del producto. El frontend tenía un selector de filtro por categoría ("Computadores", "Celulares", etc.) pero los productos no traían ese dato, así que el filtro nunca podía funcionar.

**Qué se hizo:** Se agregó un JOIN con las tablas `ecommerce.producto_categoria` y `ecommerce.categoria` para incluir el nombre de la primera categoría del producto como campo `category` en cada resultado.

**Archivo:** `backend/src/models/Product.js`

---

## Conectividad frontend-backend

### 10. Filtro de categoría no estaba conectado

**Qué estaba mal:** El `<select id="filter-category">` en `index.html` existía visualmente pero el JavaScript de `index.js` nunca leía su valor. Seleccionar "Computadores" o cualquier otra categoría no hacía nada.

**Qué se hizo:** Se agregó la lógica de filtrado por categoría en `loadProducts`, y se agregó un listener al selector para que al cambiar de categoría los productos se filtren automáticamente. El filtro compara el campo `category` que ahora devuelve el backend.

**Archivo:** `frontend/js/index.js`

---

## Retoques visuales (sin cambiar identidad de la tienda)

### 11. Descripciones largas desalineaban el grid

**Qué estaba mal:** Productos con descripciones muy largas hacían que las tarjetas tuvieran alturas diferentes, rompiendo la alineación del grid.

**Qué se hizo:** Se limitó la descripción a 3 líneas con `line-clamp`. Si el texto es más largo se corta con `...`. El diseño y colores no cambiaron.

**Archivo:** `frontend/css/main.css`

---

### 12. Badge de stock sin indicador visual de urgencia

**Qué se hizo:** El badge de "X disponibles" ahora cambia de color según el nivel de stock:
- **Rojo**: menos de 5 unidades (stock crítico).
- **Amarillo/naranja**: entre 5 y 19 unidades (stock bajo).
- **Color normal** (azul del tema): 20 o más unidades.

Esto da información útil al usuario sin modificar el look general de la tienda.

**Archivos:** `frontend/js/index.js`, `frontend/css/main.css`

---

### 13. Tarjetas de producto aparecían de golpe al cargar

**Qué se hizo:** Se agregó una animación suave `fadeInUp` (0.3s) a las tarjetas de producto. Aparecen deslizándose ligeramente desde abajo con un fade. Es sutil y no altera el diseño.

**Archivo:** `frontend/css/main.css`

---

## Archivos que NO deben subirse al repositorio

- `.env` — contiene credenciales de base de datos y el secreto JWT. Verificar que esté en `.gitignore`.
- La carpeta `backend/database/schema/` contiene un esquema alternativo en inglés que ya no se usa. Se recomienda eliminarlo o moverlo a una carpeta `_deprecated/` para evitar confusión.

---

---

## Correcciones adicionales (segunda ronda)

### 14. Opciones del filtro de categoría no coincidían con la base de datos

**Qué estaba mal:** El `<select>` de categoría en `index.html` tenía opciones "Computadores", "Celulares", "Accesorios", "Videojuegos", pero las categorías reales en la tabla `ecommerce.categoria` son: Tecnología, Calzado, Ropa, Deportes, Hogar, Accesorios, Libros. Por eso al seleccionar cualquier categoría no aparecía ningún producto.

**Qué se hizo:** Se reemplazaron las opciones del select por los nombres exactos de las categorías en la BD.

**Archivo:** `frontend/index.html`

---

### 15. Las tarjetas de producto no navegaban al detalle del producto

**Qué estaba mal:** Al hacer clic en la imagen o el nombre de un producto en la página principal no pasaba nada. Solo funcionaba el botón "Agregar al carrito". La página `product.html` existía y funcionaba, pero nunca se llegaba a ella.

**Qué se hizo:** Se envolvió la imagen, título y descripción de cada tarjeta con un `<a href="product.html?id=X">`. Ahora al hacer clic en esas áreas se navega al detalle del producto. El botón "Agregar al carrito" quedó fuera del enlace para que siga funcionando independientemente.

**Archivos:** `frontend/js/index.js`, `frontend/css/main.css`

---

---

## Correcciones adicionales (tercera ronda)

### 16. Las opciones del filtro de categoría no coinciden con la base de datos

**Situación actual:** El selector de categoría en la página principal tiene las opciones "Computadores", "Celulares", "Accesorios" y "Videojuegos". Sin embargo, las categorías que realmente existen en la base de datos son: Tecnología, Calzado, Ropa, Deportes, Hogar, Accesorios y Libros. Por eso al seleccionar cualquier opción (excepto "Accesorios") no aparece ningún producto.

**Qué se intentó:** Se cambiaron temporalmente las opciones del select para que coincidieran con los nombres reales de la BD, pero el equipo decidió revertir ese cambio y mantener los nombres originales.

**Decisión pendiente para el equipo:** Hay dos caminos posibles y el equipo debe elegir uno:
- **Opción A** — Cambiar las opciones del select en `index.html` para que digan "Tecnología", "Calzado", "Ropa", etc. (los nombres reales de la BD).
- **Opción B** — Actualizar los registros en la tabla `ecommerce.categoria` de la base de datos para que los nombres sean "Computadores", "Celulares", etc. (los nombres que el equipo quiere mostrar).

Mientras no se tome esa decisión, el filtro de categoría no va a funcionar (siempre mostrará "no se encontraron productos" al seleccionar cualquier opción).

**Archivo involucrado:** `frontend/index.html` (selector `#filter-category`)

---

### 17. Al hacer clic en un producto no se veía el detalle

**Qué estaba mal:** Las tarjetas de producto en la página principal no tenían ningún enlace. Al hacer clic en la imagen o el nombre del producto no pasaba nada. La página `product.html` existía y funcionaba correctamente, pero no había forma de llegar a ella desde las tarjetas.

Además, si alguien llegaba a `product.html` directamente desde la barra del navegador sin poner `?id=` en la URL (por ejemplo `localhost:5000/product.html` en vez de `localhost:5000/product.html?id=1`), la página siempre mostraba "Producto no encontrado" porque el JavaScript no sabía qué producto cargar.

**Qué se hizo:** Se envolvió la imagen, el nombre y la descripción de cada tarjeta con un enlace `<a href="product.html?id=X">` donde X es el ID del producto. Ahora al hacer clic en esas áreas el navegador va correctamente a la página de detalle con el ID en la URL. El botón "Agregar al carrito" quedó fuera del enlace para que siga funcionando de forma independiente.

**Archivos:** `frontend/js/index.js`, `frontend/css/main.css`

---

---

## Correcciones adicionales (cuarta ronda)

### 18. El detalle del producto seguía mostrando "Producto no encontrado" al hacer clic

**Qué estaba mal:** El servidor que sirve el frontend (Live Server en VS Code, puerto 5000) tiene un comportamiento particular: cuando recibe una petición a `product.html?id=1`, hace una redirección interna a `/product` pero en ese proceso **pierde el parámetro `?id=1`** de la URL. Como resultado, la página de detalle llegaba sin saber qué producto mostrar.

**Qué se hizo:** Se cambió el enlace en las tarjetas de producto para que apunte a `product?id=X` en lugar de `product.html?id=X`. Al no tener la extensión `.html`, el servidor no hace ninguna redirección y el parámetro `?id=` llega intacto a la página.

**Archivo:** `frontend/js/index.js`

---

### 19. La búsqueda por nombre no mostraba resultados

**Qué estaba mal:** Si el usuario escribía el nombre del producto con un espacio al inicio o al final (por ejemplo `" Laptop"`), la comparación fallaba porque se buscaba `" laptop"` (con espacio) dentro de `"laptop pro 15"` y no coincidía. Además, no había soporte para buscar presionando Enter, lo cual es el comportamiento natural que espera un usuario.

**Qué se hizo:**
- Se agregó `.trim()` al texto de búsqueda antes de comparar, para ignorar espacios accidentales al inicio o al final.
- Se agregó soporte para la tecla Enter en el campo de búsqueda, de manera que presionar Enter tiene el mismo efecto que hacer clic en el botón "Buscar".

**Archivo:** `frontend/js/index.js`

---

---

## Correcciones adicionales (quinta ronda)

### 20. El navegador seguía mostrando la versión vieja de los scripts (caché)

**Qué estaba mal:** Los navegadores guardan una copia local de los archivos JavaScript para cargar las páginas más rápido. Cuando se hacen cambios al código, el navegador puede seguir usando la copia vieja sin darse cuenta de que hubo actualizaciones. Esto causaba que las correcciones aplicadas (como el enlace al detalle del producto) no tuvieran efecto aunque el código en disco estuviera correcto.

**Qué se hizo:** Se agregó `?v=2` al final de cada etiqueta `<script>` en `index.html` y `product.html`. Esto le indica al navegador que los archivos cambiaron y que debe descargar versiones frescas en lugar de usar las que tiene guardadas. Es como ponerle una etiqueta nueva a un producto para que el sistema lo reconozca como diferente.

> Nota para el equipo: cada vez que se hagan cambios importantes a los scripts JS, conviene incrementar este número (`?v=3`, `?v=4`, etc.) para forzar que todos los usuarios reciban la versión actualizada.

**Archivos:** `frontend/index.html`, `frontend/product.html`

---

---

## Correcciones adicionales (sexta ronda)

### 21. La página de inicio de sesión se veía sin estilo (formulario estirado a todo el ancho)

**Qué estaba mal:** El HTML de `login.html` y `register.html` usaba las clases `.auth-page-container` y `.auth-card` para estructurar el formulario, pero esas clases no tenían ningún CSS definido. Por eso el formulario aparecía pegado al borde izquierdo, sin tarjeta, sin centrado y sin ningún estilo visual — se veía como texto plano sobre fondo oscuro.

**Qué se hizo:** Se agregaron los estilos faltantes en `auth.css`:
- `.auth-page-container` — centra la tarjeta vertical y horizontalmente en la pantalla.
- `.auth-card` — le da al formulario la apariencia de tarjeta oscura con borde sutil, sombra profunda y una pequeña línea de acento en color cyan en la parte superior, coherente con el estilo del resto de la tienda.

El cambio aplica automáticamente a `login.html` y `register.html` ya que ambas usan las mismas clases.

**Archivo:** `frontend/css/auth.css`

---

---

## Correcciones adicionales (séptima ronda)

### 22. Los mensajes de error aparecían en inglés o como códigos técnicos ("Error 401")

**Qué estaba mal:** Cuando algo fallaba (contraseña incorrecta, correo ya registrado, sesión expirada, etc.) los mensajes que veía el usuario eran en inglés o simplemente decían "Error 401", "Error 403", que no le dicen nada útil a alguien que no conoce los códigos HTTP.

Había tres problemas combinados:

1. **El backend enviaba textos en inglés** — el controlador de autenticación devolvía mensajes como "Email is already registered" o "Invalid email or password".
2. **El manejador global de errores también tenía mensajes en inglés** — cuando ocurre un error del servidor, el código de respaldo decía cosas como "Bad request", "Unauthorized", "Forbidden".
3. **El frontend leía el campo equivocado** — el backend envía el mensaje de error dentro del campo `error`, pero `api.js` buscaba el campo `message`. Al no encontrarlo, mostraba "Error 401" en lugar del mensaje real.

**Qué se hizo:**

- En `backend/src/controllers/auth.controller.js` se tradujeron los mensajes de error a español natural:
  - "Email is already registered" → "Este correo ya está registrado"
  - "Invalid email or password" → "Correo o contraseña incorrectos"
  - "User not found" → "Usuario no encontrado"

- En `backend/src/middlewares/errorHandler.js` se tradujo el mapa de mensajes de reserva:
  - 400 → "Solicitud inválida"
  - 401 → "No autorizado. Por favor inicia sesión"
  - 403 → "No tienes permiso para realizar esta acción"
  - 404 → "El recurso solicitado no existe"
  - 409 → "Ya existe un registro con esos datos"
  - 422 → "Los datos enviados no son válidos"
  - 500 → "Ocurrió un error en el servidor. Intenta nuevamente"

- En `frontend/js/api.js` se corrigió que lea el campo correcto de la respuesta:
  - Antes: `err.message` (siempre vacío porque el backend no manda ese campo)
  - Ahora: `err.error || err.message || 'Ocurrió un error. Intenta nuevamente'`
  - Con esto, el mensaje real del servidor (ya en español) llega al usuario correctamente.

**Archivos:** `backend/src/controllers/auth.controller.js`, `backend/src/middlewares/errorHandler.js`, `frontend/js/api.js`

---

## Cosas pendientes (para próximas sesiones)

- Conectar las reseñas en `product.html` con el endpoint real `GET /api/reviews/product/:id` (el endpoint existe pero el frontend no lo llama, siempre muestra vacío).
- Revisar y limpiar las páginas `cart.html`, `checkout.html` y `admin.html` que están vacías (solo tienen comentarios).
- Agregar el campo de marca ("Marca") en el formulario de `admin-products.html` — el JavaScript lo busca pero el elemento no existe en el HTML.
- Ejecutar el script `04-migrations.sql` en la base de datos de producción.
- Rotar el password de la base de datos y el secreto JWT si el `.env` fue versionado en Git.

---

---

## Correcciones adicionales (octava ronda)

### 23. Conflicto de merge sin resolver en `admin.css`

**Qué estaba mal:** El archivo `frontend/css/admin.css` tenía marcadores de
conflicto de Git (`<<<<<<< HEAD`, `=======`, `>>>>>>> origin/dev_Danna`) sin
resolver. Esto hacía que el CSS fuera inválido y el botón de imagen en el
panel de administrador no tuviera ningún estilo aplicado.

**Qué se hizo:** Se conservó la versión de `dev_Danna` que agrega los estilos
del botón `.btn-item-img` (botón azul para actualizar la imagen de un
producto), ya que `admin.js` lo usa y sin el estilo el botón aparecía sin
formato. Se eliminaron los marcadores de conflicto.

**Archivo:** `frontend/css/admin.css`

---

### 24. Las reseñas en product.html no llamaban al backend

**Qué estaba mal:** La función `loadReviews` usaba `product.reviews || []`
pero el endpoint `GET /api/reviews/product/:id` existe y nunca se llamaba.
La sección siempre mostraba "Este producto aún no tiene reseñas".

**Qué se hizo:** Se reemplazó la línea por una llamada real a
`api.getReviews(productId)` y se usa el promedio calculado por el backend
(`stats.promedio`) en lugar de calcularlo manualmente en el frontend.

**Archivo:** `frontend/product.html`

### 25. Campo de marca faltante en formulario de administrador

**Qué estaba mal:** `admin.js` buscaba `document.getElementById('admin-brand')`
pero el formulario en `admin-products.html` no tenía ese campo. Esto causaba
un error silencioso al crear o editar productos.

**Qué se hizo:** Se agregó el campo `<select id="admin-brand">` con las marcas
reales de la base de datos (Sony, Nike, Samsung, Apple, Adidas, Logitech,
Xiaomi, LG). También se corrigieron las opciones de categoría para que
coincidan con los nombres reales en la tabla `ecommerce.categoria`.

**Archivo:** `frontend/admin-products.html`

*Última actualización: 12 de abril de 2026*
