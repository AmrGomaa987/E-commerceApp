// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_app_with_flutter/domain/product/entity/product.dart';
import 'color.dart';

class ProductModel {
  final String categoryId;
  final List<ProductColorModel> colors;
  final Timestamp createdDate;
  final num discountedPrice;
  final int gender;
  final List<String> images;
  final num price;
  final List<String> sizes;
  final String productId;
  final int salesNumber;
  final String title;

  ProductModel({
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
  });

  factory ProductModel.fromMap(Map<String, dynamic> map) {
    return ProductModel(
      categoryId: map['categoryId'] as String? ?? '',
      colors: map['colors'] != null
          ? _parseColors(map['colors'])
          : <ProductColorModel>[],
      createdDate: map['createdDate'] as Timestamp? ?? Timestamp.now(),
      discountedPrice: map['discountedPrice'] as num? ?? 0,
      gender: map['gender'] as int? ?? 0,
      images: map['images'] != null
          ? _parseStringList(map['images'])
          : <String>[],
      price: map['price'] as num? ?? 0,
      sizes: map['sizes'] != null ? _parseStringList(map['sizes']) : <String>[],
      productId: map['productId'] as String? ?? '',
      salesNumber: map['salesNumber'] as int? ?? 0,
      title: map['title'] as String? ?? '',
    );
  }

  static List<ProductColorModel> _parseColors(dynamic colorsData) {
    try {
      if (colorsData is List) {
        return colorsData
            .whereType<Map<String, dynamic>>()
            .map((e) => ProductColorModel.fromMap(e))
            .toList();
      }
      return <ProductColorModel>[];
    } catch (e) {
      // If parsing fails, return empty list to prevent crashes
      return <ProductColorModel>[];
    }
  }

  static List<String> _parseStringList(dynamic listData) {
    try {
      if (listData is List) {
        return listData.map((e) => e.toString()).toList();
      }
      return <String>[];
    } catch (e) {
      // If parsing fails, return empty list to prevent crashes
      return <String>[];
    }
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'categoryId': categoryId,
      'colors': colors.map((e) => e.toMap()).toList(),
      'createdDate': createdDate,
      'discountedPrice': discountedPrice,
      'gender': gender,
      'images': images.map((e) => e.toString()).toList(),
      'price': price,
      'sizes': sizes.map((e) => e.toString()).toList(),
      'productId': productId,
      'salesNumber': salesNumber,
      'title': title,
    };
  }
}

extension ProductXModel on ProductModel {
  ProductEntity toEntity() {
    return ProductEntity(
      categoryId: categoryId,
      colors: colors.map((e) => e.toEntity()).toList(),
      createdDate: createdDate,
      discountedPrice: discountedPrice,
      gender: gender,
      images: images,
      price: price,
      sizes: sizes,
      productId: productId,
      salesNumber: salesNumber,
      title: title,
    );
  }
}

extension ProductXEntity on ProductEntity {
  ProductModel fromEntity() {
    return ProductModel(
      categoryId: categoryId,
      colors: colors.map((e) => e.fromEntity()).toList(),
      createdDate: createdDate,
      discountedPrice: discountedPrice,
      gender: gender,
      images: images,
      price: price,
      sizes: sizes,
      productId: productId,
      salesNumber: salesNumber,
      title: title,
    );
  }
}
