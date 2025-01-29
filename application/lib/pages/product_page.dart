import 'package:flutter/material.dart';

class ProductPage extends StatelessWidget {
  final int id;
  final String name;

  const ProductPage({
    super.key,
    required this.id,
    required this.name,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ສິນຄ້າໃນໝວດໝູ່ $name'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Center(
        child: Text('Display products for category: $id'),
        // You can fetch and display the products here based on categoryId
      ),
    );
  }
}
