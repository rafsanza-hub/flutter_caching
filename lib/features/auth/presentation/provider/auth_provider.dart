import 'package:flutter/foundation.dart';
import 'package:flutter_caching/core/services/secure_storage_service.dart';
import 'package:flutter_caching/features/auth/domain/usecases/check_auth_status_use_case.dart';
import 'package:flutter_caching/features/auth/domain/usecases/login_use_case.dart';
import 'package:flutter_caching/features/auth/domain/usecases/logout_use_case.dart';
import 'package:get_it/get_it.dart';

class AuthProvider with ChangeNotifier {
  final LoginUseCase _loginUseCase;
  final LogoutUseCase _logoutUseCase;
  // ignore: unused_field
  final CheckAuthStatusUseCase _checkAuthStatusUseCase;
  final SecureStorageService _storage;

  bool _isLoading = false;
  String? _tokenAuth;
  String? _error;

  AuthProvider({
    required SecureStorageService storage,
    required LoginUseCase loginUseCase,
    required LogoutUseCase logoutUseCase,
    required CheckAuthStatusUseCase checkAuthStatusUseCase,
  })  : _loginUseCase = loginUseCase,
        _logoutUseCase = logoutUseCase,
        _storage = storage,
        _checkAuthStatusUseCase = checkAuthStatusUseCase {
    checkAuthStatus();
  }

  bool get isLoading => _isLoading;
  String? get getToken => _tokenAuth;
  String? get error => _error;
  bool get isAuthenticated => _tokenAuth != null;

  Future<void> login(String email, String password) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final authEntity = await _loginUseCase(email, password);
      await _storage.saveToken(authEntity.accessToken);
      _tokenAuth = authEntity.accessToken;

      _error = null;
    } catch (e) {
      _tokenAuth = null;
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> logout() async {
    _isLoading = true;
    notifyListeners();

    await _logoutUseCase();

    _tokenAuth = null;
    _error = null;
    _isLoading = false;
    notifyListeners();
  }

  Future<void> checkAuthStatus() async {
    _isLoading = true;
    notifyListeners();

    final token = await GetIt.instance<SecureStorageService>().getToken();

    if (token != null) {
      _tokenAuth = token;
      _error = null;
    } else {
      _tokenAuth = null;
    }

    _isLoading = false;
    notifyListeners();
  }
}
