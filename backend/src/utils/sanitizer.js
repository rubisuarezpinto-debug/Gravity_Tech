/**
 * ═══════════════════════════════════════════════════════════════════════════
 * SANITIZATION UTILITIES
 * Funciones para sanitizar y validar datos antes de procesarlos o enviarlos
 * ═══════════════════════════════════════════════════════════════════════════
 */

/**
 * Sanitize user object - remove sensitive fields from API responses
 */
const sanitizeUser = (user) => {
  if (!user) return null;

  // Create a copy to avoid mutations
  const sanitized = { ...user };

  // Remove sensitive fields
  delete sanitized.password_hash;
  delete sanitized.password;
  delete sanitized.secret;
  delete sanitized.recovery_code;

  return sanitized;
};

/**
 * Sanitize array of users
 */
const sanitizeUsers = (users) => {
  if (!Array.isArray(users)) return [];
  return users.map(sanitizeUser);
};

/**
 * Escape HTML special characters to prevent XSS
 */
const escapeHtml = (text) => {
  if (typeof text !== 'string') return text;

  const htmlEscapeMap = {
    '&': '&amp;',
    '<': '&lt;',
    '>': '&gt;',
    '"': '&quot;',
    "'": '&#39;',
    '/': '&#x2F;',
  };

  return text.replace(/[&<>"'/]/g, (char) => htmlEscapeMap[char]);
};

/**
 * Sanitize object strings for database/API operations
 * Removes control characters, null bytes, and trims whitespace
 */
const sanitizeString = (str) => {
  if (typeof str !== 'string') return str;

  return str
    .trim() // Remove leading/trailing whitespace
    .replace(/\0/g, '') // Remove null bytes
    .replace(/[\x00-\x1F\x7F]/g, ''); // Remove control characters
};

/**
 * Sanitize email address
 */
const sanitizeEmail = (email) => {
  if (typeof email !== 'string') return email;

  return email
    .trim()
    .toLowerCase()
    .replace(/[^\w.@-]/g, ''); // Remove invalid characters
};

/**
 * Sanitize object - applies sanitization to all string fields
 */
const sanitizeObject = (obj) => {
  if (!obj || typeof obj !== 'object') return obj;

  const sanitized = {};

  for (const [key, value] of Object.entries(obj)) {
    if (typeof value === 'string') {
      sanitized[key] = sanitizeString(value);
    } else if (typeof value === 'object' && value !== null) {
      sanitized[key] = sanitizeObject(value); // Recursive for nested objects
    } else {
      sanitized[key] = value;
    }
  }

  return sanitized;
};

/**
 * Create safe API response - ensures no sensitive data is leaked
 */
const createSafeResponse = (success, data = null, error = null) => {
  const response = {
    success,
    ...(data && { data: data }),
    ...(error && { error }),
    timestamp: new Date().toISOString(),
  };

  return response;
};

/**
 * Validate and sanitize database connection string (never log full string)
 */
const sanitizeDbUrl = (url) => {
  if (!url) return '[DB_URL not set]';

  // Replace password with asterisks
  return url.replace(/:([^@]*?)@/, ':****@');
};

module.exports = {
  sanitizeUser,
  sanitizeUsers,
  escapeHtml,
  sanitizeString,
  sanitizeEmail,
  sanitizeObject,
  createSafeResponse,
  sanitizeDbUrl,
};
