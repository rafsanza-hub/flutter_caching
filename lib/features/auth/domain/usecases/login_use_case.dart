import 'package:flutter_caching/features/auth/domain/entities/auth.dart';
import 'package:flutter_caching/features/auth/domain/repositories/auth_repository.dart';

class LoginUseCase {
  final AuthRepository _repository;

  LoginUseCase(this._repository);

  Future<Auth> call(String email, String password) {
    return _repository.login(email, password);
  }
}
