import 'package:flutter_caching/features/product/data/models/product_model.dart';
import 'package:flutter_caching/features/product/domain/entities/product.dart';
import 'package:isar/isar.dart';

part 'product_collection.g.dart';

@collection
class ProductCollection {
  Id isarId;

  @Index(unique: true, replace: true)
  late int id;
  late String title;
  late String description;
  late String dueDate;
  late String priority;
  late String status;
  late String imageUrl;
  late List<String> tags;

  ProductCollection({
    required this.isarId,
    required this.id,
    required this.title,
    required this.description,
    required this.dueDate,
    required this.priority,
    required this.status,
    required this.imageUrl,
    required this.tags,
  });

  // Convert ke Entity (domain)
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

  static ProductCollection fromEntity(Product product) {
    return ProductCollection(
      isarId: product.id,
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

  ProductModel toModel() {
    return ProductModel(
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

  static ProductCollection fromModel(ProductModel model) {
    return ProductCollection(
      isarId: model.id,
      id: model.id,
      title: model.title,
      description: model.description,
      dueDate: model.dueDate,
      priority: model.priority,
      status: model.status,
      imageUrl: model.imageUrl,
      tags: model.tags,
    );
  }
}
