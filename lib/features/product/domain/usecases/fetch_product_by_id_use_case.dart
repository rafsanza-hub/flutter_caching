import 'package:flutter_caching/features/product/domain/entities/product.dart';
import 'package:flutter_caching/features/product/domain/repositories/product_repository.dart';

class FetchProductByIdUseCase {
  final ProductRepository _productRepository;

  FetchProductByIdUseCase(this._productRepository);

  Future<Product> call(int productId) async {
    return await _productRepository.fetchProductById(productId);
  }
}