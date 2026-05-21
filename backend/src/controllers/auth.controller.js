const pool = require('../config/db'); // Configuración de base de datos
const bcrypt = require('bcrypt');
const jwt = require('jsonwebtoken');
const { enviarCodigoCorreo } = require('../utils/email.service.js');
const { registrarAccion } = require('../utils/audit.service.js');

// ── 1. REGISTRO INICIAL (Crea cuenta con estado pendiente y envía correo) ──
const register = async (req, res, next) => {
  try {
    const { v_nombre, v_email, v_password, v_telefono } = req.body;

    // Validación de campos obligatorios
    if (!v_nombre || !v_email || !v_password || !v_telefono) {
      return res.status(400).json({ 
        b_exito: false, 
        v_mensaje: 'Todos los campos son obligatorios.' 
      });
    }

    // Consulta real: Verifica si el correo ya existe en tu tabla ecommerce.usuario
    const userExists = await pool.query(
      'SELECT id_usuario FROM ecommerce.usuario WHERE email = $1', 
      [v_email]
    );
    
    if (userExists.rows.length > 0) {
      return res.status(400).json({ 
        b_exito: false, 
        v_mensaje: 'El correo electrónico ya está registrado.' 
      });
    }

    // Hashing de contraseña seguro (usando 12 rounds)
    const salt = await bcrypt.genSalt(12);
    const hashedPassword = await bcrypt.hash(v_password, salt);

    // Generación del código de 6 dígitos y tiempo de expiración (5 minutos)
    const smsCode = Math.floor(100000 + Math.random() * 900000).toString();
    const expiresAt = new Date(Date.now() + 5 * 60 * 1000);

    // Inserción Real en la Base de Datos con estado pendiente de verificación
    const insertRes = await pool.query(
      `INSERT INTO ecommerce.usuario 
       (nombre, email, password_hash, telefono, rol, estado, sms_code, sms_expires_at) 
       VALUES ($1, $2, $3, $4, $5, $6, $7, $8)
       RETURNING id_usuario`,
      [v_nombre, v_email, hashedPassword, v_telefono, 'cliente', 'PENDIENTE', smsCode, expiresAt]
    );
    const newUserId = insertRes.rows[0].id_usuario;
    await registrarAccion(newUserId, 'REGISTER', 'usuario', `Registro inicial como PENDIENTE. Email: ${v_email}`);

    // Despacho del Correo electrónico Gratuito con Nodemailer
    try {
      await enviarCodigoCorreo(v_email, smsCode);
      console.log(`[Email] Código ${smsCode} enviado con éxito a ${v_email}`);
    } catch (emailError) {
      console.error(`[Email Fail] Error al enviar correo de verificación a ${v_email}:`, emailError.message);
      console.log(`[Email Fallback] CÓDIGO DE VERIFICACIÓN PARA ${v_email}: ${smsCode}`);
    }

    res.status(201).json({
      b_exito: true,
      v_mensaje: 'Usuario registrado. Código de verificación enviado al correo electrónico.',
      o_datos: {
        v_email: v_email,
        e_estado: 'PENDIENTE'
      }
    });

  } catch (err) {
    next(err);
  }
};

