import 'package:dio/dio.dart';
import 'package:flutter_caching/core/utils/logger.dart';
import 'package:flutter_caching/features/auth/data/models/auth_response_model.dart';

abstract class AuthRemoteDataSource {
  Future<AuthResponseModel> login(String email, String password);
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final Dio dio;

  AuthRemoteDataSourceImpl({required this.dio});

  @override
  Future<AuthResponseModel> login(String email, String password) async {
    AppLogger.d('Login with email: $email and password: $password');
    try {
      final response = await dio.post(
        'http://10.0.2.2:3000/auth',
        data: {
          'email': email,
          'password': password,
        },
        options: Options(
          headers: {
            'Content-Type': 'application/json',
          },
        ),
      );
      AppLogger.d('Login response: ${response.data}');
      return AuthResponseModel.fromJson(response.data);
    } catch (e) {
      AppLogger.e('Login error: $e');
      throw Exception('Error in login: $e');
    }
  }
}
