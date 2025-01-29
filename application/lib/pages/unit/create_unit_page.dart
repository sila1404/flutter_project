import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:convert';

class CreateUnitPage extends StatefulWidget {
  const CreateUnitPage({super.key});

  @override
  State<CreateUnitPage> createState() => _CreateUnitPageState();
}

class _CreateUnitPageState extends State<CreateUnitPage> {
  // Controller for the category name input
  final TextEditingController _unitNameController = TextEditingController();
  bool _isLoading = false; // To show a loading indicator

  // Function to handle category creation
  Future<void> _createUnit() async {
    // Get the category name from the text field
    final unitName = _unitNameController.text.trim();

    setState(() {
      _isLoading = true; // Show loading indicator
    });

    try {
      // Send a POST request to your API
      final apiUrl = "${dotenv.env['API_URL']}/unit";
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'unit_name': unitName}),
      );

      if (response.statusCode == 201) {
        final responseData = json.decode(response.body);
        if (mounted) {
          // Success: Category created
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('${responseData['message']}')),
          );
          Navigator.pop(context, responseData); // Return to the previous page
        }
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
        title: const Text('ສ້າງຫົວໜ່ວຍ'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Category Name Input
            TextField(
              controller: _unitNameController,
              decoration: const InputDecoration(
                labelText: 'ຊື່ຫົວໜ່ວຍ',
                border: OutlineInputBorder(),
                hintText: 'ໃສ່ຊື່ຫົວໜ່ວຍ',
              ),
            ),
            const SizedBox(height: 20),

            // Add Category Button
            _isLoading
                ? const CircularProgressIndicator() // Show loading indicator
                : ElevatedButton(
                    onPressed: _createUnit,
                    style: ElevatedButton.styleFrom(
                      minimumSize:
                          const Size(double.infinity, 50), // Full width
                    ),
                    child: const Text('ເພີ່ມຫົວໜ່ວຍ'),
                  ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    // Clean up the controller
    _unitNameController.dispose();
    super.dispose();
  }
}
