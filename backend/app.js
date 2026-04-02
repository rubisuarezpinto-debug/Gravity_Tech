const express = require('express');
const cors = require('cors');
const errorHandler = require('./src/middlewares/errorHandler');

// Routes
const authRoutes = require('./src/routes/auth.routes');
const productRoutes = require('./src/routes/products.routes');
const cartRoutes = require('./src/routes/cart.routes');
const orderRoutes = require('./src/routes/orders.routes');
const adminRoutes = require('./src/routes/admin.routes');

const app = express();

// ─── Global Middlewares ────────────────────────────────────────────────────────
app.use(cors());
app.use(express.json());
app.use(express.urlencoded({ extended: true }));

// ─── Routes ───────────────────────────────────────────────────────────────────
app.use('/api/auth', authRoutes);
app.use('/api/products', productRoutes);
app.use('/api/cart', cartRoutes);
app.use('/api/orders', orderRoutes);
app.use('/api/admin', adminRoutes);

// ─── Health check ─────────────────────────────────────────────────────────────
app.get('/api/health', (_req, res) => {
  res.json({ status: 'ok', timestamp: new Date().toISOString() });
});

// ─── Global Error Handler ─────────────────────────────────────────────────────
app.use(errorHandler);

module.exports = app;
