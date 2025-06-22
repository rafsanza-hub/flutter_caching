import 'package:flutter_caching/core/error/exception.dart';
import 'package:flutter_caching/core/utils/logger.dart';
import 'package:flutter_caching/features/product/data/collections/cache_collection.dart';
import 'package:flutter_caching/features/product/data/collections/product_collection.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'product_local_data_source.dart';


class ProductLocalDataSourceImpl implements ProductLocalDataSource {
  static late final Future<Isar> _isarDb;
  static bool _isInitialized = false;

  static const int _productsListCacheTimestampId = 0;

  // Constructor
  ProductLocalDataSourceImpl() {
    if (!_isInitialized) {
      _isarDb = _openIsar();
      _isInitialized = true;
    }
  }

  Future<Isar> _openIsar() async {
    try {
      if (Isar.instanceNames.isNotEmpty && Isar.getInstance() != null) {
        return Isar.getInstance()!; // Menggunakan null safety operator
      }
      final dir = await getApplicationDocumentsDirectory();
      return Isar.open(
        [
          ProductCollectionSchema,
          CacheTimestampCollectionSchema
        ], // Tambahkan skema baru
        directory: dir.path,
        inspector: true,
      );
    } catch (e) {
      throw CacheException('Gagal membuka database Isar: $e');
    }
  }

  @override
  Future<void> cacheProducts(List<ProductCollection> products) async {
    try {
      final isar = await _isarDb;
      await isar.writeTxn(() async {
        // Hapus semua produk lama sebelum memasukkan yang baru untuk menjaga konsistensi
        await isar.productCollections.clear();
        await isar.productCollections.putAll(products);
      });
      AppLogger.d('Produk berhasil di-cache di Isar.');
    } catch (e) {
      throw CacheException('Gagal melakukan cache produk: $e');
    }
  }

  @override
  Future<void> insertProduct(ProductCollection product) async {
    try {
      final isar = await _isarDb;
      await isar.writeTxn(() async {
        await isar.productCollections.put(product);
      });
      AppLogger.d(
          'Produk berhasil disisipkan/diperbarui di cache Isar: ${product.id}');
    } catch (e) {
      throw CacheException('Gagal menyisipkan/memperbarui produk di cache: $e');
    }
  }

  @override
  Future<void> cacheProduct(ProductCollection product) async {
    try {
      final isar = await _isarDb;
      await isar.writeTxn(() async {
        await isar.productCollections.put(product);
      });
      AppLogger.d('Produk individual berhasil di-cache di Isar: ${product.id}');
    } catch (e) {
      throw CacheException('Gagal melakukan cache produk individual: $e');
    }
  }

  @override
  Future<void> updateProduct(ProductCollection product) async {
    return insertProduct(product);
  }

  @override
  Future<void> deleteProduct(String id) async {
    try {
      final isar = await _isarDb;
      await isar.writeTxn(() async {
        final deletedCount = await isar.productCollections
            .filter()
            .idEqualTo(id)
            .deleteAll();
        if (deletedCount == 0) {
          AppLogger.d('Produk dengan ID $id tidak ditemukan di cache untuk dihapus.');
        } else {
          AppLogger.d('Produk dengan ID $id berhasil dihapus dari cache Isar.');
        }
      });
    } catch (e) {
      throw CacheException('Gagal menghapus produk dari cache: $e');
    }
  }

  @override
  Future<ProductCollection?> getCachedProductById(String id) async {
    try {
      final isar = await _isarDb;
      final product = await isar.productCollections.get(int.parse(id));
      if (product == null) {
        AppLogger.d('Produk $id tidak ditemukan di cache.');
      } else {
        AppLogger.d('Produk $id ditemukan di cache.');
      }
      return product;
    } catch (e) {
      throw CacheException('Gagal mengambil produk $id dari cache: $e');
    }
  }

  @override
  Future<List<ProductCollection>> getCachedProducts() async {
    try {
      final isar = await _isarDb;
      final products = await isar.productCollections.where().findAll();
      AppLogger.d('Mengambil ${products.length} produk dari cache.');
      return products;
    } catch (e) {
      throw CacheException('Gagal mengambil daftar produk dari cache: $e');
    }
  }

  @override
  Future<void> updateLastCacheTimestamp(DateTime timestamp) async {
    try {
      final isar = await _isarDb;
      await isar.writeTxn(() async {
        final cacheEntry = await isar.cacheTimestampCollections
            .filter()
            .cacheIdEqualTo(_productsListCacheTimestampId)
            .findFirst();

        if (cacheEntry != null) {
          cacheEntry.timestamp = timestamp;
          await isar.cacheTimestampCollections.put(cacheEntry);
        } else {
          await isar.cacheTimestampCollections.put(
            CacheTimestampCollection(
              cacheId: _productsListCacheTimestampId,
              timestamp: timestamp,
            ),
          );
        }
      });
      AppLogger.d('Timestamp cache daftar produk berhasil diperbarui.');
    } catch (e) {
      throw CacheException('Gagal memperbarui timestamp cache: $e');
    }
  }

  @override
  Future<DateTime?> getLastCacheTimestamp() async {
    try {
      final isar = await _isarDb;
      final cacheEntry = await isar.cacheTimestampCollections
          .filter()
          .cacheIdEqualTo(_productsListCacheTimestampId)
          .findFirst();
      if (cacheEntry != null) {
        AppLogger.d('Timestamp cache ditemukan: ${cacheEntry.timestamp}');
      } else {
        AppLogger.d('Timestamp cache tidak ditemukan.');
      }
      return cacheEntry?.timestamp;
    } catch (e) {
      throw CacheException('Gagal mengambil timestamp cache: $e');
    }
  }
}
