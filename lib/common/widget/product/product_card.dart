import 'package:ecommerce_app_with_flutter/domain/product/entity/product.dart';
import 'package:flutter/material.dart';

import '../../../core/configs/theme/app_colors.dart';

class ProductCard extends StatelessWidget {
  final ProductEntity productEntity;
  const ProductCard({required this.productEntity, super.key});

  @override
  Widget build(BuildContext context) {

    if (productEntity.images.isNotEmpty) {
    }

    return GestureDetector(
      onTap: () {
        // AppNavigator.push(context, ProductDetailPage(productEntity: productEntity,));
      },
      child: Container(
        width: 180,
        decoration: BoxDecoration(
          color: AppColors.secondBackground,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              flex: 4,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  image: productEntity.images.isNotEmpty
                      ? DecorationImage(
                          fit: BoxFit.fill,
                          image: NetworkImage(productEntity.images[0]),
                        )
                      : null,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(8),
                    topRight: Radius.circular(8),
                  ),
                ),
                child: productEntity.images.isEmpty
                    ? const Center(
                        child: Icon(
                          Icons.image_not_supported,
                          color: Colors.grey,
                          size: 50,
                        ),
                      )
                    : null,
              ),
            ),
            Expanded(
              flex: 1,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      productEntity.title,
                      style: const TextStyle(
                        fontSize: 12,
                        overflow: TextOverflow.ellipsis,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                    Row(
                      children: [
                        Text(
                          productEntity.discountedPrice > 0
                              ? "\$${productEntity.discountedPrice}"
                              : "\$${productEntity.price}",
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        if (productEntity.discountedPrice > 0) ...[
                          const SizedBox(width: 8),
                          Text(
                            "\$${productEntity.price}",
                            style: const TextStyle(
                              fontSize: 10,
                              color: Colors.grey,
                              fontWeight: FontWeight.w300,
                              decoration: TextDecoration.lineThrough,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
