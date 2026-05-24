const express = require('express');
const cors = require('cors');
const helmet = require('helmet');
const morgan = require('morgan');

// ─── Middlewares propios ───────────────────────────────────────────────────────
const { errorHandler } = require('./middlewares/error.middleware');
const { notFound }     = require('./middlewares/notFound.middleware');

// ─── Rutas ────────────────────────────────────────────────────────────────────
const routes = require('./routes/index');

// ─── App ──────────────────────────────────────────────────────────────────────
const app = express();

// ─── Seguridad y utilidades ───────────────────────────────────────────────────
app.use(helmet());                          // Headers de seguridad HTTP
app.use(cors({
  origin: process.env.CLIENT_URL || '*',    // Cambia '*' por tu dominio en producción
  methods: ['GET', 'POST', 'PUT', 'DELETE', 'PATCH'],
  allowedHeaders: ['Content-Type', 'Authorization'],
}));

// ─── Parsers ──────────────────────────────────────────────────────────────────
app.use(express.json());                    // Parsea body JSON
app.use(express.urlencoded({ extended: true })); // Parsea body form-urlencoded

// ─── Logger ───────────────────────────────────────────────────────────────────
if (process.env.NODE_ENV !== 'production') {
  app.use(morgan('dev'));                   // Logs en consola solo en desarrollo
}

// ─── Health check ─────────────────────────────────────────────────────────────
app.get('/health', (req, res) => {
  res.status(200).json({
    status: 'ok',
    app: 'Gravity Tech API',
    env: process.env.NODE_ENV || 'development',
    timestamp: new Date().toISOString(),
  });
});

// ─── Rutas principales ────────────────────────────────────────────────────────
app.use('/api', routes);

// ─── Manejo de rutas no encontradas (404) ────────────────────────────────────
app.use(notFound);

// ─── Manejo global de errores ─────────────────────────────────────────────────
app.use(errorHandler);

module.exports = app;