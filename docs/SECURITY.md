# Security Policy - Gravity Tech Tienda Virtual

## 📋 Table of Contents
1. [Overview](#overview)
2. [Security Implementation](#security-implementation)
3. [Environment Configuration](#environment-configuration)
4. [API Security](#api-security)
5. [Data Protection](#data-protection)
6. [Incident Response](#incident-response)

---

## Overview

This document outlines the comprehensive security measures implemented in the Gravity Tech e-commerce platform. All endpoints are protected with multiple layers of security.

### Security Layers Implemented

- ✅ Rate Limiting (Prevent brute force attacks)
- ✅ Helmet Headers (Protect against common attacks)
- ✅ CORS Configuration (Control cross-origin access)
- ✅ Authentication (JWT-based)
- ✅ Authorization (Role-Based Access Control)
- ✅ Input Validation (express-validator)
- ✅ Output Sanitization (Remove sensitive data)
- ✅ Error Handling (Safe error messages)

---

## Security Implementation

### FASE 1: Cimientos ✅
- `.env.example` - Template without credentials
- `.gitignore` - Prevents credential leakage
- `src/config/security.js` - Centralized configuration
- Dependencies: helmet, express-validator, express-rate-limit

### FASE 2: Rate Limiting & Auth ✅
- Global: 100 req/15 min per IP
- Login: 5 attempts/15 min per email
- Register: 3 attempts/hour per IP
- Checkout: 10 attempts/hour per user
- Helmet security headers configured
- JWT authentication with robust error handling
- RBAC with unauthorized access logging

### FASE 3: Validation & Sanitization ✅
- Email/password strength validation
- Input length and format validation
- Output sanitization (remove password_hash, tokens)
- HTML escaping to prevent XSS
- Consistent error responses

### FASE 4: Data Protection ⏳
- bcryptjs (12 salt rounds) for passwords
- Parameterized queries prevent SQL injection
- Environment variables protect credentials
- Encryption utilities ready for PII data

### FASE 5-7: Frontend & Tests ⏳
- Frontend validation (api.js, auth.js)
- Security testing
- Documentation and hardening

---

## Environment Configuration

**Required Variables:**
```env
PORT=3000
NODE_ENV=development
JWT_SECRET=min_32_random_characters
JWT_EXPIRATION=7d
DB_HOST=localhost
DB_PORT=5432
DB_NAME=ecommerce_db
DB_USER=ecommerce_admin
DB_PASSWORD=secure_password
CORS_ORIGIN=http://localhost:3000
```

**Generate JWT_SECRET:**
```bash
node -e "console.log(require('crypto').randomBytes(32).toString('hex'))"
```

---

## API Security

**Response Format:**
```json
{
  "success": true,
  "data": { /* payload */ },
  "timestamp": "2026-04-10T12:00:00Z"
}
```

**Headers Required:**
```bash
Authorization: Bearer <jwt_token>
Content-Type: application/json
```

---

## Data Protection

**Never Logged/Returned:**
- Passwords, password_hash
- Tokens, API keys, secrets
- Database credentials
- Credit card information
- PII without encryption

---

## Pre-Production Checklist

- [ ] JWT_SECRET is 32+ random characters
- [ ] NODE_ENV=production set
- [ ] .env not in git
- [ ] HTTPS/TLS enabled
- [ ] CORS limited to specific domains
- [ ] Rate limiting active
- [ ] Input validation complete
- [ ] npm audit = 0 vulnerabilities
- [ ] Error handlers are safe
- [ ] Logging excludes sensitive data

**Last Updated:** 2026-04-10
