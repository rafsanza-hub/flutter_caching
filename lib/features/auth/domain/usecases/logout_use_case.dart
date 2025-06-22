import 'package:flutter_caching/features/auth/domain/repositories/auth_repository.dart';

class LogoutUseCase {
  final AuthRepository _repository;

  LogoutUseCase(this._repository);
  Future<void> call() {
    return _repository.logout();
  }
}
