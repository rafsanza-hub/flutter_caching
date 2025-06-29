import 'package:flutter/foundation.dart';
import 'package:flutter_caching/features/auth/domain/usecases/check_auth_status_use_case.dart';
import 'package:flutter_caching/features/auth/domain/usecases/login_use_case.dart';
import 'package:flutter_caching/features/auth/domain/usecases/logout_use_case.dart';

class AuthProvider with ChangeNotifier {
  final LoginUseCase _loginUseCase;
  final LogoutUseCase _logoutUseCase;
  final CheckAuthStatusUseCase _checkAuthStatusUseCase;

  bool _isLoading = false;
  String? _tokenAuth;
  String? _error;

  AuthProvider({
    required LoginUseCase loginUseCase,
    required LogoutUseCase logoutUseCase,
    required CheckAuthStatusUseCase checkAuthStatusUseCase,
  })  : _loginUseCase = loginUseCase,
        _logoutUseCase = logoutUseCase,
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

    try {
      final auth = await _checkAuthStatusUseCase();
      _tokenAuth = auth?.accessToken;
    } catch (e) {
      _tokenAuth = null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
