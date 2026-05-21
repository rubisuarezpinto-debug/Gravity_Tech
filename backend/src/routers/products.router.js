const express = require('express');
const router = express.Router();
const productoController = require('../controllers/products.controller');

// ── RUTAS CLIENTE ──
// Esta ruta responde a GET /api/products/
router.get('/', productoController.listarCatalogo);
router.get('/categorias', productoController.obtenerCategorias);

// ── RUTAS EMPLEADO (CRUD Inventario) ──
router.post('/crear', productoController.registrarProducto);
router.put('/actualizar/:id', productoController.actualizarProducto);
router.delete('/eliminar/:id', productoController.eliminarProducto);

module.exports = router;