import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:application/pages/category/product_on_category_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class CategoryBox extends StatefulWidget {
  const CategoryBox({
    super.key,
    required this.name,
    required this.onDelete,
    required this.onEdit,
    required this.id,
  });

  final String name;
  final VoidCallback onDelete;
  final Function(String newName) onEdit;
  final int id;

  @override
  State<CategoryBox> createState() => _CategoryBoxState();
}

class _CategoryBoxState extends State<CategoryBox> {
  bool _isEditing = false; // Track whether the box is in edit mode
  final TextEditingController _editController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _editController.text = widget.name; // Initialize the text field
  }

  @override
  void dispose() {
    _editController.dispose(); // Clean up the controller
    super.dispose();
  }

  void _startEditing() {
    setState(() {
      _isEditing = true; // Switch to edit mode
    });
  }

  void _saveChanges() {
    final newName = _editController.text.trim();
    if (newName.isNotEmpty) {
      widget.onEdit(newName); // Notify the parent widget of the update
    }
    setState(() {
      _isEditing = false; // Switch back to read-only mode
    });
  }

  void _cancelEditing() {
    setState(() {
      _isEditing = false; // Switch back to read-only mode
      _editController.text = widget.name; // Reset the text field
    });
  }

  Future<int> _getProductCount() async {
    try {
      final response = await http.get(
        Uri.parse(
            "${dotenv.env['API_URL']}/category/product/${widget.id}/count"),
      );
      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        if (responseData['success']) {
          return responseData['data']['count'] ?? 0;
        }
        return 0;
      }
      return 0;
    } catch (e) {
      print('Error getting product count: $e');
      return 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<int>(
        future: _getProductCount(),
        builder: (context, snapshot) {
          final productCount = snapshot.data ?? 0;

          return SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProductOnCategoryPage(
                      id: widget.id,
                      name: widget.name,
                    ),
                  ),
                );
              }, // You can keep this or remove it
              style: OutlinedButton.styleFrom(
                padding:
                    const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                side: const BorderSide(color: Colors.grey),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              child: _isEditing
                  ? Row(
                      children: [
                        // Text Field for Editing
                        Expanded(
                          child: TextField(
                            controller: _editController,
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              hintText: 'ໃສ່ຊື່ໝວດໝູ່',
                            ),
                            autofocus:
                                true, // Automatically focus on the text field
                          ),
                        ),

                        // Save Button
                        IconButton(
                          onPressed: _saveChanges,
                          icon: const Icon(Icons.check, color: Colors.green),
                        ),

                        // Cancel Button
                        IconButton(
                          onPressed: _cancelEditing,
                          icon: const Icon(Icons.close, color: Colors.red),
                        ),
                      ],
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Category Name with number of product (Read-Only)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.name,
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                              ),
                            ),
                            Text(
                              '$productCount ສິນຄ້າ',
                              style: TextStyle(
                                color: Colors.grey[500],
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),

                        // Edit and Delete Icons
                        Row(
                          children: [
                            // Edit Icon
                            IconButton(
                              onPressed: _startEditing,
                              icon: const Icon(Icons.edit, color: Colors.blue),
                            ),

                            // Delete Icon
                            IconButton(
                              onPressed: widget.onDelete,
                              icon: const Icon(Icons.delete, color: Colors.red),
                            ),
                          ],
                        ),
                      ],
                    ),
            ),
          );
        });
  }
}
