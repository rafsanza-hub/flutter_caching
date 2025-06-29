import 'package:flutter_caching/core/dependencies/dependencies.dart';
import 'package:flutter_caching/core/services/secure_storage_service.dart';
import 'package:flutter_caching/features/auth/data/models/auth_response_model.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

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
    // Simpan token menggunakan service
    await _secureStorageService.saveToken(authModel.accessToken);
    // Simpan data user di tempat lain jika perlu (misalnya SharedPreferences atau Isar)
    // Untuk saat ini, kita akan menyimpannya juga di secure storage untuk kesederhanaan
    // await _secureStorageService.getStorage().write(key: 'user_data', value: jsonEncode(authModel.user.toJson()));
  }

  @override
  Future<AuthResponseModel?> getCachedAuthData() async {
    final token = await _secureStorageService.getToken();
    final userDataString = await _secureStorageService.getStorage().read(key: 'user_data');

    if (token != null && userDataString != null) {
      // final user = UserModel.fromJson(jsonDecode(userDataString));
      return AuthResponseModel(accessToken: token,);
    }
    return null;
  }

  @override
  Future<void> clearCachedAuthData() async {
    await _secureStorageService.deleteToken();
    await _secureStorageService.getStorage().delete(key: 'user_data');
  }
}

// Tambahkan extension pada SecureStorageService untuk mendapatkan instance storage
extension SecureStorageServiceExtension on SecureStorageService {
    FlutterSecureStorage getStorage() {
        return getIt<FlutterSecureStorage>();
    }
}