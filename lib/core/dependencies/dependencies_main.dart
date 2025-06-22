part of 'dependencies.dart';

final getIt = GetIt.instance;

Future<void> configureDependencies() async {
  // External dependencies
  getIt.registerLazySingleton(() => Dio());
  getIt.registerLazySingleton(() => const FlutterSecureStorage());

  // Setup interceptors
  final dio = getIt<Dio>();
  dio.interceptors.add(LogInterceptor(
    request: true,
    responseHeader: true,
    responseBody: true,
    error: true,
  ));

// Auth Dependencies
  // Data sources
  getIt.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(dio: getIt()),
  );

  getIt.registerLazySingleton<AuthLocalDataSource>(
    () => AuthLocalDataSourceImpl(secureStorage: getIt()),
  );

  // Repository
  getIt.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      remoteDataSource: getIt(),
      localDataSource: getIt(),
    ),
  );

  // Use cases
  getIt.registerLazySingleton(() => LoginUseCase(getIt()));
  getIt.registerLazySingleton(() => LogoutUseCase(getIt()));
  getIt.registerLazySingleton(() => CheckAuthStatusUseCase(getIt()));

  // Provider
  getIt.registerFactory(
    () => AuthProvider(
      loginUseCase: getIt(),
      logoutUseCase: getIt(),
      checkAuthStatusUseCase: getIt(),
    ),
  );
  // Product Dependencies
  // Data sources
  getIt.registerLazySingleton<ProductRemoteDataSource>(
    () => ProductRemoteDataSource(getIt()),
  );

  getIt.registerLazySingleton<ProductLocalDataSource>(
    () => ProductLocalDataSourceImpl(),
  );

  // Repository
  getIt.registerLazySingleton<ProductRepository>(
    () => ProductRepositoryImpl(
      remoteDataSource: getIt(),
      localDataSource: getIt(),
    ),
  );

  // Use cases
  getIt.registerLazySingleton(() => FetchProductUseCase(getIt()));
  getIt.registerLazySingleton(() => FetchProductByIdUseCase(getIt()));
  getIt.registerLazySingleton(() => AddProductUseCase(getIt()));
  getIt.registerLazySingleton(() => UpdateProductUseCase(getIt()));
  getIt.registerLazySingleton(() => DeleteProductUseCase(getIt()));

  // Provider
  getIt.registerFactory(
    () => ProductProvider(
      fetchProductsUseCase: getIt(),
      fetchProductByIdUseCase: getIt(),
      addProductUseCase: getIt(),
      updateProductUseCase: getIt(),
      deleteProductUseCase: getIt(),
    ),
  );
}
