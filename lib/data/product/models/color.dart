// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:ecommerce_app_with_flutter/domain/product/entity/color.dart';

class ProductColorModel {
  final String title;
  final List<int> rgb;

  ProductColorModel({required this.title, required this.rgb});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{'title': title, 'rgb': rgb};
  }

  factory ProductColorModel.fromMap(Map<String, dynamic> map) {
    return ProductColorModel(
      title: map['title'] as String? ?? '',
      rgb: _parseColorData(map),
    );
  }

  static List<int> _parseColorData(Map<String, dynamic> map) {
    try {
      // Check if hexCode exists (new Firebase format)
      if (map['hexCode'] != null) {
        return _hexToRgb(map['hexCode'] as String);
      }

      // Fallback to rgb array (old format)
      if (map['rgb'] != null) {
        return _parseRgbList(map['rgb']);
      }

      return <int>[]; // No color data available
    } catch (e) {
      return <int>[]; // If parsing fails, return empty list
    }
  }

  static List<int> _parseRgbList(dynamic rgbData) {
    try {
      if (rgbData is List) {
        return rgbData
            .map((e) => e is int ? e : int.tryParse(e.toString()) ?? 0)
            .toList();
      }
      return <int>[];
    } catch (e) {
      return <int>[];
    }
  }

  static List<int> _hexToRgb(String hexCode) {
    try {
      // Remove # if present
      String hex = hexCode.replaceAll('#', '');

      // Ensure hex is 6 characters
      if (hex.length != 6) {
        return <int>[]; // Invalid hex code
      }

      // Parse RGB values
      int r = int.parse(hex.substring(0, 2), radix: 16);
      int g = int.parse(hex.substring(2, 4), radix: 16);
      int b = int.parse(hex.substring(4, 6), radix: 16);

      return [r, g, b];
    } catch (e) {
      return <int>[]; // If parsing fails, return empty list
    }
  }
}

extension ProductColorXModel on ProductColorModel {
  ProductColorEntity toEntity() {
    return ProductColorEntity(title: title, rgb: rgb);
  }
}

extension ProductColorXEntity on ProductColorEntity {
  ProductColorModel fromEntity() {
    return ProductColorModel(title: title, rgb: rgb);
  }
}
