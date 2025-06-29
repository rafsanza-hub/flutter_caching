import 'package:flutter_caching/features/product/data/collections/product_collection.dart';

abstract class ProductLocalDataSource {
  Future<List<ProductCollection>> getCachedProducts();
  Future<ProductCollection?> getCachedProductById(int id);
  Future<void> cacheProducts(List<ProductCollection> products);
  Future<void> cacheProduct(ProductCollection product);
  Future<void> insertProduct(ProductCollection product);
  Future<void> updateProduct(ProductCollection product);
  Future<void> deleteProduct(int id);
  Future<void> updateLastCacheTimestamp(DateTime timestamp);
  Future<DateTime?> getLastCacheTimestamp();
}
