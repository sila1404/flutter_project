import 'package:application/pages/product_page.dart';
import 'package:flutter/material.dart';

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

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ProductPage(
                id: widget.id,
                name: widget.name,
              ),
            ),
          );
        }, // You can keep this or remove it
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
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
                      autofocus: true, // Automatically focus on the text field
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
                  // Category Name (Read-Only)
                  Text(
                    widget.name,
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                    ),
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
  }
}
