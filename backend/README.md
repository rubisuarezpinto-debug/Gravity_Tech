# Gravity Tech Backend - Express.js API

## Quick Start

```bash
# Install dependencies
npm install

# Create .env file from template
cp .env.example .env

# Configure .env with your values
# IMPORTANT: Generate a strong JWT_SECRET
node -e "console.log(require('crypto').randomBytes(32).toString('hex'))"

# Run development server
npm run dev

# Run production server
npm start
```

## Project Structure

```
backend/
├── src/
│   ├── config/
│   │   └── security.js          # Centralized security configuration
│   ├── controllers/              # Request handlers
│   ├── models/                   # Database models
│   ├── middlewares/              # Express middlewares
│   │   ├── authenticate.js       # JWT verification
│   │   ├── authorize.js          # Role-based access control
│   │   ├── errorHandler.js       # Safe error handling
│   │   └── rateLimiter.js        # Rate limiting
│   ├── routers/                  # API routes
│   ├── utils/
│   │   ├── jwt.js                # JWT utilities
│   │   ├── hash.js               # Password hashing
│   │   ├── db.js                 # Database connection
│   │   └── sanitizer.js          # Output sanitization
│   └── validators/               # Input validation
│       ├── schemas.js            # Validation schemas
│       └── middleware.js         # Validation middleware
├── .env.example                  # Environment template
├── .gitignore                    # Git ignore rules
├── package.json
├── server.js                     # Entry point
└── app.js                        # Express app configuration
```

## Security Features

### ✅ Implemented

- **Rate Limiting** - Global and endpoint-specific limits
- **JWT Authentication** - Secure token-based auth
- **RBAC Authorization** - Role-based access control
- **Input Validation** - express-validator with custom schemas
- **Output Sanitization** - Remove sensitive data from responses
- **Helmet Headers** - CSRF, CSP, X-Frame-Options protection
- **CORS Configuration** - Whitelist specific origins
- **Error Handling** - Safe error messages (no data leakage)
- **bcryptjs** - Secure password hashing (12 rounds)
- **Parameterized Queries** - Prevent SQL injection

### 🔒 Configuration

See `/docs/SECURITY.md` for complete security policy.

## Environment Variables

```env
# Server
PORT=3000
NODE_ENV=development

# JWT (Generate: node -e "console.log(require('crypto').randomBytes(32).toString('hex'))")
JWT_SECRET=your_32_char_random_secret_here
JWT_EXPIRATION=7d

# Database
DB_HOST=localhost
DB_PORT=5432
DB_NAME=ecommerce_db
DB_USER=ecommerce_admin
DB_PASSWORD=your_secure_password

# CORS
CORS_ORIGIN=http://localhost:3000,http://localhost:5173
```

## API Endpoints

### Authentication
- `POST /api/auth/register` - Register new user
- `POST /api/auth/login` - Login with email/password
- `GET /api/auth/me` - Get current user (requires auth)

### Products
- `GET /api/products` - List all products
- `GET /api/products/:id` - Get product details
- `POST /api/products` - Create product (admin only)
- `PUT /api/products/:id` - Update product (admin only)

### Cart
- `GET /api/cart` - View cart
- `POST /api/cart` - Add item to cart
- `PUT /api/cart/:id` - Update cart item
- `DELETE /api/cart/:id` - Remove from cart

### Orders
- `GET /api/orders` - List user's orders
- `GET /api/orders/:id` - Get order details
- `POST /api/orders/checkout` - Create order

## Rate Limiting

| Endpoint | Limit | Window |
|----------|-------|--------|
| Global | 100 req | 15 min |
| `/auth/login` | 5 req | 15 min |
| `/auth/register` | 3 req | 1 hour |
| `/orders/checkout` | 10 req | 1 hour |

## Database

Uses PostgreSQL with pg library. Connection pooling configured in `.config/db.js`.

```javascript
// Example: Query with parameterization (SAFE)
const result = await db.query(
  'SELECT * FROM users WHERE email = $1',
  [email]
);
```

## Testing

```bash
# Run tests
npm test

# Run with coverage
npm run test:coverage

# Run security checks
npm run security:check
```

## Logging

- Errors logged to console and file
- Sensitive fields (passwords, tokens) never logged
- Structured JSON logging format
- Production: Only INFO level and above

## Monitoring

- Health check: `GET /api/health`
- Returns: `{ "status": "ok", "timestamp": "..." }`

## Contributing

See `/docs/CONTRIBUTING.md` for security requirements and code review checklist.

## Support

- Security issues: See `/docs/SECURITY.md`
- Questions: Check `/docs/CONTRIBUTING.md`
- Bugs: Create issue with reproduction steps

---

**Last Updated:** 2026-04-10  
**Maintained by:** Gravity Tech Development Team
