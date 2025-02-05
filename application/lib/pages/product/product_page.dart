import 'dart:convert';
import 'package:application/pages/product/create_product_page.dart';
import 'package:application/widgets/product_box.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ProductPage extends StatefulWidget {
  const ProductPage({super.key});

  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  List<dynamic> products = [];
  bool isLoading = true;
  final TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchProduct();
    searchController.addListener(_onSearchChanged);
  }

  void _onSearchChanged() {
    final query = searchController.text.trim();
    fetchProduct(searchQuery: query);
  }

  Future<void> fetchProduct({String searchQuery = ''}) async {
    String apiUrl = "${dotenv.env['API_URL']}/product";
    if (searchQuery.isNotEmpty) {
      apiUrl = "${dotenv.env['API_URL']}/product/search";
    }

    final Uri uri =
        Uri.parse(apiUrl).replace(queryParameters: {'q': searchQuery});

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
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Search Bar
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: searchController,
                        decoration: const InputDecoration(
                          hintText: 'ຄົ້ນຫາ ສິນຄ້າ...',
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(horizontal: 16),
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        searchController.clear();
                        fetchProduct();
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.search),
                      onPressed: () {
                        final query = searchController.text.trim();
                        fetchProduct(searchQuery: query);
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
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
                                  fetchProduct(); // Refresh the products list
                                },
                              );
                            },
                          ),
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const CreateProductPage(),
              ),
            ).then((_) {
              fetchProduct();
            });
          },
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          heroTag: 'createProduct',
          child: const Icon(Icons.add, color: Colors.black),
        ),
      ),
    );
  }
}
