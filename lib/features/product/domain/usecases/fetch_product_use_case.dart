

import 'package:flutter_caching/features/product/domain/entities/product.dart';
import 'package:flutter_caching/features/product/domain/repositories/product_repository.dart';

class FetchProductUseCase {
  final ProductRepository _productRepository;

  FetchProductUseCase(this._productRepository);

  Future<List<Product>> call() async {
   return await _productRepository.fetchProducts();
  }
}