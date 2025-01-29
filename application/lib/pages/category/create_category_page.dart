import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:convert';

class CreateCategoryPage extends StatefulWidget {
  const CreateCategoryPage({super.key});

  @override
  State<CreateCategoryPage> createState() => _CreateCategoryPageState();
}

class _CreateCategoryPageState extends State<CreateCategoryPage> {
  // Controller for the category name input
  final TextEditingController _categoryNameController = TextEditingController();
  bool _isLoading = false; // To show a loading indicator

  // Function to handle category creation
  Future<void> _createCategory() async {
    // Get the category name from the text field
    final categoryName = _categoryNameController.text.trim();

    setState(() {
      _isLoading = true; // Show loading indicator
    });

    try {
      // Send a POST request to your API
      final apiUrl = "${dotenv.env['API_URL']}/category";
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'category_name': categoryName}),
      );

      if (response.statusCode == 201) {
        final responseData = json.decode(response.body);
        // Success: Category created
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${responseData['message']}')),
        );
        Navigator.pop(context, responseData); // Return to the previous page
      } else {
        // Handle API errors
        final errorData = json.decode(response.body);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('${errorData['message']}')),
          );
        }
      }
    } catch (e) {
      // Handle exceptions
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Exception: $e')),
        );
      }
    } finally {
      setState(() {
        _isLoading = false; // Hide loading indicator
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('ສ້າງໝວດໝູ່'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Category Name Input
            TextField(
              controller: _categoryNameController,
              decoration: const InputDecoration(
                labelText: 'ຊື່ໝວດໝູ່',
                border: OutlineInputBorder(),
                hintText: 'ໃສ່ຊື່ໝວດໝູ່',
              ),
            ),
            const SizedBox(height: 20),

            // Add Category Button
            _isLoading
                ? const CircularProgressIndicator() // Show loading indicator
                : ElevatedButton(
                    onPressed: _createCategory,
                    style: ElevatedButton.styleFrom(
                      minimumSize:
                          const Size(double.infinity, 50), // Full width
                    ),
                    child: const Text('ເພີ່ມໝວດໝູ່'),
                  ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    // Clean up the controller
    _categoryNameController.dispose();
    super.dispose();
  }
}
