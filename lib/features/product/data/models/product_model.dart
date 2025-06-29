import 'package:flutter_caching/features/product/data/collections/product_collection.dart';
import 'package:flutter_caching/features/product/domain/entities/product.dart';

class ProductModel {
  final int id;
  final String title;
  final String description;
  final String dueDate;
  final String priority;
  final String status;
  final String imageUrl;
  final List<String> tags;

  ProductModel({
    required this.id,
    required this.title,
    required this.description,
    required this.dueDate,
    required this.priority,
    required this.status,
    required this.imageUrl,
    required this.tags,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'title': title,
      'description': description,
      'dueDate': dueDate,
      'priority': priority,
      'status': status,
      'imageUrl': imageUrl,
      'tags': tags,
    };
  }

  factory ProductModel.fromMap(Map<String, dynamic> map) {
    return ProductModel(
      id: map['id'] as int,
      title: map['title'] as String,
      description: map['description'] as String,
      dueDate: map['dueDate'] as String,
      priority: map['priority'] as String,
      status: map['status'] as String,
      imageUrl: map['imageUrl'],
      tags: List<String>.from(
          map['tags'] as List<dynamic>), // Correct way to cast
      // Or, more robustly, if tags could be null:
      // tags: (map['tags'] as List<dynamic>?)?.map((e) => e as String).toList() ?? [],
    );
  }

  static ProductModel fromEntity(Product product) {
    return ProductModel(
      id: product.id,
      title: product.title,
      description: product.description,
      dueDate: product.dueDate,
      priority: product.priority,
      status: product.status,
      imageUrl: product.imageUrl,
      tags: product.tags,
    );
  }

  Product toEntity() {
    return Product(
      id: id,
      title: title,
      description: description,
      dueDate: dueDate,
      priority: priority,
      status: status,
      imageUrl: imageUrl,
      tags: tags,
    );
  }

  ProductCollection toCollection() {
    return ProductCollection(
      isarId: id,
      id: id,
      title: title,
      description: description,
      dueDate: dueDate,
      priority: priority,
      status: status,
      imageUrl: imageUrl,
      tags: tags,
    );
  }

  static ProductModel fromCollection(ProductCollection collection) {
    return ProductModel(
      id: collection.id,
      title: collection.title,
      description: collection.description,
      dueDate: collection.dueDate,
      priority: collection.priority,
      status: collection.status,
      imageUrl: collection.imageUrl,
      tags: collection.tags,
    );
  }

  Map<String, dynamic> toJson() => toMap();

  factory ProductModel.fromJson(Map<String, dynamic> json) =>
      ProductModel.fromMap(json);
}
