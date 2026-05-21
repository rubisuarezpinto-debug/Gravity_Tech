class ProductModel {
  final int id;
  final String name;
  final double price;
  final int stock;
  final String description;
  final String? imageUrl;
  final int idMarca; // Según tu BD

  

  ProductModel({
    required this.id,
    required this.name,
    required this.price,
    required this.stock,
    required this.description,
    this.imageUrl,
    required this.idMarca,
    
  });

 factory ProductModel.fromJson(Map<String, dynamic> json) {
  return ProductModel(
    id: json['id'] ?? 0,
    name: json['nombre'] ?? 'Sin nombre',
    
    // CORRECCIÓN AQUÍ: Esta línea maneja tanto String como num
    price: json['precio'] != null 
        ? (json['precio'] is String 
            ? double.tryParse(json['precio']) ?? 0.0 
            : (json['precio'] as num).toDouble()) 
        : 0.0,
    
    stock: json['stock'] ?? 0,
    description: json['descripcion'] ?? '',
imageUrl: json['url_imagen'],
    idMarca: json['id_marca'] ?? 0,
  );
}

  Map<String, dynamic> toJson() {
    return {
      'id_producto': id,
      'nombre': name,
      'precio': price,
      'stock': stock,
      'descripcion': description,
      'url_imagen': imageUrl,
      'id_marca': idMarca,
    };
  }
}