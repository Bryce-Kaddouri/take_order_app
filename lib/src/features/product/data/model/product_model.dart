import 'package:take_order_app/src/features/category/data/model/category_model.dart';

class ProductModel {
  final int id;
  final String name;
  final String imageUrl;
  /*final DateTime createdAt;
  final DateTime updatedAt;*/
  final double price;
  final CategoryModel category;

  ProductModel({
    required this.id,
    required this.name,
    required this.imageUrl,
   /* required this.createdAt,
    required this.updatedAt,*/
    required this.price,
    required this.category,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['product_id'],
      name: json['product_name'],
      imageUrl: json['product_photo_url'],
      /*createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),*/
      price: json['product_price'],
      category: CategoryModel.fromJson(json['category_info']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'photo_url': imageUrl,
      /*'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),*/
      'price': price,
      'category_info': category.toJson(),
    };
  }

  ProductModel copyWith({
    int? id,
    String? name,
    String? description,
    String? imageUrl,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isVisible,
    double? price,
    CategoryModel? category,
  }) {
    return ProductModel(
      id: id ?? this.id,
      name: name ?? this.name,
      imageUrl: imageUrl ?? this.imageUrl,
     /* createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,*/
      price: price ?? this.price,
      category: category ?? this.category,

    );
  }
}
