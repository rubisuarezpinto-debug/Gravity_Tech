const express = require('express');
const cors = require('cors');
const helmet = require('helmet');
const errorHandler = require('./src/middlewares/errorHandler');
const securityConfig = require('./src/config/security');
const { globalLimiter, authLimiter, registerLimiter, orderLimiter } = require('./src/middlewares/rateLimiter');

// Routers
const authRouter = require('./src/routers/auth.router');
const productRouter = require('./src/routers/products.router');
const cartRouter = require('./src/routers/cart.router');
const orderRouter = require('./src/routers/orders.router');
const adminRouter = require('./src/routers/admin.router');
const reviewRouter    = require('./src/routers/reviews.router');
const favoritesRouter = require('./src/routers/favorites.router');
const couponsRouter   = require('./src/routers/coupons.router');

const app = express();

// ─── Security Middlewares (ORDER MATTERS) ──────────────────────────────────────
// 1. Helmet: Set HTTP security headers
app.use(helmet(securityConfig.helmet));

// 2. CORS: Control cross-origin requests
app.use(cors(securityConfig.cors));

// 3. Body parsing
app.use(express.json({ limit: '10mb' }));
app.use(express.urlencoded({ extended: true, limit: '10mb' }));

// 4. Global Rate Limiting: Protect against brute force
app.use(globalLimiter);

// ─── Routers ───────────────────────────────────────────────────────────────────
app.use('/api/auth', authRouter);
app.use('/api/products', productRouter);
app.use('/api/cart', cartRouter);
app.use('/api/orders', orderRouter);
app.use('/api/admin', adminRouter);
app.use('/api/reviews',   reviewRouter);
app.use('/api/favorites', favoritesRouter);
app.use('/api/coupons',   couponsRouter);

// ─── Health check ─────────────────────────────────────────────────────────────
app.get('/api/health', (_req, res) => {
  res.json({ status: 'ok', timestamp: new Date().toISOString() });
});

// ─── Global Error Handler ─────────────────────────────────────────────────────
app.use(errorHandler);

module.exports = app;
