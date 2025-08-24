import 'package:ecommerce_app_with_flutter/domain/product/entity/product.dart';
import 'package:flutter/material.dart';

class StockIndicator extends StatelessWidget {
  final ProductEntity product;
  final String selectedColor;
  final String selectedSize;

  const StockIndicator({
    required this.product,
    required this.selectedColor,
    required this.selectedSize,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    int stock = product.getStockForVariant(selectedColor, selectedSize);
    bool isOutOfStock = product.isOutOfStock(selectedColor, selectedSize);
    bool isLowStock = product.isLowStock(selectedColor, selectedSize);

    if (isOutOfStock) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: Colors.red.shade100,
          borderRadius: BorderRadius.circular(4),
          border: Border.all(color: Colors.red.shade300),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.error_outline,
              size: 16,
              color: Colors.red.shade700,
            ),
            const SizedBox(width: 4),
            Text(
              'Out of Stock',
              style: TextStyle(
                color: Colors.red.shade700,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      );
    }

    if (isLowStock) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: Colors.orange.shade100,
          borderRadius: BorderRadius.circular(4),
          border: Border.all(color: Colors.orange.shade300),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.warning_outlined,
              size: 16,
              color: Colors.orange.shade700,
            ),
            const SizedBox(width: 4),
            Text(
              'Only $stock left',
              style: TextStyle(
                color: Colors.orange.shade700,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      );
    }

    // In stock
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.green.shade100,
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: Colors.green.shade300),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.check_circle_outline,
            size: 16,
            color: Colors.green.shade700,
          ),
          const SizedBox(width: 4),
          Text(
            'In Stock ($stock available)',
            style: TextStyle(
              color: Colors.green.shade700,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
