/**
 * ═══════════════════════════════════════════════════════════════════════════
 * RATE LIMITING MIDDLEWARE
 * Protege contra ataques de fuerza bruta y abuso de endpoints
 * ═══════════════════════════════════════════════════════════════════════════
 */

const rateLimit = require('express-rate-limit');
const securityConfig = require('../config/security');

// ─── Global Rate Limiter ────────────────────────────────────────────────────
const globalLimiter = rateLimit({
  windowMs: securityConfig.rateLimit.global.windowMs,
  max: securityConfig.rateLimit.global.max,
  message: securityConfig.rateLimit.global.message,
  standardHeaders: securityConfig.rateLimit.global.standardHeaders,
  legacyHeaders: securityConfig.rateLimit.global.legacyHeaders,
  skip: securityConfig.rateLimit.global.skip,
  handler: (req, res) => {
    res.status(429).json({
      success: false,
      error: 'Too many requests. Please try again later.',
      retryAfter: req.rateLimit?.resetTime,
    });
  },
});

// ─── Authentication Rate Limiter (Login/Register) ──────────────────────────
const authLimiter = rateLimit({
  windowMs: securityConfig.rateLimit.endpoints.auth.windowMs,
  max: securityConfig.rateLimit.endpoints.auth.max,
  message: 'Too many authentication attempts. Please try again later.',
  standardHeaders: true,
  legacyHeaders: false,
  skipSuccessfulRequests: true, // Don't count successful requests
  keyGenerator: (req) => {
    // Rate limit by email for login, by IP for register
    return req.body?.email || req.ip;
  },
  handler: (req, res) => {
    res.status(429).json({
      success: false,
      error: 'Too many login attempts. Please try again after 15 minutes.',
    });
  },
});

// ─── Register Rate Limiter ──────────────────────────────────────────────────
const registerLimiter = rateLimit({
  windowMs: securityConfig.rateLimit.endpoints.register.windowMs,
  max: securityConfig.rateLimit.endpoints.register.max,
  message: 'Too many accounts created from this IP. Try again later.',
  standardHeaders: true,
  legacyHeaders: false,
  handler: (req, res) => {
    res.status(429).json({
      success: false,
      error: 'Too many registration attempts from this IP. Please try again in 1 hour.',
    });
  },
});

// ─── Password Reset Rate Limiter ────────────────────────────────────────────
const forgotPasswordLimiter = rateLimit({
  windowMs: securityConfig.rateLimit.endpoints.forgotPassword.windowMs,
  max: securityConfig.rateLimit.endpoints.forgotPassword.max,
  message: 'Too many password reset attempts.',
  standardHeaders: true,
  legacyHeaders: false,
  keyGenerator: (req) => req.body?.email || req.ip,
  handler: (req, res) => {
    res.status(429).json({
      success: false,
      error: 'Too many password reset attempts. Please try again in 1 hour.',
    });
  },
});

// ─── Order Creation Rate Limiter ────────────────────────────────────────────
const orderLimiter = rateLimit({
  windowMs: securityConfig.rateLimit.endpoints.orders.windowMs,
  max: securityConfig.rateLimit.endpoints.orders.max,
  message: 'Too many orders created.',
  standardHeaders: true,
  legacyHeaders: false,
  handler: (req, res) => {
    res.status(429).json({
      success: false,
      error: 'Too many orders. Please try again in 1 hour.',
    });
  },
});

module.exports = {
  globalLimiter,
  authLimiter,
  registerLimiter,
  forgotPasswordLimiter,
  orderLimiter,
};
