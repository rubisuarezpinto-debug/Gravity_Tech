const ROLES = Object.freeze({
  ADMIN:     'admin',
  CLIENTE:   'cliente',
  EMPLEADO:  'empleado',
});

const ORDER_STATUS = Object.freeze({
  PENDIENTE:  'pendiente',
  PROCESANDO: 'procesando',
  ENVIADO:    'enviado',
  ENTREGADO:  'entregado',
  CANCELADO:  'cancelado',
});

const PAYMENT_METHODS = Object.freeze({
  CARD:     'card',
  TRANSFER: 'transfer',
  CASH:     'cash',
});

module.exports = { ROLES, ORDER_STATUS, PAYMENT_METHODS };
