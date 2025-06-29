import 'package:flutter/material.dart';
import 'package:flutter_caching/features/product/domain/entities/product.dart';
import 'package:flutter_caching/features/product/domain/usecases/fetch_product_by_id_use_case.dart';

class ProductDetailProvider extends ChangeNotifier {
  final FetchProductByIdUseCase _fetchProductsUseCase;

  ProductDetailProvider({required FetchProductByIdUseCase fetchProductsUseCase}) : _fetchProductsUseCase = fetchProductsUseCase;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Product? _product;
  Product? get product => _product;

  Future<void> fetchProduct(int id) async {
    _isLoading = true;
    notifyListeners();

    final result = await _fetchProductsUseCase(id);
    _product = result;

    _isLoading = false;
    notifyListeners();
  }
}