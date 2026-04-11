-- ##################################################
-- #            DDL SCRIPT: ALTER TABLES            #
-- ##################################################
-- Actualizado para coincidir con la estructura en inglés y sin esquemas.

-- Modulo Usuario
ALTER TABLE addresses 
    ADD CONSTRAINT fk_address_user FOREIGN KEY (user_id) REFERENCES users (id) ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE user_payment_methods 
    ADD CONSTRAINT fk_upm_user FOREIGN KEY (user_id) REFERENCES users (id) ON UPDATE CASCADE ON DELETE CASCADE,
    ADD CONSTRAINT fk_upm_payment_method FOREIGN KEY (payment_method_id) REFERENCES payment_methods (id) ON UPDATE CASCADE ON DELETE RESTRICT;

-- Modulo Producto
ALTER TABLE products 
    ADD CONSTRAINT fk_product_brand FOREIGN KEY (brand_id) REFERENCES brands (id) ON UPDATE CASCADE ON DELETE RESTRICT;

ALTER TABLE product_categories 
    ADD CONSTRAINT fk_pc_product FOREIGN KEY (product_id) REFERENCES products (id) ON UPDATE CASCADE ON DELETE CASCADE,
    ADD CONSTRAINT fk_pc_category FOREIGN KEY (category_id) REFERENCES categories (id) ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE images 
    ADD CONSTRAINT fk_image_product FOREIGN KEY (product_id) REFERENCES products (id) ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE reviews 
    ADD CONSTRAINT fk_review_user FOREIGN KEY (user_id) REFERENCES users (id) ON UPDATE CASCADE ON DELETE CASCADE,
    ADD CONSTRAINT fk_review_product FOREIGN KEY (product_id) REFERENCES products (id) ON UPDATE CASCADE ON DELETE CASCADE;

-- Modulo Carrito
ALTER TABLE carts 
    ADD CONSTRAINT fk_cart_user FOREIGN KEY (user_id) REFERENCES users (id) ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE cart_items 
    ADD CONSTRAINT fk_ci_cart FOREIGN KEY (cart_id) REFERENCES carts (id) ON UPDATE CASCADE ON DELETE CASCADE,
    ADD CONSTRAINT fk_ci_product FOREIGN KEY (product_id) REFERENCES products (id) ON UPDATE CASCADE ON DELETE RESTRICT;

-- Modulo Ordenes
ALTER TABLE orders 
    ADD CONSTRAINT fk_order_user FOREIGN KEY (user_id) REFERENCES users (id) ON UPDATE CASCADE ON DELETE CASCADE,
    ADD CONSTRAINT fk_order_address FOREIGN KEY (address_id) REFERENCES addresses (id) ON UPDATE CASCADE ON DELETE RESTRICT,
    ADD CONSTRAINT fk_order_payment_method FOREIGN KEY (payment_method_id) REFERENCES payment_methods (id) ON UPDATE CASCADE ON DELETE RESTRICT,
    ADD CONSTRAINT fk_order_shipping_type FOREIGN KEY (shipping_type_id) REFERENCES shipping_types (id) ON UPDATE CASCADE ON DELETE RESTRICT,
    ADD CONSTRAINT fk_order_status_id FOREIGN KEY (status_id) REFERENCES order_statuses (id) ON UPDATE CASCADE ON DELETE RESTRICT;

ALTER TABLE order_items 
    ADD CONSTRAINT fk_oi_order FOREIGN KEY (order_id) REFERENCES orders (id) ON UPDATE CASCADE ON DELETE CASCADE,
    ADD CONSTRAINT fk_oi_product FOREIGN KEY (product_id) REFERENCES products (id) ON UPDATE CASCADE ON DELETE RESTRICT;

ALTER TABLE payments 
    ADD CONSTRAINT fk_payment_order FOREIGN KEY (order_id) REFERENCES orders (id) ON UPDATE CASCADE ON DELETE CASCADE;

-- Modulo Auditoria
ALTER TABLE audits 
    ADD CONSTRAINT fk_audit_user FOREIGN KEY (user_id) REFERENCES users (id) ON UPDATE CASCADE ON DELETE RESTRICT;

