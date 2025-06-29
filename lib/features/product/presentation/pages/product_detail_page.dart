import 'package:flutter/material.dart';
import 'package:flutter_caching/features/product/domain/entities/product.dart';
import 'package:flutter_caching/features/product/presentation/providers/product_detail_provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:provider/provider.dart';

class ProductDetailPage extends StatefulWidget {
  final int productId;

  const ProductDetailPage({super.key, required this.productId});

  @override
  State<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ProductDetailProvider>(context, listen: false)
          .fetchProduct(widget.productId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Product Detail'),
        centerTitle: true,
        elevation: 0,
      ),
      body: Consumer<ProductDetailProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (provider.product == null) {
            return const Center(child: Text('Product not found'));
          }

          final product = provider.product!;

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildProductImage(product),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        product.title,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildProductImage(Product product) {
    return Hero(
      tag: 'product-image-${product.id}',
      child: CachedNetworkImage(
        imageUrl: product.imageUrl,
        imageBuilder: (context, imageProvider) => Container(
          height: 300,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: imageProvider,
              fit: BoxFit.cover,
            ),
          ),
        ),
        placeholder: (context, url) => Container(
          height: 300,
          color: Colors.grey[200],
          child: const Center(
            child: CircularProgressIndicator(),
          ),
        ),
        errorWidget: (context, url, error) => Container(
          height: 300,
          color: Colors.grey[200],
          child: const Center(
            child: Icon(Icons.error, size: 50, color: Colors.red),
          ),
        ),
        fadeInDuration: const Duration(milliseconds: 300),
        fadeInCurve: Curves.easeIn,
        memCacheHeight: 600,
        memCacheWidth: 600,
        maxHeightDiskCache: 1200,
        maxWidthDiskCache: 1200,
        cacheKey: 'product_${product.id}_image',
        httpHeaders: const {
          'Accept': 'image/webp,image/apng,image/*,*/*;q=0.8',
        },
      ),
    );
  }
}
