# Implementasi Sistem Caching Flutter

## Overview
Sistem caching ini mengimplementasikan beberapa strategi dan fitur utama:
- **Cache-First** untuk operasi read (fokus performa)
- **Remote/Network-First** untuk operasi write (fokus konsistensi)
- **TTL-based cache invalidation** (default 30 menit)
- **Fallback mechanisms** untuk dukungan offline

## Arsitektur

```
lib
├── core
│   ├── dependencies
│   │   ├── dependencies.dart
│   │   └── dependencies_main.dart
│   ├── error
│   │   └── exception.dart
│   ├── network
│   │   └── jwt_interceptor.dart
│   ├── services
│   │   └── secure_storage_service.dart
│   └── utils
│       └── logger.dart
├── features
│   ├── auth
│   │   ├── data
│   │   │   ├── datasources
│   │   │   │   ├── local
│   │   │   │   │   └── auth_local_data_source.dart
│   │   │   │   └── remote
│   │   │   │       └── auth_remote_data_source.dart
│   │   │   ├── models
│   │   │   │   ├── auth_response_model.dart
│   │   │   │   └── user_model.dart
│   │   │   └── repositories
│   │   │       └── auth_repository_impl.dart
│   │   ├── domain
│   │   │   ├── entities
│   │   │   │   ├── auth.dart
│   │   │   │   └── user.dart
│   │   │   ├── repositories
│   │   │   │   └── auth_repository.dart
│   │   │   └── usecases
│   │   │       ├── check_auth_status_use_case.dart
│   │   │       ├── login_use_case.dart
│   │   │       └── logout_use_case.dart
│   │   └── presentation
│   │       ├── pages
│   │       │   └── login_page.dart
│   │       └── provider
│   │           └── auth_provider.dart
│   └── product
│       ├── data
│       │   ├── collections
│       │   │   ├── cache_collection.dart
│       │   │   ├── cache_collection.g.dart
│       │   │   ├── product_collection.dart
│       │   │   └── product_collection.g.dart
│       │   ├── datasources
│       │   │   ├── local
│       │   │   │   ├── product_local_data_source.dart
│       │   │   │   └── product_local_data_source_impl.dart
│       │   │   └── remote
│       │   │       ├── product_remote_data_source.dart
│       │   │       └── product_remote_data_source.g.dart
│       │   ├── models
│       │   │   └── product_model.dart
│       │   └── repositories
│       │       └── product_repository_impl.dart
│       ├── domain
│       │   ├── entities
│       │   │   └── product.dart
│       │   ├── repositories
│       │   │   └── product_repository.dart
│       │   └── usecases
│       │       ├── add_product_use_case.dart
│       │       ├── delete_product_use_case.dart
│       │       ├── fetch_product_by_id_use_case.dart
│       │       ├── fetch_product_use_case.dart
│       │       └── update_product_use_case.dart
│       └── presentation
│           ├── pages
│           │   ├── product_detail_page.dart
│           │   └── product_list_page.dart
│           └── providers
│               ├── product_detail_provider.dart
│               └── product_provider.dart
└── main.dart
```

## Strategi Caching per Operasi CRUD

### 📖 Operasi READ - Strategi Cache-First

#### `fetchProducts()` - Cache-First + TTL + Fallback
```dart
Future<List<Product>> fetchProducts({bool forceRefresh = false}) async {
  // 1. Cache-First: Cek cache dulu (kecuali ada force refresh)
  if (!forceRefresh) {
    final lastCacheTime = await localDataSource.getLastCacheTimestamp();
    if (lastCacheTime != null &&
        DateTime.now().difference(lastCacheTime) < cacheTTL) {
      final cachedProducts = await localDataSource.getCachedProducts();
      if (cachedProducts.isNotEmpty) {
        AppLogger.d('[Repository] Data valid dari cache');
        return cachedProducts.map((p) => p.toEntity()).toList(); // CACHE HIT
      }
    }
  }

  // 2. Cache miss/expired: Ambil dari remote
  try {
    final remoteProducts = await remoteDataSource.fetchProducts();
    // Write-through: Update cache setelah berhasil fetch dari remote
    await localDataSource.cacheProducts(remoteProducts.map((p) => p.toCollection()).toList());
    await localDataSource.updateLastCacheTimestamp(DateTime.now());
    return remoteProducts.map((p) => p.toEntity()).toList();
  } catch (e) {
    // 3. Fallback: Gunakan cache sebagai backup ketika remote gagal
    final cachedProducts = await localDataSource.getCachedProducts();
    if (cachedProducts.isNotEmpty) {
      return cachedProducts.map((p) => p.toEntity()).toList(); // FALLBACK SUCCESS
    }
    throw Exception('Gagal mengambil dari server dan cache kosong.');
  }
}
```

