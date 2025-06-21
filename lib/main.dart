// main.dart
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_caching/features/product/data/collections/product_collection.dart';
import 'package:flutter_caching/features/product/domain/usecases/fetch_product_use_case.dart';
import 'package:flutter_caching/features/product/presentation/pages/product_list_page.dart';
import 'package:provider/provider.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

// Import semua yang dibutuhkan
import 'package:flutter_caching/features/product/data/datasources/remote/product_remote_data_source.dart';
import 'package:flutter_caching/features/product/data/datasources/local/product_local_data_source.dart';
import 'package:flutter_caching/features/product/data/datasources/local/product_local_data_source_impl.dart';
import 'package:flutter_caching/features/product/data/repositories/product_repository_impl.dart';
import 'package:flutter_caching/features/product/domain/repositories/product_repository.dart';
import 'package:flutter_caching/features/product/domain/usecases/fetch_product_by_id_use_case.dart'; //
import 'package:flutter_caching/features/product/domain/usecases/add_product_use_case.dart'; //
import 'package:flutter_caching/features/product/domain/usecases/update_product_use_case.dart'; //
import 'package:flutter_caching/features/product/domain/usecases/delete_product_use_case.dart'; //
import 'package:flutter_caching/features/product/presentation/providers/product_provider.dart';

late Future<Isar> isarDbInstance;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // final dir = await getApplicationDocumentsDirectory();
  // isarDbInstance = Isar.open(
  //   [ProductCollectionSchema],
  //   directory: dir.path,
  //   inspector: true,
  // );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {

    // Data Sources
    final ProductRemoteDataSource remoteDataSource =
        ProductRemoteDataSource(Dio());
    final ProductLocalDataSource localDataSource = ProductLocalDataSourceImpl();

    // Repositories
    final ProductRepository productRepository = ProductRepositoryImpl(
      remoteDataSource: remoteDataSource,
      localDataSource: localDataSource,
    );

    // Use Cases
    final FetchProductUseCase fetchProductsUseCase =
        FetchProductUseCase(productRepository); //
    final FetchProductByIdUseCase fetchProductByIdUseCase =
        FetchProductByIdUseCase(productRepository); //
    final AddProductUseCase addProductUseCase =
        AddProductUseCase(productRepository); //
    final UpdateProductUseCase updateProductUseCase =
        UpdateProductUseCase(productRepository); //
    final DeleteProductUseCase deleteProductUseCase =
        DeleteProductUseCase(productRepository); //

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => ProductProvider(
            fetchProductsUseCase: fetchProductsUseCase, //
            fetchProductByIdUseCase: fetchProductByIdUseCase, //
            addProductUseCase: addProductUseCase, //
            updateProductUseCase: updateProductUseCase, //
            deleteProductUseCase: deleteProductUseCase, //
          ),
        ),
      ],
      child: MaterialApp(
        title: 'Flutter Caching App',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const ProductListPage(),
      ),
    );
  }
}
