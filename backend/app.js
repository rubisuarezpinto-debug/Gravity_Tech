const express = require('express');
const cors = require('cors');
const errorHandler = require('./src/middlewares/errorHandler');

// Routers
const authRouter = require('./src/routers/auth.router');
const productRouter = require('./src/routers/products.router');
const cartRouter = require('./src/routers/cart.router');
const orderRouter = require('./src/routers/orders.router');
const adminRouter = require('./src/routers/admin.router');
const reviewRouter = require('./src/routers/reviews.router');

const app = express();

// ─── Global Middlewares ────────────────────────────────────────────────────────
app.use(cors());
app.use(express.json());
app.use(express.urlencoded({ extended: true }));

// ─── Routers ───────────────────────────────────────────────────────────────────
app.use('/api/auth', authRouter);
app.use('/api/products', productRouter);
app.use('/api/cart', cartRouter);
app.use('/api/orders', orderRouter);
app.use('/api/admin', adminRouter);
app.use('/api/reviews', reviewRouter);

// ─── Health check ─────────────────────────────────────────────────────────────
app.get('/api/health', (_req, res) => {
  res.json({ status: 'ok', timestamp: new Date().toISOString() });
});

// ─── Global Error Handler ─────────────────────────────────────────────────────
app.use(errorHandler);

module.exports = app;
