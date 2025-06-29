import 'package:flutter/material.dart';
import 'package:flutter_caching/core/dependencies/dependencies.dart';
import 'package:flutter_caching/features/auth/presentation/pages/login_page.dart';
import 'package:flutter_caching/features/auth/presentation/provider/auth_provider.dart';
import 'package:flutter_caching/features/product/presentation/pages/product_list_page.dart';
import 'package:flutter_caching/features/product/presentation/providers/product_detail_provider.dart';
import 'package:flutter_caching/features/product/presentation/providers/product_provider.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize dependencies
  await configureDependencies();
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => getIt<AuthProvider>()),
        ChangeNotifierProvider(create: (_) => getIt<ProductProvider>()),
        ChangeNotifierProvider(create: (_) => getIt<ProductDetailProvider>())
      ],
      child: MaterialApp(
        title: 'Flutter Caching App',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: Consumer<AuthProvider>(
          builder: (context, authProvider, _) {
            if (authProvider.isLoading) {
              return const Scaffold(
                body: Center(child: CircularProgressIndicator()),
              );
            }
            return authProvider.isAuthenticated
                ? const ProductListPage()
                :  LoginPage();
          },
        ),
      ),
    );
  }
}