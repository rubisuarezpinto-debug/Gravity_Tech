const bcrypt = require('bcrypt');
const Usuario = require('../models/usuario.model');

const getProfile = async (req, res, next) => {
  try {
    const usuario = await Usuario.findByPk(req.user.id_usuario, {
      attributes: { exclude: ['password_hash', 'sms_code', 'sms_expires_at'] }
    });
    if (!usuario) return res.status(404).json({ message: 'Usuario no encontrado' });
    res.json(usuario);
  } catch (error) {
    next(error);
  }
};

const updateProfile = async (req, res, next) => {
  try {
    const { nombre, telefono } = req.body;
    const usuario = await Usuario.findByPk(req.user.id_usuario);
    if (!usuario) return res.status(404).json({ message: 'Usuario no encontrado' });

    await usuario.update({ nombre, telefono, fecha_actualizacion: new Date() });
    res.json({ message: 'Perfil actualizado', usuario });
  } catch (error) {
    next(error);
  }
};

const changePassword = async (req, res, next) => {
  try {
    const { password_actual, nueva_password } = req.body;
    const usuario = await Usuario.findByPk(req.user.id_usuario);

    const valido = await bcrypt.compare(password_actual, usuario.password_hash);
    if (!valido) return res.status(400).json({ message: 'La contraseña actual es incorrecta' });

    const password_hash = await bcrypt.hash(nueva_password, 10);
    await usuario.update({ password_hash, fecha_actualizacion: new Date() });

    res.json({ message: 'Contraseña actualizada correctamente' });
  } catch (error) {
    next(error);
  }
};

module.exports = { getProfile, updateProfile, changePassword };