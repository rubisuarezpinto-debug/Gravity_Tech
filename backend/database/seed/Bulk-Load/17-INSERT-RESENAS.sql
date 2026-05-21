INSERT INTO ecommerce.resena (id_usuario, id_producto, comentario, puntuacion) VALUES 
(2, 1, 'Increíble consola, llegó muy rápido', 5),
(3, 2, 'El teléfono es genial pero muy caro', 4);

SELECT setval('ecommerce.resena_id_resena_seq', COALESCE((SELECT MAX(id_resena) FROM ecommerce.resena), 1));