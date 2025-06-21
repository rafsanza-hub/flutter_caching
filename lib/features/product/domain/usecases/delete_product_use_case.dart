
import 'package:flutter_caching/features/product/domain/repositories/product_repository.dart';

class DeleteProductUseCase {
  final ProductRepository _productRepository;

  DeleteProductUseCase(this._productRepository);

  Future<void> call(String productId) async {
    await _productRepository.deleteProduct(productId);
  }
}