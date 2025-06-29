import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_caching/core/utils/logger.dart';
import 'package:flutter_caching/features/product/presentation/pages/product_detail_page.dart';
import 'package:provider/provider.dart';
import 'package:flutter_caching/features/product/domain/entities/product.dart';
import 'package:flutter_caching/features/product/presentation/providers/product_provider.dart';

class ProductListPage extends StatefulWidget {
  const ProductListPage({super.key});

  @override
  State<ProductListPage> createState() => _ProductListPageState();
}

class _ProductListPageState extends State<ProductListPage> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ProductProvider>(context, listen: false).fetchProducts();
    });
  }

  @override
  Widget build(BuildContext context) {
    final productProvider = context.watch<ProductProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Product List'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => productProvider.fetchProducts(forceRefresh: true),
          ),
        ],
      ),
      body: productProvider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : productProvider.errorMessage != null
              ? Center(child: Text('Error: ${productProvider.errorMessage}'))
              : productProvider.products.isEmpty
                  ? const Center(child: Text('No products available.'))
                  : ListView.builder(
                      itemCount: productProvider.products.length,
                      itemBuilder: (context, index) {
                        final product = productProvider.products[index];
                        AppLogger.d('Produk ${product.id}: ${product.title}');
                        return ListTile(
                          leading: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: CachedNetworkImage(
                              imageUrl: product.imageUrl,
                              cacheKey: 'product_${product.id}_image',
                              width: 50,
                              height: 50,
                              fit: BoxFit.cover,
                              memCacheWidth: 50,
                              memCacheHeight: 50,
                              maxWidthDiskCache: 100,
                              maxHeightDiskCache: 100,
                              placeholder: (context, url) => Container(
                                width: 50,
                                height: 50,
                                color: Colors.grey[300],
                                child: const Center(
                                  child:
                                      CircularProgressIndicator(strokeWidth: 2),
                                ),
                              ),
                              errorWidget: (context, url, error) => Container(
                                width: 50,
                                height: 50,
                                color: Colors.grey[300],
                                child: const Icon(Icons.broken_image,
                                    color: Colors.red),
                              ),
                            ),
                          ),
                          title: Text(product.title),
                          subtitle: Text(
                              '${product.description} - ${product.status}'),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.edit),
                                onPressed: () {
                                  // Contoh update product
                                  _showEditProductDialog(context, product);
                                },
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete),
                                onPressed: () {
                                  // Konfirmasi penghapusan
                                  _confirmDeleteProduct(context, product.id);
                                },
                              ),
                            ],
                          ),
                          onTap: () async {
                            Navigator.push(context, MaterialPageRoute(
                              builder: (context) {
                                return ProductDetailPage(productId: product.id);
                              },
                            ));
                            final fetchedProduct = await productProvider
                                .fetchProductById(product.id);
                            if (fetchedProduct != null) {
                              // ScaffoldMessenger.of(context).showSnackBar(
                              //   SnackBar(
                              //       content:
                              //           Text('Fetched: ${fetchedProduct.title}')),
                              // );
                            }
                          },
                        );
                      },
                    ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddProductDialog(context);
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showAddProductDialog(BuildContext context) {
    final titleController = TextEditingController();
    final descriptionController = TextEditingController();
    final dueDateController = TextEditingController();
    final priorityController = TextEditingController();
    final statusController = TextEditingController();
    final tagsController = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Add New Product'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                  controller: titleController,
                  decoration: const InputDecoration(labelText: 'Title')),
              TextField(
                  controller: descriptionController,
                  decoration: const InputDecoration(labelText: 'Description')),
              TextField(
                  controller: dueDateController,
                  decoration: const InputDecoration(labelText: 'Due Date')),
              TextField(
                  controller: priorityController,
                  decoration: const InputDecoration(labelText: 'Priority')),
              TextField(
                  controller: statusController,
                  decoration: const InputDecoration(labelText: 'Status')),
              TextField(
                  controller: tagsController,
                  decoration: const InputDecoration(
                      labelText: 'Tags (comma separated)')),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              final newProduct = Product(
                id: int.parse(DateTime.now()
                    .millisecondsSinceEpoch
                    .toString()
                    .substring(4)),
                title: titleController.text,
                description: descriptionController.text,
                dueDate: dueDateController.text,
                priority: priorityController.text,
                status: statusController.text,
                imageUrl:
                    "https://picsum.photos/id/${Random().nextInt(1000)}/600/600",
                tags: tagsController.text
                    .split(',')
                    .map((e) => e.trim())
                    .toList(),
              );
              Provider.of<ProductProvider>(context, listen: false)
                  .addProduct(newProduct);
              Navigator.of(ctx).pop();
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  void _showEditProductDialog(BuildContext context, Product product) {
    final titleController = TextEditingController(text: product.title);
    final descriptionController =
        TextEditingController(text: product.description);
    final dueDateController = TextEditingController(text: product.dueDate);
    final priorityController = TextEditingController(text: product.priority);
    final statusController = TextEditingController(text: product.status);
    final tagsController = TextEditingController(text: product.tags.join(', '));

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Edit Product'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                  controller: titleController,
                  decoration: const InputDecoration(labelText: 'Title')),
              TextField(
                  controller: descriptionController,
                  decoration: const InputDecoration(labelText: 'Description')),
              TextField(
                  controller: dueDateController,
                  decoration: const InputDecoration(labelText: 'Due Date')),
              TextField(
                  controller: priorityController,
                  decoration: const InputDecoration(labelText: 'Priority')),
              TextField(
                  controller: statusController,
                  decoration: const InputDecoration(labelText: 'Status')),
              TextField(
                  controller: tagsController,
                  decoration: const InputDecoration(
                      labelText: 'Tags (comma separated)')),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              final updatedProduct = Product(
                id: product.id,
                title: titleController.text,
                description: descriptionController.text,
                dueDate: dueDateController.text,
                priority: priorityController.text,
                status: statusController.text,
                imageUrl: product.imageUrl,
                tags: tagsController.text
                    .split(',')
                    .map((e) => e.trim())
                    .toList(),
              );
              Provider.of<ProductProvider>(context, listen: false)
                  .updateProduct(updatedProduct);
              Navigator.of(ctx).pop();
            },
            child: const Text('Update'),
          ),
        ],
      ),
    );
  }

  void _confirmDeleteProduct(BuildContext context, int productId) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Confirm Delete'),
        content: const Text('Are you sure you want to delete this product?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Provider.of<ProductProvider>(context, listen: false)
                  .deleteProduct(productId);
              Navigator.of(ctx).pop();
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}
