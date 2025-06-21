
import 'package:flutter_caching/features/product/domain/entities/product.dart';
import 'package:flutter_caching/features/product/domain/repositories/product_repository.dart';

class UpdateProductUseCase {
  final ProductRepository _productRepository;

  UpdateProductUseCase(this._productRepository);

  Future<void> call(Product product) async {
    await _productRepository.updateProduct(product);
  }
}