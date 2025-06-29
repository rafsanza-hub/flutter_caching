import 'package:flutter/foundation.dart';
import 'package:flutter_caching/features/product/domain/entities/product.dart';
import 'package:flutter_caching/features/product/domain/usecases/add_product_use_case.dart'; //
import 'package:flutter_caching/features/product/domain/usecases/delete_product_use_case.dart'; //
import 'package:flutter_caching/features/product/domain/usecases/fetch_product_by_id_use_case.dart'; //
import 'package:flutter_caching/features/product/domain/usecases/fetch_product_use_case.dart';
import 'package:flutter_caching/features/product/domain/usecases/update_product_use_case.dart';
import 'package:logger/logger.dart';

class ProductProvider extends ChangeNotifier {
  final FetchProductUseCase _fetchProductsUseCase;
  final FetchProductByIdUseCase _fetchProductByIdUseCase;
  final AddProductUseCase _addProductUseCase;
  final UpdateProductUseCase _updateProductUseCase;
  final DeleteProductUseCase _deleteProductUseCase;

  List<Product> _products = [];
  List<Product> get products => _products;

  // ignore: prefer_final_fields
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  ProductProvider({
    required FetchProductUseCase fetchProductsUseCase,
    required FetchProductByIdUseCase fetchProductByIdUseCase,
    required AddProductUseCase addProductUseCase,
    required UpdateProductUseCase updateProductUseCase,
    required DeleteProductUseCase deleteProductUseCase,
  })  : _fetchProductsUseCase = fetchProductsUseCase,
        _fetchProductByIdUseCase = fetchProductByIdUseCase,
        _addProductUseCase = addProductUseCase,
        _updateProductUseCase = updateProductUseCase,
        _deleteProductUseCase = deleteProductUseCase;

  Future<void> fetchProducts({bool forceRefresh = false}) async {
    // _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _products = await _fetchProductsUseCase(forceRefresh: forceRefresh);
    } catch (e) {
      _errorMessage = e.toString();
      _products = [];
    } finally {
      // _isLoading = false;
      notifyListeners();
    }
  }

  Future<Product?> fetchProductById(int id) async {
    // _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    Product? product;
    try {
      product = await _fetchProductByIdUseCase.call(id); //
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      // _isLoading = false;
      notifyListeners();
    }
    return product;
  }

  Future<void> addProduct(Product product) async {
    // _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _addProductUseCase(product); //
      await fetchProducts();
    } catch (e) {
      Logger().e('Error adding product: $_errorMessage');

      _errorMessage = e.toString();
    } finally {
      // _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateProduct(Product product) async {
    // _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _updateProductUseCase.call(product);
      await fetchProducts();
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      // _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> deleteProduct(int id) async {
    // _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _deleteProductUseCase(id);
      await fetchProducts();
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      // _isLoading = false;
      notifyListeners();
    }
  }
}
