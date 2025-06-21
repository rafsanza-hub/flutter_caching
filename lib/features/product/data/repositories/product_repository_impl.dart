import 'package:flutter_caching/core/error/exception.dart';
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
    if (!forceRefresh) {
      try {
        final cachedProducts = await localDataSource.getCachedProducts();
        final lastCacheTime = await localDataSource.getLastCacheTimestamp();

        if (cachedProducts.isNotEmpty && lastCacheTime != null &&
            DateTime.now().difference(lastCacheTime) < cacheTTL) {
          print('Mengambil produk dari cache lokal yang valid.');
          return cachedProducts.map((e) => e.toEntity()).toList();
        } else if (cachedProducts.isNotEmpty && lastCacheTime != null &&
                   DateTime.now().difference(lastCacheTime) >= cacheTTL) {
          print('Cache lokal kadaluwarsa, akan mencoba ambil dari remote.');
        }
      } on CacheException catch (e) {
        print('Error membaca dari cache: ${e.message}. Mencoba dari remote.');
        
      } catch (e) {
        print('Terjadi error tak terduga saat membaca cache: $e. Mencoba dari remote.');
      }
    }

    // Ambil dari remote dan perbarui cache
    try {
      print('Mengambil produk dari remote.');
      final remoteProducts = await remoteDataSource.fetchProducts();
      // Simpan ke lokal cache dan perbarui timestamp
      await localDataSource.cacheProducts(remoteProducts.map((e) => e.toCollection()).toList());
      await localDataSource.updateLastCacheTimestamp(DateTime.now()); // Simpan timestamp
      return remoteProducts.map((e) => e.toEntity() ).toList();
    } on NetworkException catch (e) {
      print('Error jaringan: ${e.message}. Mengambil dari cache sebagai fallback.');
      try {
        final localProducts = await localDataSource.getCachedProducts();
        if (localProducts.isNotEmpty) {
          return localProducts.map((e) => e.toEntity()).toList();
        } else {
          // Jika tidak ada di cache sama sekali, lempar error asli
          throw NetworkException('Tidak ada koneksi dan tidak ada data yang di-cache.');
        }
      } on CacheException catch (e) {
        throw CacheException('Gagal mengambil dari cache setelah error jaringan: ${e.message}');
      }
    } catch (e) {
      print('Terjadi error tak terduga saat fetch dari remote: $e. Mencoba dari cache.');
      try {
        final localProducts = await localDataSource.getCachedProducts();
        if (localProducts.isNotEmpty) {
          return localProducts.map((e) => e.toEntity()).toList();
        } else {
          rethrow; // Lempar error asli jika tidak ada data di cache
        }
      } on CacheException catch (e) {
        throw CacheException('Gagal mengambil dari cache setelah error tak terduga: ${e.message}');
      }
    }
  }


  @override
  Future<Product> fetchProductById(String id) async {
    try {
      print('Mengambil detail produk $id dari remote.');
      final remoteProduct = await remoteDataSource.fetchProductById(id);
      await localDataSource.cacheProduct(remoteProduct.toCollection());
      return remoteProduct.toEntity();
    } on NetworkException catch (e) {
      print('Error jaringan: ${e.message}. Mengambil detail produk $id dari cache sebagai fallback.');
      try {
        final local = await localDataSource.getCachedProductById(id);
        if (local != null) {
          return local.toEntity();
        } else {
          throw NetworkException('Tidak ada koneksi dan detail produk $id tidak ada di cache.');
        }
      } on CacheException catch (e) {
        throw CacheException('Gagal mengambil detail produk $id dari cache: ${e.message}');
      }
    } catch (e) {
      print('Terjadi error tak terduga saat fetch detail produk $id dari remote: $e. Mencoba dari cache.');
      try {
        final local = await localDataSource.getCachedProductById(id);
        if (local != null) {
          return local.toEntity();
        } else {
          rethrow; 
        }
      } on CacheException catch (e) {
        throw CacheException('Gagal mengambil detail produk $id dari cache setelah error tak terduga: ${e.message}');
      }
    }
  }


  @override
  Future<void> addProduct(Product product) async {
    final model = ProductModel.fromEntity(product);
    final collection = model.toCollection();
    try {
      await remoteDataSource.addProduct(model);
      await localDataSource.insertProduct(collection); // Pastikan konsisten di lokal
      print('Produk berhasil ditambahkan di remote dan lokal.');
    } on NetworkException catch (e) {
      throw NetworkException('Gagal menambahkan produk (jaringan/server error): ${e.message}');
    } catch (e) {
      throw Exception('Gagal menambahkan produk: $e');
    }
  }

  @override
  Future<void> updateProduct(Product product) async {
    final model = ProductModel.fromEntity(product);
    final collection = model.toCollection();
    try {
      await remoteDataSource.updateProduct(product.id, model);
      await localDataSource.updateProduct(collection); // Pastikan konsisten di lokal
      print('Produk  berhasil diperbarui di remote dan lokal.');
    } on NetworkException catch (e) {
      throw NetworkException('Gagal memperbarui produk (jaringan/server error): ${e.message}');
    } catch (e) {
      throw Exception('Gagal memperbarui produk: $e');
    }
  }

  @override
  Future<void> deleteProduct(String id) async {
    try {
      await remoteDataSource.deleteProduct(id);
      await localDataSource.deleteProduct(id); 
      print('Produk $id berhasil dihapus dari remote dan lokal.');
    } on NetworkException catch (e) {
      throw NetworkException('Gagal menghapus produk (jaringan/server error): ${e.message}');
    } catch (e) {
      throw Exception('Gagal menghapus produk: $e');
    }
  }
}