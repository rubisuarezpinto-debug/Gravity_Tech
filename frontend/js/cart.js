/**
 * =========================================================
 * cart.js — Lógica de UI del carrito de compras
 * =========================================================
 *
 * DESCRIPCIÓN:
 *   Este archivo gestiona la lógica en el cliente para representar
 *   los items del carrito.
 *   
 * LO QUE DEBE CONTENER:
 *   1. Lógica para renderizar los items que retorna api.getCart() en el DOM
 *      de las páginas index.html, product.html, y sobretodo cart.html.
 *   2. Funciones para manejar eventos de clicks en botones como "Agregar",
 *      "+", "-" (modificar cantidad) o "Eliminar item".
 *   3. En cada acción de UI, llamar a la función correspondiente de `api.js`
 *      (ej. api.addToCart(), api.updateCartItem(), etc.) para que el 
 *      servidor registre el cambio persistentemente en la Base de Datos.
 *   4. Actualizar dinámicamente un contador de carrito global (ej. en el header)
 *      tras cada operación.
 */
