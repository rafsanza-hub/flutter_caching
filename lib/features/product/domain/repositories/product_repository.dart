import 'package:flutter_caching/features/product/domain/entities/product.dart';

abstract class ProductRepository {
  Future<List<Product>> fetchProducts();
  Future<Product> fetchProductById(String id);
  Future<void> addProduct(Product product);
  Future<void> updateProduct(Product product);
  Future<void> deleteProduct(String id);
}
