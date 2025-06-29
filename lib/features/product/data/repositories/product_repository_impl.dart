import 'package:flutter_caching/core/error/exception.dart';
import 'package:flutter_caching/core/utils/logger.dart';
import 'package:flutter_caching/features/product/data/datasources/local/product_local_data_source.dart';
import 'package:flutter_caching/features/product/data/datasources/remote/product_remote_data_source.dart';
import 'package:flutter_caching/features/product/data/models/product_model.dart';
import 'package:flutter_caching/features/product/domain/entities/product.dart';
import 'package:flutter_caching/features/product/domain/repositories/product_repository.dart';

class ProductRepositoryImpl implements ProductRepository {
  final ProductRemoteDataSource remoteDataSource;
  final ProductLocalDataSource localDataSource;
  final Duration cacheTTL;

  ProductRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    this.cacheTTL = const Duration(minutes: 30),
  });

  @override
  Future<List<Product>> fetchProducts({bool forceRefresh = false}) async {
    AppLogger.d('forceRefresh: $forceRefresh');
    if (!forceRefresh) {
      try {
        final cachedProducts = await localDataSource.getCachedProducts();
        final lastCacheTime = await localDataSource.getLastCacheTimestamp();

        final isValid = cachedProducts.isNotEmpty &&
            lastCacheTime != null &&
            DateTime.now().difference(lastCacheTime) < cacheTTL;

        if (isValid) {
          AppLogger.d('[Repository] Ambil dari cache');
          return cachedProducts.map((e) => e.toEntity()).toList();
        }
        if (cachedProducts.isNotEmpty) {
          AppLogger.d('[Repository] Cache expired, coba ambil dari remote');
        }
      } catch (e) {
        AppLogger.e('[Repository] Cache error, coba remote: $e');
      }
    }

    try {
      AppLogger.d('[Repository] Ambil dari remote');
      final remoteProducts = await remoteDataSource.fetchProducts();

      // Cache ke lokal
      await localDataSource
          .cacheProducts(remoteProducts.map((e) => e.toCollection()).toList());
      await localDataSource.updateLastCacheTimestamp(DateTime.now());

      return remoteProducts.map((e) => e.toEntity()).toList();
    } catch (e) {
      AppLogger.e('[Repository] Error remote: $e. Fallback ke cache.');
      try {
        final fallback = await localDataSource.getCachedProducts();
        if (fallback.isNotEmpty) {
          return fallback.map((e) => e.toEntity()).toList();
        } else {
          throw Exception('Gagal fetch remote dan cache kosong.');
        }
      } catch (e2) {
        throw Exception('Gagal ambil data: $e2');
      }
    }
  }

  @override
  Future<Product> fetchProductById(int id) async {
    try {
      AppLogger.d('Mengambil detail produk $id dari remote.');
      final remoteProduct = await remoteDataSource.fetchProductById(id);
      await localDataSource.cacheProduct(remoteProduct.toCollection());
      return remoteProduct.toEntity();
    } on NetworkException catch (e) {
      AppLogger.d(
          'Error jaringan: ${e.message}. Mengambil detail produk $id dari cache sebagai fallback.');
      try {
        final local = await localDataSource.getCachedProductById(id);
        if (local != null) {
          return local.toEntity();
        } else {
          throw NetworkException(
              'Tidak ada koneksi dan detail produk $id tidak ada di cache.');
        }
      } on CacheException catch (e) {
        throw CacheException(
            'Gagal mengambil detail produk $id dari cache: ${e.message}');
      }
    } catch (e) {
      AppLogger.d(
          'Terjadi error tak terduga saat fetch detail produk $id dari remote: $e. Mencoba dari cache.');
      try {
        final local = await localDataSource.getCachedProductById(id);
        if (local != null) {
          return local.toEntity();
        } else {
          rethrow;
        }
      } on CacheException catch (e) {
        throw CacheException(
            'Gagal mengambil detail produk $id dari cache setelah error tak terduga: ${e.message}');
      }
    }
  }

  @override
  Future<void> addProduct(Product product) async {
    AppLogger.d('Menambahkan produk: ${product.id}');
    final model = ProductModel.fromEntity(product);
    AppLogger.d('Menambahkan produk: ${model.id}');

    final collection = model.toCollection();
    try {
      await remoteDataSource.addProduct(model);
      await localDataSource
          .insertProduct(collection); // Pastikan konsisten di lokal
      AppLogger.d('Produk berhasil ditambahkan di remote dan lokal.');
    } on NetworkException catch (e) {
      throw NetworkException(
          'Gagal menambahkan produk (jaringan/server error): ${e.message}');
    } catch (e) {
      throw Exception('Gagal menambahkan produk: $e');
    }
  }

  @override
  Future<void> updateProduct(Product product) async {
    final model = ProductModel.fromEntity(product);
    final collection = model.toCollection();
    AppLogger.d('Memperbarui produk: ${product.id}');
    try {
      await remoteDataSource.updateProduct(product.id, model);
      await localDataSource
          .updateProduct(collection);
      AppLogger.d('Produk  berhasil diperbarui di remote dan lokal.');
    } on NetworkException catch (e) {
      throw NetworkException(
          'Gagal memperbarui produk (jaringan/server error): ${e.message}');
    } catch (e) {
      throw Exception('Gagal memperbarui produk: $e');
    }
  }

  @override
  Future<void> deleteProduct(int id) async {
    try {
      await remoteDataSource.deleteProduct(id);
      await localDataSource.deleteProduct(id);
      AppLogger.d('Produk $id berhasil dihapus dari remote dan lokal.');
    } on NetworkException catch (e) {
      throw NetworkException(
          'Gagal menghapus produk (jaringan/server error): ${e.message}');
    } catch (e) {
      throw Exception('Gagal menghapus produk: $e');
    }
  }
}
