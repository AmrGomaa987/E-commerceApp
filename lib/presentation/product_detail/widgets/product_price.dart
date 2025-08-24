import 'package:ecommerce_app_with_flutter/common/helpr/product/product_price.dart';
import 'package:ecommerce_app_with_flutter/core/configs/theme/app_colors.dart';
import 'package:ecommerce_app_with_flutter/domain/product/entity/product.dart';
import 'package:flutter/material.dart';

class ProductPrice extends StatelessWidget {
  final ProductEntity productEntity;
  const ProductPrice({required this.productEntity, super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Text(
        ProductPriceHelper.formatPriceWithCurrency(
          productEntity.discountedPrice != 0
              ? productEntity.discountedPrice.toDouble()
              : productEntity.price.toDouble(),
        ),
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          color: AppColors.primary,
          fontSize: 14,
        ),
      ),
    );
  }
}