// ── 2. VERIFICACIÓN DEL CÓDIGO (Al ingresar por primera vez) ──
const verifySms = async (req, res, next) => {
  try {
    const { v_email, v_codigo_sms } = req.body;

    if (!v_email || !v_codigo_sms) {
      return res.status(400).json({ 
        b_exito: false, 
        v_mensaje: 'El correo y el código de verificación son obligatorios.' 
      });
    }

    // Consulta el usuario en la base de datos
    const result = await pool.query(
      'SELECT * FROM ecommerce.usuario WHERE email = $1', 
      [v_email]
    );

    if (result.rows.length === 0) {
      return res.status(401).json({ 
        b_exito: false, 
        v_mensaje: 'Usuario no encontrado.' 
      });
    }

    const user = result.rows[0];

    // Validar coincidencia del código
    if (!user.sms_code || user.sms_code !== v_codigo_sms) {
      return res.status(401).json({ 
        b_exito: false, 
        v_mensaje: 'Código de verificación inválido.' 
      });
    }

    // Validar expiración del código
    if (new Date() > new Date(user.sms_expires_at)) {
      return res.status(401).json({ 
        b_exito: false, 
        v_mensaje: 'El código ha expirado. Solicite uno nuevo.' 
      });
    }

    // Actualiza el estado del usuario a ACTIVO y limpia los campos del código
    await pool.query(
      `UPDATE ecommerce.usuario 
       SET estado = 'ACTIVO', sms_code = NULL, sms_expires_at = NULL 
       WHERE id_usuario = $1`, 
      [user.id_usuario]
    );

    await registrarAccion(user.id_usuario, 'VERIFY_EMAIL', 'usuario', 'Activación de cuenta exitosa vía verificación');

    // Firma del JWT incluyendo ID y ROL para el manejo de pantallas en Flutter
    const token = jwt.sign(
      { id: user.id_usuario, role: user.rol }, 
      process.env.JWT_SECRET || 'default-insecure-secret-change-in-production', 
      { expiresIn: '8h' }
    );

    res.status(200).json({
      b_exito: true,
      v_mensaje: 'Cuenta verificada con éxito de forma activa.',
      o_datos: {
        v_token: token,
        o_usuario: {
          id_usuario: user.id_usuario,
          v_nombre: user.nombre,
          v_email: user.email,
          e_rol: user.rol,
          e_estado: 'ACTIVO'
        }
      }
    });

  } catch (err) {
    next(err);
  }
};

// ── 3. INICIO DE SESIÓN ORDINARIO (Validación directa con entrega de Rol) ──
const login = async (req, res, next) => {
  try {
    const { v_email, v_password } = req.body;

    if (!v_email || !v_password) {
      return res.status(400).json({ 
        b_exito: false, 
        v_mensaje: 'Correo y contraseña requeridos.' 
      });
    }

    // Busca el usuario en la base de datos
    const result = await pool.query(
      'SELECT * FROM ecommerce.usuario WHERE email = $1', 
      [v_email]
    );

    if (result.rows.length === 0) {
      return res.status(401).json({ 
        b_exito: false, 
        v_mensaje: 'Credenciales incorrectas.' 
      });
    }

    const user = result.rows[0];

    // Verifica que el usuario no esté pendiente de activación
    if (user.estado === 'PENDIENTE') {
      return res.status(403).json({
        b_exito: false,
        v_mensaje: 'Esta cuenta aún no ha sido verificada por correo.',
        e_estado: 'PENDIENTE'
      });
    }

    // Compara la contraseña encriptada
    const isMatch = await bcrypt.compare(v_password, user.password_hash);
    if (!isMatch) {
      return res.status(401).json({ 
        b_exito: false, 
        v_mensaje: 'Credenciales incorrectas.' 
      });
    }

    // Genera el token con el rol real almacenado en la base de datos
    const token = jwt.sign(
      { id: user.id_usuario, role: user.rol }, 
      process.env.JWT_SECRET || 'default-insecure-secret-change-in-production', 
      { expiresIn: '8h' }
    );

    await registrarAccion(user.id_usuario, 'LOGIN', 'usuario', `Inicio de sesión exitoso. Rol: ${user.rol}`);

    res.status(200).json({
      b_exito: true,
      v_mensaje: 'Autenticación satisfactoria.',
      o_datos: {
        v_token: token,
        o_usuario: {
          id_usuario: user.id_usuario,
          v_nombre: user.nombre,
          v_email: user.email,
          e_rol: user.rol, 
          e_estado: user.estado
        }
      }
    });

  } catch (err) {
    next(err);
  }
};

