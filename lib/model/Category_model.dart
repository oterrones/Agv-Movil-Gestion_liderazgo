import 'dart:convert';

class AppDataCategory {
  final bool state;
  final List<Category_model> category_list;
  AppDataCategory({required this.state, required this.category_list});

  factory AppDataCategory.fromJson(Map<String, dynamic> parsedJson){

    var list = parsedJson['resultado'] as List;
    List<Category_model> response_aws_list = list.map((i) => Category_model.fromJson(i)).toList();

    return AppDataCategory(
        state: parsedJson['state'],
        category_list: response_aws_list
    );
  }
}

class Category_model {
  Category_model({
    required this.id,
    required this.nombre_category
  });

  String id;
  String nombre_category;


  factory Category_model.fromJson(Map<String, dynamic> json) => Category_model(
    id: json["id"],
    nombre_category: json["nombre_category"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "nombre_category": nombre_category
  };
}
