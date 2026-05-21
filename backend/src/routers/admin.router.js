const express = require('express');
const router = express.Router();
const adminController = require('../controllers/admin.controller');

// GET /api/admin/balance-financiero -> Trae el dinero total vendido y cantidad de transacciones
router.get('/balance-financiero', adminController.obtenerBalanceFinanciero);

module.exports = router;