// ── 4. SOLICITAR RECUPERACIÓN DE CONTRASEÑA ──
const solicitarRecuperacion = async (req, res, next) => {
  try {
    const { v_email } = req.body;

    if (!v_email) {
      return res.status(400).json({ b_exito: false, v_mensaje: 'El correo electrónico es obligatorio.' });
    }

    // Validar si el usuario existe en la base de datos
    const result = await pool.query('SELECT id_usuario FROM ecommerce.usuario WHERE email = $1', [v_email]);
    if (result.rows.length === 0) {
      return res.status(404).json({ b_exito: false, v_mensaje: 'No existe ninguna cuenta asociada a este correo.' });
    }

    // Generar código aleatorio de 6 dígitos y tiempo de expiración (5 minutos)
    const tokenRecuperacion = Math.floor(100000 + Math.random() * 900000).toString();
    const expiresAt = new Date(Date.now() + 5 * 60 * 1000);

    // Guardar el código en las columnas existentes del usuario para reutilizar la estructura
    await pool.query(
      `UPDATE ecommerce.usuario 
       SET sms_code = $1, sms_expires_at = $2 
       WHERE email = $3`,
      [tokenRecuperacion, expiresAt, v_email]
    );

    // Enviar el correo usando tu servicio existente de Nodemailer
    try {
      await enviarCodigoCorreo(v_email, tokenRecuperacion);
      console.log(`[Recuperación] Código ${tokenRecuperacion} enviado con éxito a ${v_email}`);
    } catch (emailError) {
      console.error(`[Email Fail] Error al enviar correo de recuperación a ${v_email}:`, emailError.message);
      console.log(`[Email Fallback] CÓDIGO DE RECUPERACIÓN PARA ${v_email}: ${tokenRecuperacion}`);
    }

    res.status(200).json({
      b_exito: true,
      v_mensaje: 'Código de seguridad enviado con éxito. Revisa tu bandeja de entrada.'
    });

  } catch (err) {
    next(err);
  }
};

// ── 5. CONFIRMAR NUEVA CONTRASEÑA CON EL CÓDIGO ──
const cambiarContrasenia = async (req, res, next) => {
  try {
    const { v_email, v_codigo, v_nueva_password } = req.body;

    if (!v_email || !v_codigo || !v_nueva_password) {
      return res.status(400).json({ b_exito: false, v_mensaje: 'Todos los campos son obligatorios.' });
    }

    const result = await pool.query('SELECT * FROM ecommerce.usuario WHERE email = $1', [v_email]);
    if (result.rows.length === 0) {
      return res.status(404).json({ b_exito: false, v_mensaje: 'Usuario no encontrado.' });
    }

    const user = result.rows[0];

    // Validar el código
    if (!user.sms_code || user.sms_code !== v_codigo) {
      return res.status(401).json({ b_exito: false, v_mensaje: 'Código de recuperación inválido.' });
    }

    // Validar expiración
    if (new Date() > new Date(user.sms_expires_at)) {
      return res.status(401).json({ b_exito: false, v_mensaje: 'El código ha expirado. Solicite uno nuevo.' });
    }

    // Encriptar la nueva contraseña con bcrypt de forma segura
    const salt = await bcrypt.genSalt(12);
    const hashedPassword = await bcrypt.hash(v_nueva_password, salt);

    // Actualizar contraseña y limpiar el código de la BD
    await pool.query(
      `UPDATE ecommerce.usuario 
       SET password_hash = $1, sms_code = NULL, sms_expires_at = NULL 
       WHERE id_usuario = $2`,
      [hashedPassword, user.id_usuario]
    );

    await registrarAccion(user.id_usuario, 'RESET_PASSWORD', 'usuario', 'Restablecimiento de contraseña por código de recuperación');

    res.status(200).json({
      b_exito: true,
      v_mensaje: 'Contraseña actualizada con éxito. Ya puedes iniciar sesión.'
    });

  } catch (err) {
    next(err);
  }
};

// ── UNICA EXPORTACIÓN FINAL DEL ARCHIVO ──
module.exports = {
  register,
  login,
  verifySms,
  solicitarRecuperacion,
  cambiarContrasenia
};