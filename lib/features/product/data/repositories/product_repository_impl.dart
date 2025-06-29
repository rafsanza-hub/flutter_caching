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

  // Di dalam ProductRepositoryImpl

  @override
  Future<List<Product>> fetchProducts({bool forceRefresh = false}) async {
    // 1. Cek cache jika tidak ada paksaan refresh
    if (!forceRefresh) {
      final lastCacheTime = await localDataSource.getLastCacheTimestamp();
      if (lastCacheTime != null &&
          DateTime.now().difference(lastCacheTime) < cacheTTL) {
        final cachedProducts = await localDataSource.getCachedProducts();
        if (cachedProducts.isNotEmpty) {
          AppLogger.d('[Repository] Data valid dari cache');
          return cachedProducts.map((p) => p.toEntity()).toList();
        }
      }
    }

    // 2. Jika cache tidak valid atau ada paksaan refresh, ambil dari remote
    try {
      AppLogger.d('[Repository] Mengambil dari remote');
      final remoteProducts = await remoteDataSource.fetchProducts();

      // Hapus cache lama dan simpan yang baru
      await localDataSource
          .cacheProducts(remoteProducts.map((p) => p.toCollection()).toList());
      await localDataSource.updateLastCacheTimestamp(DateTime.now());

      return remoteProducts.map((p) => p.toEntity()).toList();
    } catch (e) {
      // 3. Jika remote gagal, fallback ke cache sebagai upaya terakhir
      AppLogger.e(
          '[Repository] Gagal mengambil dari remote: $e. Fallback ke cache.');
      final cachedProducts = await localDataSource.getCachedProducts();
      if (cachedProducts.isNotEmpty) {
        return cachedProducts.map((p) => p.toEntity()).toList();
      }
      // Jika remote dan cache gagal, lempar error
      throw Exception('Gagal mengambil data dari server dan cache kosong.');
    }
  }

  @override
  Future<Product> fetchProductById(int id) async {
    try {
      // 1. Coba ambil dari cache dulu
      final cachedProduct = await localDataSource.getCachedProductById(id);
      if (cachedProduct != null) {
        AppLogger.d('Produk $id ditemukan di cache.');
        return cachedProduct.toEntity();
      }

      // 2. Jika cache tidak ada, ambil dari remote
      AppLogger.d('Produk $id tidak ada di cache. Mengambil dari remote.');
      final remoteProduct = await remoteDataSource.fetchProductById(id);

      // 3. Simpan ke cache dan kembalikan
      await localDataSource.cacheProduct(remoteProduct.toCollection());
      return remoteProduct.toEntity();
    } catch (e) {
      AppLogger.e('Gagal mengambil produk $id: $e');
      throw Exception('Gagal mengambil produk. Periksa koneksi Anda.');
    }
  }

  @override
  Future<void> addProduct(Product product) async {
    final model = ProductModel.fromEntity(product);
    AppLogger.d('Mencoba menambahkan produk ke server: ${product.id}');

    try {
      // Langkah 1: Kirim data ke server terlebih dahulu.
      // Ini adalah operasi yang paling krusial.
      await remoteDataSource.addProduct(model);

      // Langkah 2: HANYA JIKA remote berhasil, perbarui cache lokal.
      // Ini memastikan cache lokal tidak akan memiliki data
      // yang sebenarnya tidak pernah berhasil disimpan di server.
      await localDataSource.insertProduct(model.toCollection());

      AppLogger.d(
          'Produk berhasil ditambahkan di server dan disinkronkan ke cache.');
    } catch (e) {
      // Langkah 3: Jika terjadi error APAPUN, tangkap dan lempar satu exception yang jelas.
      AppLogger.e('Gagal total saat menambahkan produk: $e');
      throw Exception(
          'Gagal menambahkan produk. Pastikan Anda terhubung ke internet.');
    }
  }

  @override
  Future<void> updateProduct(Product product) async {
    final model = ProductModel.fromEntity(product);
    AppLogger.d('Mencoba memperbarui produk di server: ${product.id}');

    try {
      // Langkah 1: Lakukan pembaruan di server terlebih dahulu.
      // Ini adalah operasi kritis yang menentukan kebenaran data.
      await remoteDataSource.updateProduct(product.id, model);

      // Langkah 2: HANYA JIKA remote berhasil, perbarui cache lokal.
      // Ini memastikan cache selalu sinkron dengan state terakhir yang berhasil di server.
      await localDataSource.updateProduct(model.toCollection());

      AppLogger.d(
          'Produk ${product.id} berhasil diperbarui di server dan disinkronkan ke cache.');
    } catch (e) {
      // Langkah 3: Jika terjadi error APAPUN (jaringan, server, dll.),
      // tangkap dan lempar satu exception yang terpadu.
      AppLogger.e('Gagal total saat memperbarui produk ${product.id}: $e');
      throw Exception(
          'Gagal memperbarui produk. Pastikan Anda terhubung ke internet.');
    }
  }

  @override
  Future<void> deleteProduct(int id) async {
    AppLogger.d('Mencoba menghapus produk di server: $id');

    try {
      // Langkah 1: Hapus dari server terlebih dahulu.
      // Ini adalah langkah kritis yang menentukan keberhasilan operasi.
      await remoteDataSource.deleteProduct(id);

      // Langkah 2: HANYA JIKA remote berhasil, hapus dari cache lokal.
      // Ini menjamin cache lokal tidak akan salah (misalnya, masih menyimpan
      // produk yang sebenarnya sudah terhapus di server).
      await localDataSource.deleteProduct(id);

      AppLogger.d(
          'Produk $id berhasil dihapus dari server dan disinkronkan ke cache.');
    } catch (e) {
      // Langkah 3: Jika terjadi error APAPUN saat menghubungi server,
      // batalkan seluruh operasi dan lempar satu exception.
      AppLogger.e('Gagal total saat menghapus produk $id: $e');
      throw Exception(
          'Gagal menghapus produk. Pastikan Anda terhubung ke internet.');
    }
  }
}
