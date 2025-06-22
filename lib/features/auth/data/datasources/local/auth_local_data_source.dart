import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_caching/features/auth/data/models/auth_response_model.dart';

abstract class AuthLocalDataSource {
  Future<void> cacheAuthData(AuthResponseModel authModel);
  Future<AuthResponseModel?> getCachedAuthData();
  Future<void> clearCachedAuthData();
}

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  final FlutterSecureStorage secureStorage;

  AuthLocalDataSourceImpl({required this.secureStorage});

  @override
  Future<void> cacheAuthData(AuthResponseModel authModel) async {
    await secureStorage.write(
      key: 'AUTH_DATA',
      value: jsonEncode(authModel.toJson()),
    );
  }

  @override
  Future<AuthResponseModel?> getCachedAuthData() async {
    final jsonString = await secureStorage.read(key: 'AUTH_DATA');
    if (jsonString != null) {
      return AuthResponseModel.fromJson(jsonDecode(jsonString));
    }
    return null;
  }

  @override
  Future<void> clearCachedAuthData() async {
    await secureStorage.delete(key: 'AUTH_DATA');
  }
}