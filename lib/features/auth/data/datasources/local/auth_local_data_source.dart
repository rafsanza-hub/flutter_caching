import 'package:flutter_caching/core/services/secure_storage_service.dart';
import 'package:flutter_caching/features/auth/data/models/auth_response_model.dart';

abstract class AuthLocalDataSource {
  Future<void> cacheAuthData(AuthResponseModel authModel);
  Future<AuthResponseModel?> getCachedAuthData();
  Future<void> clearCachedAuthData();
}


class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  final SecureStorageService _secureStorageService;

  AuthLocalDataSourceImpl({required SecureStorageService secureStorageService})
      : _secureStorageService = secureStorageService;

  @override
  Future<void> cacheAuthData(AuthResponseModel authModel) async {
    // Fokus hanya pada tugas menyimpan token melalui service
    await _secureStorageService.saveToken(authModel.accessToken);
  }

  @override
  Future<AuthResponseModel?> getCachedAuthData() async {
    // Ambil token melalui service
    final token = await _secureStorageService.getToken();

    if (token != null) {
      // Jika token ada, buat kembali model responsnya.
      return AuthResponseModel(accessToken: token);
    }

    // Jika tidak ada token, kembalikan null.
    return null;
  }

  @override
  Future<void> clearCachedAuthData() async {
    await _secureStorageService.deleteToken();
  }
}
