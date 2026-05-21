INSERT INTO ecommerce.pago (id_orden, monto, referencia, estado) VALUES 
(1, 499.99, 'REF-001-XYZ', 'APROBADO'), 
(2, 1199.00, 'REF-002-ABC', 'PENDIENTE');

SELECT setval('ecommerce.pago_id_pago_seq', COALESCE((SELECT MAX(id_pago) FROM ecommerce.pago), 1));