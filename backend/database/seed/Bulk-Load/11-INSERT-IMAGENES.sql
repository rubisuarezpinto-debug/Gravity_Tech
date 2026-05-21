INSERT INTO ecommerce.imagen (id_producto, url) VALUES 
(1, 'https://images.unsplash.com/photo-1606144042614-b2417e99c4e3'),
(2, 'https://images.unsplash.com/photo-1696446701796-da61225697cc'),
(3, 'https://images.unsplash.com/photo-1542291026-7eec264c27ff'),
(4, 'https://images.unsplash.com/photo-1527443224154-c4a3942d3acf'),
(5, 'https://images.unsplash.com/photo-1615663245857-ac93bb7c39e7'),
(8, 'https://images.unsplash.com/photo-1505740420928-5e560c06d30e'),
(11, 'https://images.unsplash.com/photo-1517336714460-45732238469d'),
(15, 'https://images.unsplash.com/photo-1593359677879-a4bb92f829d1'),
(20, 'https://images.unsplash.com/photo-1591488320449-011701bb6704');

SELECT setval('ecommerce.imagen_id_imagen_seq', COALESCE((SELECT MAX(id_imagen) FROM ecommerce.imagen), 1));