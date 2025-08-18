import 'package:ecommerce_app_with_flutter/domain/product/entity/product.dart';
import 'package:flutter/material.dart';

class ProductImages extends StatelessWidget {
  final ProductEntity productEntity;
  const ProductImages({required this.productEntity, super.key});

  @override
  Widget build(BuildContext context) {
    if (productEntity.images.isEmpty) {
      return Container(
        height: 300,
        margin: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.image_not_supported, size: 80, color: Colors.grey),
              SizedBox(height: 16),
              Text(
                'No images available',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            ],
          ),
        ),
      );
    }

    return SizedBox(
      height: 300,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          return Container(
            width: 200,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              image: DecorationImage(
                fit: BoxFit.fill,
                image: NetworkImage(productEntity.images[index]),
                onError: (exception, stackTrace) {
                  // Handle image loading errors
                },
              ),
            ),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Colors.transparent,
              ),
            ),
          );
        },
        separatorBuilder: (context, index) => const SizedBox(width: 10),
        itemCount: productEntity.images.length,
      ),
    );
  }
}
