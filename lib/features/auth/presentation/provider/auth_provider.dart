import 'package:flutter/foundation.dart';
import 'package:flutter_caching/features/auth/domain/entities/user.dart';
import 'package:flutter_caching/features/auth/domain/usecases/check_auth_status_use_case.dart';
import 'package:flutter_caching/features/auth/domain/usecases/login_use_case.dart';
import 'package:flutter_caching/features/auth/domain/usecases/logout_use_case.dart';

class AuthProvider with ChangeNotifier {
  final LoginUseCase _loginUseCase;
  final LogoutUseCase _logoutUseCase;
  final CheckAuthStatusUseCase _checkAuthStatusUseCase;

  bool _isLoading = false;
  User? _user;
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
  User? get user => _user;
  String? get error => _error;
  bool get isAuthenticated => _user != null;

  Future<void> login(String email, String password) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final authEntity = await _loginUseCase(email, password);
      _user = authEntity.user;
      _error = null;
    } catch (e) {
      _user = null;
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

    _user = null;
    _error = null;
    _isLoading = false;
    notifyListeners();
  }

  Future<void> checkAuthStatus() async {
    _isLoading = true;
    notifyListeners();

    final authEntity = await _checkAuthStatusUseCase();

    _user = authEntity?.user;
    _isLoading = false;
    notifyListeners();
  }
}