**Komponen Strategi:**
- ✅ **Cache-First**: Prioritas ke data cache
- ✅ **TTL (30 menit)**: Cache otomatis expired
- ✅ **Write-Through**: Update cache setelah remote berhasil
- ✅ **Fallback**: Cache sebagai backup saat remote gagal

#### `fetchProductById()` - Cache-First untuk Item Tunggal
```dart
Future<Product> fetchProductById(int id) async {
  try {
    // 1. Cache-First: Cek cache produk individual
    final cachedProduct = await localDataSource.getCachedProductById(id);
    if (cachedProduct != null) {
      return cachedProduct.toEntity(); // CACHE HIT
    }

    // 2. Cache miss: Ambil dari remote
    final remoteProduct = await remoteDataSource.fetchProductById(id);
    
    // 3. Write-through: Simpan ke cache setelah berhasil fetch
    await localDataSource.cacheProduct(remoteProduct.toCollection());
    return remoteProduct.toEntity();
  } catch (e) {
    throw Exception('Gagal mengambil produk. Periksa koneksi Anda.');
  }
}
```

**Komponen Strategi:**
- ✅ **Cache-First**: Cek cache sebelum remote
- ✅ **Write-Through**: Update cache setelah remote fetch

### ➕ Operasi CREATE - Strategi Remote-First

```dart
Future<void> addProduct(Product product) async {
  final model = ProductModel.fromEntity(product);
  
  try {
    // 1. Remote-First: Kirim ke server DULU (source of truth)
    await remoteDataSource.addProduct(model);

    // 2. Write-Through: Update cache HANYA setelah remote berhasil
    await localDataSource.insertProduct(model.toCollection());
    
    AppLogger.d('Produk berhasil ditambahkan ke server dan disinkronkan ke cache.');
  } catch (e) {
    // 3. Atomic: Jika remote gagal, cache tetap tidak berubah
    throw Exception('Gagal menambahkan produk. Pastikan Anda terhubung ke internet.');
  }
}
```

**Komponen Strategi:**
- ✅ **Remote-First**: Server sebagai source of truth
- ✅ **Write-Through**: Update cache setelah remote berhasil
- ✅ **Strong Consistency**: Cache selalu konsisten dengan server

### ✏️ Operasi UPDATE - Strategi Remote-First

```dart
Future<void> updateProduct(Product product) async {
  final model = ProductModel.fromEntity(product);
  
  try {
    // 1. Remote-First: Update server DULU
    await remoteDataSource.updateProduct(product.id, model);

    // 2. Write-Through: Update cache HANYA setelah remote berhasil
    await localDataSource.updateProduct(model.toCollection());
    
    AppLogger.d('Produk ${product.id} berhasil diperbarui di server dan disinkronkan ke cache.');
  } catch (e) {
    // 3. Konsistensi: Jika remote gagal, cache tetap tidak berubah
    throw Exception('Gagal memperbarui produk. Pastikan Anda terhubung ke internet.');
  }
}
```

**Komponen Strategi:**
- ✅ **Remote-First**: Update server diprioritaskan
- ✅ **Write-Through**: Update cache setelah remote berhasil
- ✅ **Jaminan Konsistensi**: Cache tidak akan out-of-sync
- ✅ **Error Isolation**: Kegagalan remote tidak mempengaruhi integritas cache

### 🗑️ Operasi DELETE - Strategi Remote-First

