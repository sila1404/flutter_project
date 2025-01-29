import 'dart:convert';
import 'package:application/widgets/product_box.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ProductOnCategoryPage extends StatefulWidget {
  final int id;
  final String name;

  const ProductOnCategoryPage({
    super.key,
    required this.id,
    required this.name,
  });

  @override
  State<ProductOnCategoryPage> createState() => _ProductOnCategoryPageState();
}

class _ProductOnCategoryPageState extends State<ProductOnCategoryPage> {
  List<dynamic> products = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchProductOnCategory(widget.id);
  }

  Future<void> fetchProductOnCategory(int categoryId) async {
    String apiUrl = "${dotenv.env['API_URL']}/category/product/$categoryId";

    final Uri uri = Uri.parse(apiUrl);

    setState(() {
      isLoading = true;
    });

    try {
      final response = await http.get(uri);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          products = data['data'];
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
        });
        print('Error: ${response.statusCode}');
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print('Exception: $e');
    }
  }

  Future<void> deleteProduct(int productId, int index) async {
    final confirmed = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('ລົບສິນຄ້າ'),
        content: const Text('ທ່ານຕ້ອງການລົບສິນຄ້ານີ້ແທ້ ຫຼື ບໍ່?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('ຍົກເລີກ'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('ລົບ', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      // Call the API to delete the unit
      final apiUrl = "${dotenv.env['API_URL']}/product/$productId";
      final response = await http.delete(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        // Remove the category from the list
        setState(() {
          products.removeAt(index);
        });
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('${responseData['message']}')),
          );
        }
      } else if (response.statusCode >= 400 && response.statusCode < 500) {
        final errorData = json.decode(response.body);

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('${errorData['message']}')),
          );
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: ${response.body}')),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Text('ສິນຄ້າໃນໝວດ ${widget.name}'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Category List
              Expanded(
                child: isLoading
                    ? const Center(
                        child: CircularProgressIndicator(),
                      )
                    : products.isEmpty
                        ? const Center(
                            child: Text('ບໍ່ພົບສິນຄ້າ'),
                          )
                        : ListView.separated(
                            itemCount: products.length,
                            separatorBuilder: (context, index) =>
                                const SizedBox(height: 12),
                            itemBuilder: (context, index) {
                              final product = products[index];
                              return ProductBox(
                                productName: product['product_name'] ?? '',
                                productId: product['product_id'] ?? 0,
                                price: product['price'] ?? 0,
                                quantity: product['quantity'] ?? 0,
                                salePrice: product['sale_price'] ?? 0,
                                unitName: product['unit_name'] ?? '',
                                categoryId: product['category_id'] ?? 0,
                                unitId: product['unit_id'] ?? 0,
                                onDelete: () {
                                  deleteProduct(
                                      product['product_id'] ?? 0, index);
                                },
                                onUpdate: () {
                                  fetchProductOnCategory(widget.id);
                                },
                              );
                            },
                          ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
