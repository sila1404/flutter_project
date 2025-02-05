import 'dart:convert';

import 'package:application/pages/category/create_category_page.dart';
import 'package:application/widgets/category_box.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class CategoryPage extends StatefulWidget {
  const CategoryPage({super.key});

  @override
  State<CategoryPage> createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  List<dynamic> categories = [];
  bool isLoading = true;
  final TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchCategories();
    searchController.addListener(_onSearchChanged);
  }

  Future<void> fetchCategories({String searchQuery = ''}) async {
    String apiUrl = "${dotenv.env['API_URL']}/category";
    if (searchQuery.isNotEmpty) {
      apiUrl = "${dotenv.env['API_URL']}/category/search";
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
          categories = data['data'];
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

  void _onSearchChanged() {
    final query = searchController.text.trim();
    fetchCategories(searchQuery: query);
  }

  Future<bool> updateCategory(int categoryId, String newName) async {
    final apiUrl = "${dotenv.env['API_URL']}/category/$categoryId";
    try {
      final response = await http.put(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'category_name': newName}),
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('${responseData['message']}')),
          );
        }

        return true; // Success
      } else if (response.statusCode >= 400 && response.statusCode < 500) {
        final errorData = json.decode(response.body);

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('${errorData['message']}')),
          );
        }

        return false; //Failure
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: ${response.body}')),
          );
        }

        return false; //Failure
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Exception: $e')),
        );
      }

      return false; // Failure
    }
  }

  Future<void> deleteCategory(int categoryId, int index) async {
    final confirmed = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('ລົບໝວດໝູ່'),
        content: const Text('ທ່ານຕ້ອງການລົບໝວດໝູ່ນີ້ແທ້ ຫຼື ບໍ່?'),
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
      // Call the API to delete the category
      final apiUrl = "${dotenv.env['API_URL']}/category/$categoryId";
      final response = await http.delete(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        // Remove the category from the list
        setState(() {
          categories.removeAt(index);
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
                          hintText: 'ຄົ້ນຫາ ໝວດໝູ່...',
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(horizontal: 16),
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        searchController.clear();
                        fetchCategories();
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.search),
                      onPressed: () {
                        final query = searchController.text.trim();
                        fetchCategories(searchQuery: query);
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
                    : categories.isEmpty
                        ? const Center(
                            child: Text('ບໍ່ພົບໝວດໝູ່'),
                          )
                        : ListView.separated(
                            itemCount: categories.length,
                            separatorBuilder: (context, index) =>
                                const SizedBox(height: 12),
                            itemBuilder: (context, index) {
                              final category = categories[index];
                              return CategoryBox(
                                name: category['category_name'],
                                id: category['category_id'],
                                onEdit: (newName) async {
                                  final updated = await updateCategory(
                                      category['category_id'], newName);
                                  if (updated) {
                                    setState(() {
                                      categories[index]['category_name'] =
                                          newName;
                                    });
                                  }
                                },
                                onDelete: () {
                                  deleteCategory(
                                      category['category_id'], index);
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
                builder: (context) => const CreateCategoryPage(),
              ),
            ).then((_) {
              fetchCategories();
            });
          },
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          heroTag: "createCategory",
          child: const Icon(Icons.add, color: Colors.black),
        ),
      ),
    );
  }
}
