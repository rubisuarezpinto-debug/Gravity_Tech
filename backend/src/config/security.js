/**
 * ═══════════════════════════════════════════════════════════════════════════
 * SECURITY CONFIGURATION
 * Configuración centralizada de todas las políticas de seguridad
 * ═══════════════════════════════════════════════════════════════════════════
 */

module.exports = {
  // ─── JWT Configuration ──────────────────────────────────────────────────
  jwt: {
    secret: process.env.JWT_SECRET,
    expiration: process.env.JWT_EXPIRATION || '1d',
    algorithm: 'HS256',
    // Validate JWT secret strength
    validateSecret: (secret) => {
      if (!secret || secret.length < 32) {
        console.warn('⚠️  WARNING: JWT_SECRET is weak! Use at least 32 characters.');
      }
      return secret;
    },
  },

  // ─── Rate Limiting Configuration ─────────────────────────────────────────
  rateLimit: {
    // Global rate limit
    global: {
      windowMs: process.env.RATE_LIMIT_WINDOW_MS || 15 * 60 * 1000, // 15 minutes
      max: process.env.RATE_LIMIT_MAX_REQUESTS || 100, // 100 requests per window
      message: 'Too many requests from this IP, please try again later.',
      standardHeaders: true, // Return rate limit info in `RateLimit-*` headers
      legacyHeaders: false, // Disable `X-RateLimit-*` headers
      skip: (req) => {
        // Skip rate limiting for health checks
        return req.path === '/api/health';
      },
    },

    // Specific endpoint limits
    endpoints: {
      auth: {
        windowMs: 15 * 60 * 1000, // 15 minutes
        max: 5, // 5 requests per window
      },
      register: {
        windowMs: 60 * 60 * 1000, // 1 hour
        max: 3, // 3 requests per hour
      },
      forgotPassword: {
        windowMs: 60 * 60 * 1000, // 1 hour
        max: 3, // 3 requests per hour
      },
      orders: {
        windowMs: 60 * 60 * 1000, // 1 hour
        max: 10, // 10 requests per hour
      },
    },
  },

  // ─── CORS Configuration ──────────────────────────────────────────────────
  cors: {
    origin: process.env.CORS_ORIGIN?.split(',') || [
      'http://localhost:5000',
      'http://localhost:3000',
      ...(process.env.FRONTEND_URL ? [process.env.FRONTEND_URL] : []),
    ],
    credentials: true, // Allow cookies to be sent with requests
    optionsSuccessStatus: 200,
    methods: ['GET', 'POST', 'PUT', 'DELETE', 'PATCH', 'OPTIONS'],
    allowedHeaders: ['Content-Type', 'Authorization'],
  },

  // ─── Security Headers Configuration (Helmet) ─────────────────────────────
  helmet: {
    contentSecurityPolicy: {
      directives: {
        defaultSrc: ["'self'"],
        styleSrc: ["'self'", "'unsafe-inline'"],
        scriptSrc: ["'self'"],
        imgSrc: ["'self'", 'data:', 'https:'],
        fontSrc: ["'self'"],
        connectSrc: [
          "'self'",
          'http://localhost:3000',
          ...(process.env.FRONTEND_URL ? [process.env.FRONTEND_URL] : []),
        ],
        frameSrc: ["'none'"],
        objectSrc: ["'none'"],
      },
    },
    hsts: {
      maxAge: 31536000, // 1 year in seconds
      includeSubDomains: true,
      preload: true,
    },
    noSniff: true,
    xssFilter: true,
    referrerPolicy: { policy: 'strict-origin-when-cross-origin' },
  },

  // ─── Session/Token Configuration ─────────────────────────────────────────
  session: {
    absoluteTimeout: 24 * 60 * 60 * 1000, // 24 hours
    refreshThreshold: 60 * 60 * 1000, // Refresh token if older than 1 hour
  },

  // ─── Password Policy ─────────────────────────────────────────────────────
  password: {
    minLength: 8,
    requireUppercase: true,
    requireLowercase: true,
    requireNumbers: true,
    requireSpecialChars: true,
    maxAge: 90 * 24 * 60 * 60 * 1000, // Password expires in 90 days
  },

  // ─── Data Encryption Configuration ───────────────────────────────────────
  encryption: {
    algorithm: 'aes-256-gcm',
    saltRounds: 12, // bcrypt salt rounds for password hashing
  },

  // ─── Logging Configuration ──────────────────────────────────────────────
  logging: {
    level: process.env.LOG_LEVEL || 'info',
    file: process.env.LOG_FILE || 'logs/app.log',
    // Never log these fields
    sensitiveFields: ['password', 'password_hash', 'token', 'access_token', 'refresh_token', 'secret', 'api_key'],
  },

  // ─── Node Environment ───────────────────────────────────────────────────
  nodeEnv: process.env.NODE_ENV || 'development',
  isProduction: process.env.NODE_ENV === 'production',
  isDevelopment: process.env.NODE_ENV === 'development',
};
