# Contributing Guide - Gravity Tech

## Security Requirements for Contributors

Before submitting a PR, ensure your code meets these security standards:

### ✅ Input Validation

- [ ] Validate ALL user inputs at system boundaries
- [ ] Use `express-validator` schemas for API endpoints
- [ ] Check data types, lengths, and formats
- [ ] Reject invalid data early with clear error messages

```javascript
// Example: Add validation to new endpoints
const { body, validationResult } = require('express-validator');

router.post('/endpoint', [
  body('email').isEmail().normalizeEmail(),
  body('password').isLength({ min: 8 }),
], (req, res) => {
  const errors = validationResult(req);
  if (!errors.isEmpty()) {
    return res.status(422).json({ success: false, details: errors.array() });
  }
  // Process request
});
```

### ✅ Output Sanitization

- [ ] Never return `password_hash`, `secret`, or `token` fields
- [ ] Use `sanitizeUser()` for user objects before responding
- [ ] Escape HTML in user-generated content
- [ ] Never log sensitive fields

```javascript
// Example: Safe API response
const { sanitizeUser } = require('../utils/sanitizer');

const user = await User.findById(id);
const safeUser = sanitizeUser(user);
res.json({ success: true, data: { user: safeUser } });
```

### ✅ No Hardcoded Secrets

- [ ] NEVER commit passwords, API keys, or tokens
- [ ] Use environment variables for ALL secrets
- [ ] Update `.env.example` with new required variables

```javascript
// WRONG ❌
const JWT_SECRET = "my-secret-key-12345";

// CORRECT ✅
const JWT_SECRET = process.env.JWT_SECRET;
if (!JWT_SECRET) throw new Error('JWT_SECRET not configured');
```

### ✅ Database Security

- [ ] Use parameterized queries ALWAYS
- [ ] Never concatenate user input into SQL
- [ ] Use ORM/query builders when available
- [ ] Test SQL injection attempts

```javascript
// WRONG ❌
const query = `SELECT * FROM users WHERE email = '${email}'`;

// CORRECT ✅
const query = 'SELECT * FROM users WHERE email = $1';
const result = await db.query(query, [email]);
```

### ✅ Authentication & Authorization

- [ ] All protected endpoints must use `authenticate` middleware
- [ ] Use `authorize('admin')` for admin-only endpoints
- [ ] Verify `req.user` is populated before using
- [ ] Return 401/403 for auth failures, never 500

```javascript
// Example: Protected admin endpoint
router.delete('/admin/users/:id', authenticate, authorize('admin'), 
  idParamSchema, validateRequest, deleteUser);
```

### ✅ Rate Limiting

- [ ] Apply rate limiting to sensitive endpoints
- [ ] Login/register: strict limits (3-5 attempts)
- [ ] Order/payment endpoints: moderate limits
- [ ] Use dedicated limiters for each endpoint

```javascript
const { authLimiter } = require('../middlewares/rateLimiter');
router.post('/login', authLimiter, login);
```

### ✅ Error Handling

- [ ] Never expose internal errors to users in production
- [ ] Log detailed errors server-side only
- [ ] Return generic messages for 500 errors
- [ ] Include error details only in development

```javascript
// WRONG ❌
res.json({ error: `Database error: ${err.message}` });

// CORRECT ✅
console.error('Database error:', err);
res.status(500).json({ success: false, error: 'Internal server error' });
```

### ✅ CORS & Headers

- [ ] Don't use `cors({ origin: '*' })`  - specify exact origins
- [ ] Helmet headers are configured globally
- [ ] Additional endpoint-specific headers if needed

### ✅ Logging

- [ ] Never log passwords, tokens, API keys
- [ ] Include user ID and action for auditing
- [ ] Log failed authentication attempts
- [ ] Use structured JSON logging

```javascript
// Example: Safe logging
console.log(JSON.stringify({
  timestamp: new Date(),
  userId: req.user.id,
  action: 'delete_product',
  productId: productId,
  result: 'success'
}));
```

---

## Code Review Checklist

Before requesting code review:

- [ ] No hardcoded secrets or credentials
- [ ] Input validation on all user inputs
- [ ] Output sanitization on all responses
- [ ] Authentication on protected endpoints
- [ ] Authorization for role-specific endpoints
- [ ] Rate limiting on sensitive endpoints
- [ ] Errors are handled safely
- [ ] No `console.log` in production code
- [ ] No sensitive data in error messages
- [ ] Security headers configured
- [ ] No SQL injection vulnerabilities
- [ ] No XSS vulnerabilities

---

## Testing Security

For new features, include security tests:

```javascript
describe('Security Tests', () => {
  test('should reject SQL injection attempts', async () => {
    const res = await request(app)
      .post('/api/login')
      .send({ email: "'; DROP TABLE--", password: 'test' });
    expect(res.status).toBe(422);
  });

  test('should reject XSS payloads', async () => {
    const res = await request(app)
      .post('/api/products')
      .send({ name: '<script>alert("xss")</script>' });
    expect(res.status).toBe(422);
  });

  test('should enforce rate limiting', async () => {
    for (let i = 0; i < 6; i++) {
      const res = await request(app).post('/api/auth/login').send(data);
      if (i < 5) expect(res.status).not.toBe(429);
      else expect(res.status).toBe(429);
    }
  });
});
```

---

## Security Incident Reporting

If you discover a security vulnerability:

1. **DO NOT** post it publicly
2. **DO NOT** commit a "fix" publicly
3. **Contact immediately:** dev-team@gravitytech.local
4. Include:
   - Vulnerability type (XSS, SQL Injection, etc.)
   - Affected endpoint(s)
   - Steps to reproduce
   - Potential impact

---

## Questions?

Refer to:
- `/docs/SECURITY.md` - Security policy
- `/backend/src/config/security.js` - Security config
- `/backend/src/validators/schemas.js` - Validation examples
- `/backend/src/utils/sanitizer.js` - Sanitization utilities

**Last Updated:** 2026-04-10
