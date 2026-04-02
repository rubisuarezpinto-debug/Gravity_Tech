const User = require('../models/User');
const { sign } = require('../utils/jwt');

/** POST /api/auth/register */
const register = async (req, res, next) => {
  try {
    const { name, email, password } = req.body;

    if (!name || !email || !password) {
      return res.status(400).json({ message: 'Todos los campos son requeridos' });
    }

    const existing = await User.findByEmail(email);
    if (existing) {
      return res.status(409).json({ message: 'El email ya está registrado' });
    }

    const user = await User.create(name, email, password);
    const token = sign({ id: user.id, role: user.role });

    res.status(201).json({ user, token });
  } catch (err) {
    next(err);
  }
};

/** POST /api/auth/login */
const login = async (req, res, next) => {
  try {
    const { email, password } = req.body;

    if (!email || !password) {
      return res.status(400).json({ message: 'Email y contraseña requeridos' });
    }

    const user = await User.findByEmail(email);
    if (!user) {
      return res.status(401).json({ message: 'Credenciales incorrectas' });
    }

    const valid = await User.verifyPassword(password, user.password_hash);
    if (!valid) {
      return res.status(401).json({ message: 'Credenciales incorrectas' });
    }

    const token = sign({ id: user.id, role: user.role });
    const { password_hash, ...safeUser } = user;

    res.json({ user: safeUser, token });
  } catch (err) {
    next(err);
  }
};

/** GET /api/auth/me */
const me = async (req, res, next) => {
  try {
    const user = await User.findById(req.user.id);
    if (!user) return res.status(404).json({ message: 'Usuario no encontrado' });
    res.json({ user });
  } catch (err) {
    next(err);
  }
};

module.exports = { register, login, me };
