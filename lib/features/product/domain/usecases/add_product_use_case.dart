import 'package:flutter_caching/features/product/domain/entities/product.dart';
import 'package:flutter_caching/features/product/domain/repositories/product_repository.dart';

class AddProductUseCase {
  final ProductRepository _productRepository;

  AddProductUseCase(this._productRepository);

  Future<void> call(Product product) async {
    await _productRepository.addProduct(product);
  }
}