INSERT INTO ecommerce.metodo_pago (nombre) VALUES 
('Tarjeta de Crédito'), 
('Transferencia Bancaria'), 
('PayPal'), 
('Efectivo');

SELECT setval('ecommerce.metodo_pago_id_metodo_pago_seq', COALESCE((SELECT MAX(id_metodo_pago) FROM ecommerce.metodo_pago), 1));