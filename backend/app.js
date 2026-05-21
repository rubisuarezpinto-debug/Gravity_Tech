const express = require('express');
const cors = require('cors');


// ── 1. INICIALIZACIÓN DE LA APLICACIÓN ──
const app = express();

// ── 2. MIDDLEWARES GLOBALES ──
// ── 2. MIDDLEWARES GLOBALES ──
app.use(cors({
    origin: '*', // Esto permite que Flutter Web desde Edge se conecte sin bloqueos
    credentials: true,
    methods: ['GET', 'POST', 'PUT', 'DELETE', 'OPTIONS'],
    credentials: true,
    allowedHeaders: ['Origin', 'X-Requested-With', 'Content-Type', 'Accept', 'Authorization']
}));

app.use(express.json()); 
app.use(express.urlencoded({ extended: true }));

// ── 3. IMPORTACIÓN DE ENRUTADORES ──
const authRouter = require('./src/routers/auth.router.js');
const productoRouter = require('./src/routers/products.router.js');
const adminRouter = require('./src/routers/admin.router.js');
const cartRouter = require('./src/routers/cart.router.js');
const ordersRouter = require('./src/routers/orders.router.js');

// ── 4. MONTAJE DE LAS RUTAS GLOBALES ──
app.use('/api/auth', authRouter);
app.use('/api/products', productoRouter);
app.use('/api/admin', adminRouter);
app.use('/api/cart', cartRouter);
app.use('/api/orders', ordersRouter);

// ── 5. MIDDLEWARE DE MANEJO DE ERRORES GLOBAL ──
app.use((err, req, res, next) => {
    console.error('[Error Servidor]:', err.message);
    res.status(err.status || 500).json({
        b_exito: false,
        v_mensaje: err.message || 'Error interno del servidor en Gravity Tech.'
    });
});

// ── 6. EXPORTAR VARIABLE APP PARA SERVER.JS ──
module.exports = app; // CORREGIDO: Se eliminó la línea fantasma de router
// Asegúrate de que esta línea exista y esté configurada:

//const productRoutes = require('./routes/product.routes');
//app.use('/api', productRoutes); // Esto hace que todo lo que esté en product.routes empiece por /api