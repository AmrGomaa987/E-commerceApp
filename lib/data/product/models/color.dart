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
      rgb: _parseRgbList(map['rgb']),
    );
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
      // If parsing fails, return empty list to prevent crashes
      return <int>[];
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
