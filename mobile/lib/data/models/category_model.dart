class CategoryModel {
  final int idCategoria;
  final String vCategoria;

  CategoryModel({
    required this.idCategoria,
    required this.vCategoria,
  });

  // Fábrica para transformar el JSON de la base de datos en el modelo de Dart
  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      idCategoria: json['id_categoria'] as int,
      vCategoria: json['v_categoria'] as String,
    );
  }
}