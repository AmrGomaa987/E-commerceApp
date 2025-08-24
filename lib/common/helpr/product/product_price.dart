import 'package:ecommerce_app_with_flutter/domain/product/entity/product.dart';

class ProductPriceHelper {
  static double provideCurrentPrice(ProductEntity product) {
    return product.discountedPrice != 0
        ? product.discountedPrice.toDouble()
        : product.price.toDouble();
  }

  /// Formats price to always show decimal places (e.g., 25.00, 19.99)
  static String formatPrice(double price) {
    return price.toStringAsFixed(2);
  }

  /// Formats price with currency symbol
  static String formatPriceWithCurrency(
    double price, {
    String currency = '\$',
  }) {
    return '$currency${formatPrice(price)}';
  }
}
