// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_app_with_flutter/domain/product/entity/color.dart';

class ProductEntity {
  final String categoryId;
  final List<ProductColorEntity> colors;
  final Timestamp createdDate;
  final num discountedPrice;
  final int gender;
  final List<String> images;
  final num price;
  final List<String> sizes;
  final String productId;
  final int salesNumber;
  final String title;
  final Map<String, int> inventory; // Color-Size combinations with stock
  final int totalStock;
  final int lowStockThreshold;

  ProductEntity({
    required this.categoryId,
    required this.colors,
    required this.createdDate,
    required this.discountedPrice,
    required this.gender,
    required this.images,
    required this.price,
    required this.sizes,
    required this.productId,
    required this.salesNumber,
    required this.title,
    required this.inventory,
    required this.totalStock,
    required this.lowStockThreshold,
  });

  // Helper methods for inventory management
  int getStockForVariant(String color, String size) {
    String key = '$color-$size';
    return inventory[key] ?? 0;
  }

  bool isInStock(String color, String size, int requestedQuantity) {
    return getStockForVariant(color, size) >= requestedQuantity;
  }

  bool isLowStock(String color, String size) {
    return getStockForVariant(color, size) <= lowStockThreshold &&
        getStockForVariant(color, size) > 0;
  }

  bool isOutOfStock(String color, String size) {
    return getStockForVariant(color, size) <= 0;
  }
}
