import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_caching/core/services/secure_storage_service.dart';
import 'package:flutter_caching/features/auth/presentation/provider/auth_provider.dart';
import 'package:get_it/get_it.dart';

class JwtInterceptor extends Interceptor {
  final SecureStorageService _secureStorageService;

  JwtInterceptor(this._secureStorageService);

  @override
  Future<void> onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    // Daftar endpoint yang tidak memerlukan token otentikasi
    final excludedPaths = ['/login', '/register'];

    // Periksa apakah path permintaan termasuk dalam daftar yang dikecualikan
    if (excludedPaths.any((path) => options.path.endsWith(path))) {
      debugPrint(
          '[Dio Interceptor] Path ${options.path} dikecualikan. Request diteruskan tanpa token.');
      return handler.next(options); // Lanjutkan tanpa token
    }

    // Ambil token dari secure storage
    final token = await _secureStorageService.getToken();

    if (token != null && token.isNotEmpty) {
      debugPrint(
          '[Dio Interceptor] Token ditemukan. Menambahkan header Authorization ke ${options.path}.');
      // Tambahkan header Authorization
      options.headers['Authorization'] = 'Bearer $token';
    } else {
      debugPrint(
          '[Dio Interceptor] Tidak ada token. Request ke ${options.path} dikirim tanpa token.');
    }

    // Lanjutkan permintaan
    return handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    debugPrint(
        '[Dio Interceptor] ERROR[${err.response?.statusCode}] => PATH: ${err.requestOptions.path}');
    if (err.response != null) {
      debugPrint('[Dio Interceptor] ERROR RESPONSE: ${err.response?.data}');
    }

    // Deteksi token expired / tidak valid
    if (err.response?.statusCode == 401 || err.response?.statusCode == 403) {
      debugPrint(
          '[Dio Interceptor] Token kadaluarsa atau tidak valid. Melakukan logout...');

      // Hapus token dari secure storage
      await _secureStorageService.deleteToken();
      GetIt.instance<AuthProvider>().logout();
    }

    return super.onError(err, handler);
  }
}
