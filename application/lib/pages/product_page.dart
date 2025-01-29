import 'package:flutter/material.dart';

class ProductPage extends StatelessWidget {
  final int categoryId;
  final String categoryName;

  const ProductPage({
    super.key,
    required this.categoryId,
    required this.categoryName,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ສິນຄ້າໃນໝວດໝູ່ $categoryName'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Center(
        child: Text('Display products for category: $categoryId'),
        // You can fetch and display the products here based on categoryId
      ),
    );
  }
}
