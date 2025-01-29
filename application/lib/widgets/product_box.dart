import 'package:application/pages/product/update_product_page.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ProductBox extends StatefulWidget {
  const ProductBox({
    super.key,
    required this.productName,
    required this.productId,
    required this.quantity,
    required this.price,
    required this.salePrice,
    required this.unitName,
    required this.onDelete,
    required this.categoryId,
    required this.unitId,
    this.onUpdate,
  });

  final String productName;
  final int productId;
  final int quantity;
  final int price;
  final int salePrice;
  final String unitName;
  final int categoryId;
  final int unitId;
  final VoidCallback onDelete;
  final VoidCallback? onUpdate;

  @override
  State<ProductBox> createState() => _ProductBoxState();
}

class _ProductBoxState extends State<ProductBox> {
  final NumberFormat numberFormat = NumberFormat('#,###');

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton(
        onPressed: () {},
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
          side: const BorderSide(color: Colors.grey),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Product Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.productName,
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        'ຈຳນວນ: ${widget.quantity} ${widget.unitName}',
                        style: const TextStyle(
                          color: Colors.black54,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Column(
                    children: [
                      Text(
                        'ລາຄາຊື້: ₭${numberFormat.format(widget.price)}',
                        style: const TextStyle(
                          color: Colors.black54,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(
                        height: 4,
                      ),
                      Text(
                        'ລາຄາຂາຍ: ₭${numberFormat.format(widget.salePrice)}',
                        style: const TextStyle(
                          color: Colors.greenAccent,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),

            // Edit and Delete Icons
            Row(
              children: [
                // Edit Icon
                IconButton(
                  onPressed: () async {
                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => UpdateProductPage(
                          productId: widget.productId,
                          productName: widget.productName,
                          quantity: widget.quantity,
                          price: widget.price,
                          salePrice: widget.salePrice,
                          categoryId: widget.categoryId,
                          unitId: widget.unitId,
                        ),
                      ),
                    );

                    // If update was successful, trigger a refresh
                    if (result != null) {
                      // Call the refresh function passed from parent
                      widget.onUpdate?.call();
                    }
                  },
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
