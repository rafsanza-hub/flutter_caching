import 'package:flutter_caching/features/auth/domain/entities/auth.dart';
import 'package:flutter_caching/features/auth/domain/repositories/auth_repository.dart';

class CheckAuthStatusUseCase {
  final AuthRepository _repository;
  CheckAuthStatusUseCase(this._repository);

  Future<Auth?> call() {
    return _repository.checkAuthStatus();
  }
}
