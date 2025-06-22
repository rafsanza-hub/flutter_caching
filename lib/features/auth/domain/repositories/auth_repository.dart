import 'package:flutter_caching/features/auth/domain/entities/auth.dart';

abstract class AuthRepository {
  Future<void> logout();
  Future<Auth> login(String email, String password);
  Future<Auth?> checkAuthStatus();
}
