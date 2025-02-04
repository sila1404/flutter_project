import 'package:application/pages/category/category_page.dart';
import 'package:application/pages/product/product_page.dart';
import 'package:application/pages/unit/unit_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  // Load the .env file
  await dotenv.load(fileName: ".env");

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0; // Track selected tab index
  final List<String> page = ["ໝວດໝູ່", 'ສິນຄ້າ', 'ຫົວໜ່ວຍ'];
  List<dynamic> categories = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(page[_selectedIndex]),
      ),
      body: IndexedStack(
        index: _selectedIndex,
        children: [
          CategoryPage(),
          ProductPage(),
          UnitPage(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.category),
            label: 'ໝວດໝູ່',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart_rounded),
            label: 'ສິນຄ້າ',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.ac_unit),
            label: 'ຫົວໜ່ວຍ',
          ),
        ],
      ),
    );
  }
}
