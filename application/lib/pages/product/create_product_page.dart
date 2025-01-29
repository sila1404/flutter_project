import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class CreateProductPage extends StatefulWidget {
  const CreateProductPage({super.key});

  @override
  State<CreateProductPage> createState() => _CreateProductPageState();
}

class _CreateProductPageState extends State<CreateProductPage> {
  final _formKey = GlobalKey<FormState>();

  // Controllers for text input fields
  final TextEditingController _productNameController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _salePriceController = TextEditingController();

  // State variables for dropdowns
  List<dynamic> categories = [];
  List<dynamic> units = [];
  int? selectedCategoryId;
  int? selectedUnitId;

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchCategories();
    fetchUnit();
  }

  Future<void> fetchCategories() async {
    String apiUrl = "${dotenv.env['API_URL']}/category";

    final Uri uri = Uri.parse(apiUrl);

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

  Future<void> fetchUnit() async {
    String apiUrl = "${dotenv.env['API_URL']}/unit";

    final Uri uri = Uri.parse(apiUrl);

    setState(() {
      isLoading = true;
    });

    try {
      final response = await http.get(uri);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          units = data['data'];
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

  void _submitForm() async {
    if (_formKey.currentState?.validate() ?? false) {
      final productName = _productNameController.text;
      final quantity = int.parse(_quantityController.text);
      final price = int.parse(_priceController.text);
      final salePrice = int.parse(_salePriceController.text);

      if (selectedCategoryId == null || selectedUnitId == null) {
        // Handle the case where category or unit is not selected
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Please select both category and unit.')),
        );
        return;
      }

      // Here you would send the data to your API or save it to the database.
      // print('Product Name: $productName');
      // print('Quantity: $quantity');
      // print('Price: $price');
      // print('Sale Price: $salePrice');
      // print('Category ID: $selectedCategoryId');
      // print('Unit ID: $selectedUnitId');

      // Clear the form after submitting
      // _formKey.currentState?.reset();
      // setState(() {
      //   selectedCategoryId = null;
      //   selectedUnitId = null;
      // });

      setState(() {
        isLoading = true; // Show loading indicator
      });

      try {
        // Send a POST request to your API
        final apiUrl = "${dotenv.env['API_URL']}/product";
        final response = await http.post(
          Uri.parse(apiUrl),
          headers: {'Content-Type': 'application/json'},
          body: json.encode({
            'product_name': productName,
            'quantity': quantity,
            'price': price,
            'sale_price': salePrice,
            'category_id': selectedCategoryId,
            'unit_id': selectedUnitId
          }),
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
          isLoading = false; // Hide loading indicator
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('ສ້າງສິນຄ້າ'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : Form(
                key: _formKey,
                child: ListView(
                  children: [
                    // Product Name Input
                    TextFormField(
                      controller: _productNameController,
                      decoration: const InputDecoration(
                        labelText: 'ຊື່ສິນຄ້າ',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'ກະລຸນາໃສ່ຊື່ສິນຄ້າ';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    // Quantity Input
                    TextFormField(
                      controller: _quantityController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'ຈຳນວນ',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'ກະລຸນາໃສ່ຈຳນວນສິນຄ້າ';
                        }
                        if (int.tryParse(value) == null) {
                          return 'ກະລຸນາປ້ອນຄ່າເປັນຕົວເລກ';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    // Price Input
                    TextFormField(
                      controller: _priceController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'ລາຄາຊື້',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'ກະລຸນາໃສ່ລາຄາຊື້ສິນຄ້າ';
                        }
                        if (int.tryParse(value) == null) {
                          return 'ກະລຸນາປ້ອນຄ່າເປັນຕົວເລກ';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    // Sale Price Input
                    TextFormField(
                      controller: _salePriceController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'ລາຄາຂາຍ',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'ກະລຸນາໃສ່ລາຄາຂາຍສິນຄ້າ';
                        }
                        if (int.tryParse(value) == null) {
                          return 'ກະລຸນາປ້ອນຄ່າເປັນຕົວເລກ';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    // Category Dropdown
                    DropdownButtonFormField<int>(
                      value: selectedCategoryId,
                      decoration: const InputDecoration(
                        labelText: 'ໝວດໝູ່',
                        border: OutlineInputBorder(),
                      ),
                      items: categories.map((category) {
                        return DropdownMenuItem<int>(
                          value: category['category_id'],
                          child: Text(category['category_name']),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedCategoryId = value;
                        });
                      },
                      validator: (value) {
                        if (value == null) {
                          return 'ກະລຸນາເລືອກໝວດໝູ່';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    // Unit Dropdown
                    DropdownButtonFormField<int>(
                      value: selectedUnitId,
                      decoration: const InputDecoration(
                        labelText: 'ຫົວໜ່ວຍ',
                        border: OutlineInputBorder(),
                      ),
                      items: units.map((unit) {
                        return DropdownMenuItem<int>(
                          value: unit['unit_id'],
                          child: Text(unit['unit_name']),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedUnitId = value;
                        });
                      },
                      validator: (value) {
                        if (value == null) {
                          return 'ກະລຸນາເລືອກຫົວໜ່ວຍ';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    // Submit Button
                    ElevatedButton(
                      onPressed: _submitForm,
                      child: const Text('ເພີ່ມສິນຄ້າ'),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