```dart
Future<void> deleteProduct(int id) async {
  try {
    // 1. Remote-First: Hapus dari server DULU
    await remoteDataSource.deleteProduct(id);

    // 2. Cache Invalidation: Hapus dari cache HANYA setelah remote berhasil
    await localDataSource.deleteProduct(id);
    
    AppLogger.d('Produk $id berhasil dihapus dari server dan disinkronkan ke cache.');
  } catch (e) {
    // 3. Integritas Data: Jika remote gagal, data tetap ada di cache
    throw Exception('Gagal menghapus produk. Pastikan Anda terhubung ke internet.');
  }
}
```



**Komponen Strategi:**
- ✅ **Remote-First**: Delete server diprioritaskan
- ✅ **Cache Invalidation**: Hapus dari cache setelah remote berhasil
- ✅ **Integritas Data**: Tidak ada data orphan di cache
- ✅ **Atomic Delete**: Operasi delete all-or-nothing

## Ringkasan Strategi

| Operasi | Strategi Utama | Strategi Kedua | Fallback | Konsistensi |
|---------|----------------|----------------|----------|-------------|
| **READ (List)** | Cache-First + TTL | Write-Through | Cache Fallback | Eventual |
| **READ (Single)** | Cache-First | Write-Through | Tidak Ada | Eventual |
| **CREATE** | Remote-First | Write-Through | Tidak Ada | Strong |
| **UPDATE** | Remote-First | Write-Through | Tidak Ada | Strong |
| **DELETE** | Remote-First | Cache Invalidation | Tidak Ada | Strong |

## Mengapa Strategi Berbeda?

### Operasi READ → Cache-First
- **Performa**: Hindari network call yang tidak perlu
- **Dukungan Offline**: App tetap jalan tanpa internet
- **Efisiensi**: Kurangi penggunaan data
- **User Experience**: Response time lebih cepat

### Operasi WRITE → Remote-First
- **Integritas Data**: Server sebagai single source of truth
- **Konsistensi**: Mencegah cache-server tidak sinkron
- **Reliabilitas**: Pastikan operasi benar-benar berhasil
- **Pencegahan Konflik**: Hindari conflict resolution yang kompleks



---

## Implementasi image caching dengan CachedNetworkImage

```dart
CachedNetworkImage(
  imageUrl: product.imageUrl,
  cacheKey: 'product_${product.id}_image',
  width: 50,
  height: 50,
  fit: BoxFit.cover,
  memCacheWidth: 50,    // Optimasi memory cache
  memCacheHeight: 50,   // Optimasi memory cache
  maxWidthDiskCache: 100,  // Optimasi disk cache
  maxHeightDiskCache: 100, // Optimasi disk cache
  placeholder: (context, url) => Container(
    width: 50,
    height: 50,
    color: Colors.grey[300],
    child: const Center(
      child: CircularProgressIndicator(strokeWidth: 2),
    ),
  ),
  errorWidget: (context, url, error) => Container(
    width: 50,
    height: 50,
    color: Colors.grey[300],
    child: const Icon(Icons.broken_image, color: Colors.red),
  ),
)
```

## Fitur Image Caching

### Memory Cache
- **memCacheWidth** dan **memCacheHeight** mengoptimalkan penggunaan memori
- Gambar disimpan dalam format yang sudah di-resize
- Mengurangi beban memori dengan menyimpan gambar sesuai ukuran yang dibutuhkan

### Disk Cache
- **maxWidthDiskCache** dan **maxHeightDiskCache** mengoptimalkan penyimpanan lokal
- **cacheKey** unik berdasarkan ID produk memastikan cache yang tepat
- Mempercepat loading gambar pada akses selanjutnya

### Placeholder
- Tampilan loading yang konsisten selama pengambilan gambar
- Desain minimalis dengan progress indicator
- Memberikan feedback visual kepada pengguna

### Error Handling
- Tampilan error yang jelas ketika gambar gagal dimuat
- Ikon broken image dengan warna merah untuk indikasi visual
- Fallback yang user-friendly untuk pengalaman yang lebih baik

## Optimasi Performa

### Resizing Otomatis
- Gambar di-resize sebelum disimpan ke cache
- Mengurangi penggunaan bandwidth dan storage
- Mempercepat waktu loading

### Cache Management
- Penggunaan cache yang efisien untuk thumbnail
- Otomatis mengelola storage space
- Pembersihan cache otomatis
