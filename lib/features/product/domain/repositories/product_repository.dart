import 'package:flutter_caching/features/product/domain/entities/product.dart';

abstract class ProductRepository {
  Future<List<Product>> fetchProducts({bool forceRefresh = false});
  Future<Product> fetchProductById(int id);
  Future<void> addProduct(Product product);
  Future<void> updateProduct(Product product);
  Future<void> deleteProduct(int id);
}
