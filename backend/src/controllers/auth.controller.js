const bcrypt = require('bcrypt');
const jwt    = require('jsonwebtoken');
const Usuario = require('../models/usuario.model');
const { sendVerificationCode, sendResetCode } = require('../config/mailer');

// ── Registro ───────────────────────────────────────────────────────────────
const register = async (req, res, next) => {
  try {
    const { nombre, email, password, telefono } = req.body;

    const existe = await Usuario.findOne({ where: { email } });
    if (existe) return res.status(409).json({ message: 'El correo ya está registrado' });

    const password_hash  = await bcrypt.hash(password, 10);
    const sms_code       = Math.floor(100000 + Math.random() * 900000).toString();
    const sms_expires_at = new Date(Date.now() + 15 * 60 * 1000);

    const usuario = await Usuario.create({
      nombre, email, password_hash, telefono,
      rol: 'cliente',
      estado: 'PENDIENTE',
      sms_code,
      sms_expires_at,
    });

    // ✅ Enviar código al correo
    await sendVerificationCode(email, nombre, sms_code);

    res.status(201).json({
      message: 'Usuario registrado. Revisa tu correo para verificar tu cuenta.',
      id_usuario: usuario.id_usuario,
    });
  } catch (error) {
    next(error);
  }
};

// ── Verificar email ────────────────────────────────────────────────────────
const verifyEmail = async (req, res, next) => {
  try {
    const { email, codigo } = req.body;

    const usuario = await Usuario.findOne({ where: { email } });
    if (!usuario) return res.status(404).json({ message: 'Usuario no encontrado' });
    if (usuario.sms_code !== codigo) return res.status(400).json({ message: 'Código incorrecto' });
    if (new Date() > usuario.sms_expires_at) return res.status(400).json({ message: 'El código ha expirado' });

    await usuario.update({ estado: 'ACTIVO', sms_code: null, sms_expires_at: null });

    res.json({ message: 'Cuenta verificada correctamente' });
  } catch (error) {
    next(error);
  }
};

// ── Login ──────────────────────────────────────────────────────────────────
const login = async (req, res, next) => {
  try {
    const { email, password } = req.body;

    const usuario = await Usuario.findOne({ where: { email } });
    if (!usuario) return res.status(401).json({ message: 'Credenciales inválidas' });
    if (usuario.estado !== 'ACTIVO') return res.status(403).json({ message: 'Cuenta no activa o pendiente de verificación' });

    const valido = await bcrypt.compare(password, usuario.password_hash);
    if (!valido) return res.status(401).json({ message: 'Credenciales inválidas' });

    const token = jwt.sign(
      { id_usuario: usuario.id_usuario, rol: usuario.rol, email: usuario.email },
      process.env.JWT_SECRET,
      { expiresIn: '8h' }
    );

    res.json({ token, rol: usuario.rol, nombre: usuario.nombre });
  } catch (error) {
    next(error);
  }
};

// ── Olvidé mi contraseña ───────────────────────────────────────────────────
const forgotPassword = async (req, res, next) => {
  try {
    const { email } = req.body;

    const usuario = await Usuario.findOne({ where: { email } });
    if (!usuario) return res.status(404).json({ message: 'Correo no encontrado' });

    const sms_code       = Math.floor(100000 + Math.random() * 900000).toString();
    const sms_expires_at = new Date(Date.now() + 15 * 60 * 1000);

    await usuario.update({ sms_code, sms_expires_at });

    // ✅ Enviar código de recuperación al correo
    await sendResetCode(email, usuario.nombre, sms_code);

    res.json({ message: 'Código de recuperación enviado al correo' });
  } catch (error) {
    next(error);
  }
};

// ── Verificar código de recuperación ──────────────────────────────────────
const verifyResetCode = async (req, res, next) => {
  try {
    const { email, codigo } = req.body;

    const usuario = await Usuario.findOne({ where: { email } });
    if (!usuario) return res.status(404).json({ message: 'Usuario no encontrado' });
    if (usuario.sms_code !== codigo) return res.status(400).json({ message: 'Código incorrecto' });
    if (new Date() > usuario.sms_expires_at) return res.status(400).json({ message: 'El código ha expirado' });

    res.json({ message: 'Código válido. Puedes restablecer tu contraseña.' });
  } catch (error) {
    next(error);
  }
};

// ── Restablecer contraseña ─────────────────────────────────────────────────
const resetPassword = async (req, res, next) => {
  try {
    const { email, codigo, nueva_password } = req.body;

    const usuario = await Usuario.findOne({ where: { email } });
    if (!usuario) return res.status(404).json({ message: 'Usuario no encontrado' });
    if (usuario.sms_code !== codigo) return res.status(400).json({ message: 'Código incorrecto' });
    if (new Date() > usuario.sms_expires_at) return res.status(400).json({ message: 'El código ha expirado' });

    const password_hash = await bcrypt.hash(nueva_password, 10);
    await usuario.update({ password_hash, sms_code: null, sms_expires_at: null });

    res.json({ message: 'Contraseña actualizada correctamente' });
  } catch (error) {
    next(error);
  }
};

// ── Logout ─────────────────────────────────────────────────────────────────
const logout = async (req, res, next) => {
  try {
    res.json({ message: 'Sesión cerrada correctamente' });
  } catch (error) {
    next(error);
  }
};

module.exports = {
  register,
  verifyEmail,
  login,
  forgotPassword,
  verifyResetCode,
  resetPassword,
  logout,
};