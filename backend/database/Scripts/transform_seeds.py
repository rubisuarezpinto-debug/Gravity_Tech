import os
import re

seed_dir = r"c:\Users\jhoan\OneDrive\Documentos\Desarrollo orientado a plataformas\Tienda virtual\backend\database\seed"

replacements = {
    "categories": "ecommerce.categoria",
    "brands": "ecommerce.marca",
    "shipping_types": "ecommerce.tipo_envio",
    "order_statuses": "ecommerce.estado_orden",
    "payment_methods": "ecommerce.metodo_pago",
    
    # Bulk load tables
    "INSERT INTO users (name, email, password_hash, role) VALUES": 
        "INSERT INTO ecommerce.usuario (email, password_hash) VALUES",
        
    "INSERT INTO addresses (user_id, address, city, country) VALUES": 
        "INSERT INTO ecommerce.direccion (id_usuario, direccion, ciudad, pais) VALUES",
        
    "INSERT INTO users_metodo_pago (user_id, payment_method_id) VALUES": 
        "INSERT INTO ecommerce.usuario_metodo_pago (id_usuario, id_metodo_pago) VALUES",
        
    "INSERT INTO products (name, description, price, stock, sku, brand_id) VALUES": 
        "INSERT INTO ecommerce.producto (nombre, descripcion, precio, stock, sku, id_marca) VALUES",
        
    "INSERT INTO products_categoria (product_id, category_id) VALUES": 
        "INSERT INTO ecommerce.producto_categoria (id_producto, id_categoria) VALUES",
        
    "INSERT INTO images (product_id, url) VALUES": 
        "INSERT INTO ecommerce.imagen (id_producto, url) VALUES",
        
    "INSERT INTO carts (user_id) VALUES": 
        "INSERT INTO ecommerce.carrito (id_usuario) VALUES",
        
    "INSERT INTO cart_items (cart_id, product_id, cantidad, price_unitario) VALUES": 
        "INSERT INTO ecommerce.carrito_item (id_carrito, id_producto, cantidad, precio_unitario) VALUES",
        
    "INSERT INTO orders (user_id, address_id, payment_method_id, shipping_type_id, status_id, total) VALUES": 
        "INSERT INTO ecommerce.orden (id_usuario, id_direccion, id_metodo_pago, id_tipo_envio, id_estado, total) VALUES",
        
    "INSERT INTO order_items (order_id, product_id, cantidad, price_unitario) VALUES": 
        "INSERT INTO ecommerce.orden_item (id_orden, id_producto, cantidad, precio_unitario) VALUES",
        
    "INSERT INTO payments (order_id, amount, reference, estado) VALUES": 
        "INSERT INTO ecommerce.pago (id_orden, monto, referencia, estado) VALUES",
        
    "INSERT INTO reviews (user_id, product_id, comment, rating) VALUES": 
        "INSERT INTO ecommerce.resena (id_usuario, id_producto, comentario, puntuacion) VALUES",
        
    "INSERT INTO audits (user_id, accion, entidad, detalle) VALUES": 
        "INSERT INTO ecommerce.auditoria (id_usuario, accion, entidad, detalle) VALUES",
}

for root, _, files in os.walk(seed_dir):
    for f in files:
        if f.endswith(".sql"):
            path = os.path.join(root, f)
            with open(path, "r", encoding="utf-8") as file:
                content = file.read()
                
            orig_content = content
            
            # Direct text replaces
            for k, v in replacements.items():
                content = content.replace(k, v)
                
            # For categories, brands, etc. they might be `categories (name)`
            content = content.replace("ecommerce.categoria (name)", "ecommerce.categoria (nombre)")
            content = content.replace("ecommerce.marca (name)", "ecommerce.marca (nombre)")
            content = content.replace("ecommerce.tipo_envio (name)", "ecommerce.tipo_envio (nombre)")
            content = content.replace("ecommerce.estado_orden (name)", "ecommerce.estado_orden (nombre)")
            content = content.replace("ecommerce.metodo_pago (name)", "ecommerce.metodo_pago (nombre)")
            
            # Special case for users: strip the 'nombre' and 'role' from value tuples
            if "06-INSERT-USUARIOS" in f:
                # ('Administrador', 'admin@com', 'admin_secure_2026', 'admin') -> ('admin@com', 'admin_secure_2026')
                content = re.sub(r"\('[^']+',\s*'([^']+)',\s*'([^']+)',\s*'[^']+'\)", r"('\1', '\2')", content)
                
            if orig_content != content:
                with open(path, "w", encoding="utf-8") as file:
                    file.write(content)
                print(f"Updated {f}")

print("Done transforming seeds.")
