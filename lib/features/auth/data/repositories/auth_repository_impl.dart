import 'package:flutter_caching/features/auth/data/datasources/local/auth_local_data_source.dart';
import 'package:flutter_caching/features/auth/data/datasources/remote/auth_remote_data_source.dart';
import 'package:flutter_caching/features/auth/domain/entities/auth.dart';
import 'package:flutter_caching/features/auth/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final AuthLocalDataSource localDataSource;

  AuthRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<Auth> login(String email, String password) async {
    final authModel = await remoteDataSource.login(email, password);
    await localDataSource.cacheAuthData(authModel);
    return authModel;
  }

  @override
  Future<void> logout() async {
    await localDataSource.clearCachedAuthData();
  }

  @override
  Future<Auth?> checkAuthStatus() async {
    return await localDataSource.getCachedAuthData();
  }
}
