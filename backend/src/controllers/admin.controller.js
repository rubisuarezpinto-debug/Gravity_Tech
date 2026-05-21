const pool = require('../config/db');

// ── CONTROL GENERAL DE DINERO (Función de Contador para el Admin) ──
const obtenerBalanceFinanciero = async (req, res, next) => {
  try {
    // Consulta agrupada real de la tabla de pagos exitosos
    const result = await pool.query(
      `SELECT 
        COALESCE(SUM(monto), 0.00) AS n_total_recaudado,
        COUNT(id_pago) AS id_total_ventas,
        COUNT(DISTINCT id_orden) AS id_ordenes_procesadas
       FROM ecommerce.pago
       WHERE estado = 'APROBADO' OR estado = 'PAGADO'`
    );

    // Consulta secundaria para saber qué métodos de pago están generando más ingresos
    const desgloseMetodos = await pool.query(
      `SELECT mp.nombre AS v_metodo, COALESCE(SUM(p.monto), 0.00) AS n_subtotal
       FROM ecommerce.pago p
       INNER JOIN ecommerce.orden o ON p.id_orden = o.id_orden
       INNER JOIN ecommerce.metodo_pago mp ON o.id_metodo_pago = mp.id_metodo_pago
       WHERE p.estado = 'APROBADO' OR p.estado = 'PAGADO'
       GROUP BY mp.nombre`
    );

    res.status(200).json({
      b_exito: true,
      v_mensaje: 'Balance financiero contable generado con éxito.',
      o_datos: {
        o_resumen: result.rows[0],
        a_desglose_metodos: desgloseMetodos.rows
      }
    });
  } catch (err) {
    next(err);
  }
};

module.exports = { obtenerBalanceFinanciero };