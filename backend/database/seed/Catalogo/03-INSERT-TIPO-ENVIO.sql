INSERT INTO ecommerce.tipo_envio (nombre) VALUES 
('Estándar (3-5 días)'), 
('Express (24h)'), 
('Recogida en Punto Físico');

SELECT setval('ecommerce.tipo_envio_id_tipo_envio_seq', COALESCE((SELECT MAX(id_tipo_envio) FROM ecommerce.tipo_envio), 1));