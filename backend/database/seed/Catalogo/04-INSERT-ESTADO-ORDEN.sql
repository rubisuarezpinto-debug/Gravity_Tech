INSERT INTO ecommerce.estado_orden (nombre) VALUES 
('Pendiente'), 
('Pago Confirmado'), 
('En Proceso'), 
('Enviado'), 
('Entregado');

SELECT setval('ecommerce.estado_orden_id_estado_seq', COALESCE((SELECT MAX(id_estado) FROM ecommerce.estado_orden), 1));