part of 'dependencies.dart';

final getIt = GetIt.instance;

Future<void> configureDependencies() async {
  // External dependencies
  getIt.registerLazySingleton(() => Dio());
  getIt.registerLazySingleton(() => const FlutterSecureStorage());

  // Services
  getIt.registerLazySingleton(
      () => SecureStorageService(storage: getIt())); // Tambahkan ini

  // Setup interceptors
  final dio = getIt<Dio>();
  dio.interceptors.add(LogInterceptor(
    request: true,
    responseHeader: true,
    responseBody: true,
    error: true,
  ));

  dio.interceptors.add(JwtInterceptor(getIt<SecureStorageService>()));
  // Kita akan menambahkan JWT interceptor di sini nanti

// Auth Dependencies
  // Data sources
  getIt.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(dio: getIt()),
  );

  getIt.registerLazySingleton<AuthLocalDataSource>(
    () => AuthLocalDataSourceImpl(secureStorageService: getIt()), // Ubah ini
  );
  // Repository
  getIt.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      remoteDataSource: getIt(),
      localDataSource: getIt(),
    ),
  );

  // Use cases
  getIt.registerLazySingleton(() => LoginUseCase(getIt<AuthRepository>()));
  getIt.registerLazySingleton(() => LogoutUseCase(getIt<AuthRepository>()));
  getIt.registerLazySingleton(
      () => CheckAuthStatusUseCase(getIt<AuthRepository>()));

  // Provider
  getIt.registerFactory(
    () => AuthProvider(
      storage: getIt<SecureStorageService>(),
      loginUseCase: getIt<LoginUseCase>(),
      logoutUseCase: getIt<LogoutUseCase>(),
      checkAuthStatusUseCase: getIt<CheckAuthStatusUseCase>(),
    ),
  );

  // Product Dependencies
  // Data sources
  getIt.registerLazySingleton<ProductRemoteDataSource>(
    () => ProductRemoteDataSource(getIt<Dio>()),
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
  getIt.registerLazySingleton(
      () => FetchProductUseCase(getIt<ProductRepository>()));
  getIt.registerLazySingleton(
      () => FetchProductByIdUseCase(getIt<ProductRepository>()));
  getIt.registerLazySingleton(
      () => AddProductUseCase(getIt<ProductRepository>()));
  getIt.registerLazySingleton(
      () => UpdateProductUseCase(getIt<ProductRepository>()));
  getIt.registerLazySingleton(
      () => DeleteProductUseCase(getIt<ProductRepository>()));

  // Provider
  getIt.registerFactory(
    () => ProductProvider(
      fetchProductsUseCase: getIt<FetchProductUseCase>(),
      fetchProductByIdUseCase: getIt<FetchProductByIdUseCase>(),
      addProductUseCase: getIt<AddProductUseCase>(),
      updateProductUseCase: getIt<UpdateProductUseCase>(),
      deleteProductUseCase: getIt<DeleteProductUseCase>(),
    ),
  );
}
