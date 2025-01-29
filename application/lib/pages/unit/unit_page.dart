import 'dart:convert';
import 'package:application/pages/unit/create_unit_page.dart';
import 'package:application/widgets/unit_box.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class UnitPage extends StatefulWidget {
  const UnitPage({super.key});

  @override
  State<UnitPage> createState() => _UnitPageState();
}

class _UnitPageState extends State<UnitPage> {
  List<dynamic> units = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchUnit();
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

  Future<bool> updateUnit(int unitId, String newName) async {
    final apiUrl = "${dotenv.env['API_URL']}/unit/$unitId";
    try {
      final response = await http.put(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'unit_name': newName}),
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

  Future<void> deleteUnit(int unitId, int index) async {
    final confirmed = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('ລົບຫົວໜ່ວຍ'),
        content: const Text('ທ່ານຕ້ອງການລົບຫົວໜ່ວຍນີ້ແທ້ ຫຼື ບໍ່?'),
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
      final apiUrl = "${dotenv.env['API_URL']}/unit/$unitId";
      final response = await http.delete(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        // Remove the category from the list
        setState(() {
          units.removeAt(index);
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
              // Category List
              Expanded(
                child: isLoading
                    ? const Center(
                        child: CircularProgressIndicator(),
                      )
                    : units.isEmpty
                        ? const Center(
                            child: Text('ບໍ່ພົບໝວດໝູ່'),
                          )
                        : ListView.separated(
                            itemCount: units.length,
                            separatorBuilder: (context, index) =>
                                const SizedBox(height: 12),
                            itemBuilder: (context, index) {
                              final unit = units[index];
                              return UnitBox(
                                name: unit['unit_name'],
                                id: unit['unit_id'],
                                onEdit: (newName) async {
                                  final updated = await updateUnit(
                                      unit['unit_id'], newName);
                                  if (updated) {
                                    setState(() {
                                      units[index]['unit_name'] = newName;
                                    });
                                  }
                                },
                                onDelete: () {
                                  deleteUnit(unit['unit_id'], index);
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
                builder: (context) => const CreateUnitPage(),
              ),
            ).then((_) {
              fetchUnit();
            });
          },
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          heroTag: 'createUnit',
          child: const Icon(Icons.add, color: Colors.black),
        ),
      ),
    );
  }
}
