import 'package:ecommerce_app_with_flutter/common/helpr/product/product_price.dart';
import 'package:ecommerce_app_with_flutter/core/configs/theme/app_colors.dart';
import 'package:ecommerce_app_with_flutter/domain/order/entity/product_ordered.dart';
import 'package:ecommerce_app_with_flutter/presentation/cart/bloc/cart_products_display_cubit.dart';
import 'package:flutter/material.dart';

class GroupedProductCard extends StatefulWidget {
  final String productId;
  final List<ProductOrderedEntity> variants;
  final CartProductsDisplayCubit cubit;

  const GroupedProductCard({
    required this.productId,
    required this.variants,
    required this.cubit,
    super.key,
  });

  @override
  State<GroupedProductCard> createState() => _GroupedProductCardState();
}

class _GroupedProductCardState extends State<GroupedProductCard> {
  String? selectedColor;
  String currentImageUrl = '';

  @override
  void initState() {
    super.initState();
    // Initialize with the first variant's color and image
    if (widget.variants.isNotEmpty) {
      selectedColor = widget.variants.first.productColor;
      currentImageUrl = widget.variants.first.productImage;
    }
  }

  @override
  Widget build(BuildContext context) {
    // Use the first variant for common product info
    final firstVariant = widget.variants.first;

    // Calculate total quantity and price for all variants
    final totalQuantity = widget.variants.fold<int>(
      0,
      (sum, variant) => sum + variant.productQuantity,
    );
    final totalPrice = widget.variants.fold<double>(
      0.0,
      (sum, variant) => sum + variant.totalPrice,
    );

    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: AppColors.secondBackground,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Product header with image and basic info
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Product image with color selection
              Column(
                children: [
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        currentImageUrl,
                        fit: BoxFit.cover,
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return Center(
                            child: CircularProgressIndicator(
                              value: loadingProgress.expectedTotalBytes != null
                                  ? loadingProgress.cumulativeBytesLoaded /
                                        loadingProgress.expectedTotalBytes!
                                  : null,
                              strokeWidth: 2,
                              color: AppColors.primary,
                            ),
                          );
                        },
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            color: Colors.grey.withValues(alpha: 0.3),
                            child: const Icon(
                              Icons.image_not_supported,
                              color: Colors.grey,
                              size: 30,
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  // Color selection dots
                  _buildColorSelector(),
                ],
              ),
              const SizedBox(width: 12),
              // Product info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      firstVariant.productTitle,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                        color: Colors.white,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Total: $totalQuantity items',
                      style: const TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      ProductPriceHelper.formatPriceWithCurrency(totalPrice),
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),
              ),
              // Delete all variants button
              GestureDetector(
                onTap: () => _deleteAllVariants(context),
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.red.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.delete_outline,
                    color: Colors.red,
                    size: 20,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Variants list
          Column(
            children: widget.variants
                .map((variant) => _buildVariantRow(context, variant))
                .toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildColorSelector() {
    // Get unique colors from variants
    Set<String> uniqueColors = widget.variants
        .map((v) => v.productColor)
        .toSet();

    if (uniqueColors.length <= 1) {
      return const SizedBox.shrink(); // Hide if only one color
    }

    return Column(
      children: [
        const Text(
          'Colors',
          style: TextStyle(
            color: Colors.grey,
            fontSize: 10,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 4),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: uniqueColors.map((color) {
            bool isSelected =
                selectedColor?.toLowerCase() == color.toLowerCase();

            return GestureDetector(
              onTap: () => _onColorSelected(color),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: isSelected ? 20 : 16,
                height: isSelected ? 20 : 16,
                margin: const EdgeInsets.symmetric(horizontal: 3),
                decoration: BoxDecoration(
                  color: _getColorFromName(color),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isSelected
                        ? AppColors.primary
                        : Colors.grey.withValues(alpha: 0.5),
                    width: isSelected ? 3 : 1,
                  ),
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                            color: AppColors.primary.withValues(alpha: 0.3),
                            blurRadius: 4,
                            spreadRadius: 1,
                          ),
                        ]
                      : null,
                ),
                child: isSelected
                    ? const Icon(Icons.check, size: 12, color: Colors.white)
                    : null,
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  void _onColorSelected(String color) {
    setState(() {
      selectedColor = color;
      // Find a variant with this color to get the image
      final variantWithColor = widget.variants.firstWhere(
        (variant) => variant.productColor.toLowerCase() == color.toLowerCase(),
        orElse: () => widget.variants.first,
      );

      // Use the image from the variant, but also try to get the correct image
      // based on color index if the variant has the wrong image
      currentImageUrl = _getCorrectImageForColor(color, variantWithColor);
    });
  }

  String _getCorrectImageForColor(
    String color,
    ProductOrderedEntity fallbackVariant,
  ) {
    // First, try to find a variant with the exact color match
    final exactMatch = widget.variants.firstWhere(
      (variant) => variant.productColor.toLowerCase() == color.toLowerCase(),
      orElse: () => fallbackVariant,
    );

    // If we found an exact match and it has a valid image, use it
    if (exactMatch.productImage.isNotEmpty) {
      return exactMatch.productImage;
    }

    // Try to find the correct image based on color index as fallback
    final colorIndex = _getColorIndex(color);
    if (colorIndex >= 0) {
      final allImages = widget.variants
          .map((v) => v.productImage)
          .where((img) => img.isNotEmpty)
          .toSet()
          .toList();

      if (colorIndex < allImages.length) {
        return allImages[colorIndex];
      }
    }

    // Final fallback to the variant's image or first available image
    if (fallbackVariant.productImage.isNotEmpty) {
      return fallbackVariant.productImage;
    }

    // Last resort - use any available image
    final anyImage = widget.variants
        .map((v) => v.productImage)
        .where((img) => img.isNotEmpty)
        .firstOrNull;

    return anyImage ?? '';
  }

  int _getColorIndex(String color) {
    // Map colors to their expected index based on your Firebase structure
    switch (color.toLowerCase()) {
      case 'orange':
        return 0;
      case 'white':
        return 1;
      case 'blue':
        return 2;
      case 'red':
        return 3;
      case 'green':
        return 4;
      case 'black':
        return 5;
      default:
        return -1;
    }
  }

  Color _getColorFromName(String colorName) {
    switch (colorName.toLowerCase()) {
      case 'orange':
        return const Color(0xFFEC6D26);
      case 'white':
        return const Color(0xFFFFFFFF);
      case 'blue':
        return const Color(0xFF4468E5);
      case 'red':
        return const Color(0xFFFF0000);
      case 'green':
        return const Color(0xFF00FF00);
      case 'black':
        return const Color(0xFF000000);
      case 'yellow':
        return const Color(0xFFFFFF00);
      case 'purple':
        return const Color(0xFF800080);
      case 'pink':
        return const Color(0xFFFFC0CB);
      case 'brown':
        return const Color(0xFFA52A2A);
      case 'grey':
      case 'gray':
        return const Color(0xFF808080);
      default:
        return Colors.grey; // Default color for unknown colors
    }
  }

  Widget _buildVariantRow(BuildContext context, ProductOrderedEntity variant) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.withValues(alpha: 0.3)),
      ),
      child: Column(
        children: [
          // First row: Size, Color, and Price
          Row(
            children: [
              Expanded(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Size',
                      style: TextStyle(color: Colors.grey, fontSize: 9),
                    ),
                    Text(
                      variant.productSize,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Color',
                      style: TextStyle(color: Colors.grey, fontSize: 9),
                    ),
                    Text(
                      variant.productColor,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 3,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Price',
                      style: TextStyle(color: Colors.grey, fontSize: 9),
                    ),
                    Text(
                      ProductPriceHelper.formatPriceWithCurrency(
                        variant.totalPrice,
                      ),
                      style: const TextStyle(
                        color: AppColors.primary,
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Second row: Quantity controls
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Quantity:',
                style: TextStyle(color: Colors.grey, fontSize: 10),
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Decrease button
                  GestureDetector(
                    onTap: () {
                      if (variant.productQuantity > 1) {
                        widget.cubit.updateQuantity(
                          variant,
                          variant.productQuantity - 1,
                        );
                      }
                    },
                    child: Container(
                      width: 28,
                      height: 28,
                      decoration: BoxDecoration(
                        color: variant.productQuantity > 1
                            ? AppColors.primary
                            : Colors.grey,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.remove,
                        size: 16,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  // Quantity display
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      variant.productQuantity.toString(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  // Increase button
                  GestureDetector(
                    onTap: () {
                      widget.cubit.updateQuantity(
                        variant,
                        variant.productQuantity + 1,
                      );
                    },
                    child: Container(
                      width: 24,
                      height: 24,
                      decoration: const BoxDecoration(
                        color: AppColors.primary,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.add,
                        size: 14,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  // Delete this variant button
                  GestureDetector(
                    onTap: () {
                      widget.cubit.removeProduct(variant);
                    },
                    child: Container(
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        color: Colors.red.withValues(alpha: 0.1),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.red.withValues(alpha: 0.3),
                        ),
                      ),
                      child: const Icon(
                        Icons.close,
                        size: 12,
                        color: Colors.red,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _deleteAllVariants(BuildContext context) {
    // Show confirmation dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: AppColors.background,
          title: const Text(
            'Remove Product',
            style: TextStyle(color: Colors.white),
          ),
          content: Text(
            'Remove all variants of "${widget.variants.first.productTitle}" from cart?',
            style: const TextStyle(color: Colors.grey),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                // Remove all variants
                for (var variant in widget.variants) {
                  widget.cubit.removeProduct(variant);
                }
              },
              child: const Text('Remove', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }
}
