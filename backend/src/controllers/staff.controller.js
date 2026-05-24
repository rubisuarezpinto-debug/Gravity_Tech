const bcrypt = require('bcrypt');
const Usuario = require('../models/usuario.model');

const getAll = async (req, res, next) => {
  try {
    const staff = await Usuario.findAll({
      where: { rol: ['trabajador', 'admin'] },
      attributes: { exclude: ['password_hash', 'sms_code', 'sms_expires_at'] },
      order: [['fecha_creacion', 'DESC']]
    });
    res.json(staff);
  } catch (error) {
    next(error);
  }
};

const create = async (req, res, next) => {
  try {
    const { nombre, email, password, rol, telefono } = req.body;

    if (!['trabajador', 'admin'].includes(rol)) {
      return res.status(400).json({ message: 'Rol inválido. Solo se permite: trabajador, admin' });
    }

    const existe = await Usuario.findOne({ where: { email } });
    if (existe) return res.status(409).json({ message: 'El correo ya está registrado' });

    const password_hash = await bcrypt.hash(password, 10);
    const usuario = await Usuario.create({ nombre, email, password_hash, rol, telefono, estado: 'ACTIVO' });

    res.status(201).json({ message: 'Empleado creado', id_usuario: usuario.id_usuario });
  } catch (error) {
    next(error);
  }
};

const update = async (req, res, next) => {
  try {
    const usuario = await Usuario.findByPk(req.params.id);
    if (!usuario) return res.status(404).json({ message: 'Empleado no encontrado' });

    const { nombre, telefono, estado, rol } = req.body;
    await usuario.update({ nombre, telefono, estado, rol, fecha_actualizacion: new Date() });

    res.json({ message: 'Empleado actualizado' });
  } catch (error) {
    next(error);
  }
};

const remove = async (req, res, next) => {
  try {
    const usuario = await Usuario.findByPk(req.params.id);
    if (!usuario) return res.status(404).json({ message: 'Empleado no encontrado' });

    await usuario.update({ estado: 'INACTIVO' });
    res.json({ message: 'Empleado desactivado' });
  } catch (error) {
    next(error);
  }
};

module.exports = { getAll, create, update, remove };