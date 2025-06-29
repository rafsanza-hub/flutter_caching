import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageService {
  final FlutterSecureStorage _storage;

  static const _keyJwt = 'jwt_token';

  SecureStorageService({required FlutterSecureStorage storage}) : _storage = storage;

  Future<void> saveToken(String token) async {
    await _storage.write(key: _keyJwt, value: token);
  }

  Future<String?> getToken() async {
    return await _storage.read(key: _keyJwt);
  }

  Future<void> deleteToken() async {
    await _storage.delete(key: _keyJwt);
  }
}
