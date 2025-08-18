import 'package:ecommerce_app_with_flutter/common/helpr/bottomsheet/app_bottomsheet.dart';
import 'package:ecommerce_app_with_flutter/core/configs/theme/app_colors.dart';
import 'package:ecommerce_app_with_flutter/domain/product/entity/product.dart';
import 'package:ecommerce_app_with_flutter/presentation/product_detail/bloc/product_size_selection_cubit.dart';
import 'package:ecommerce_app_with_flutter/presentation/product_detail/widgets/product_sizes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SelectedSize extends StatelessWidget {
  final ProductEntity productEntity;
  const SelectedSize({required this.productEntity, super.key});

  String _getSelectedSize(int selectedIndex) {
    if (productEntity.sizes.isEmpty) {
      return 'No sizes';
    }
    if (selectedIndex >= 0 && selectedIndex < productEntity.sizes.length) {
      return productEntity.sizes[selectedIndex];
    }
    return productEntity.sizes[0]; // Fallback to first size
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        AppBottomsheet.display(
          context,
          BlocProvider.value(
            value: BlocProvider.of<ProductSizeSelectionCubit>(context),
            child: ProductSizes(productEntity: productEntity),
          ),
        );
      },
      child: Container(
        height: 60,
        margin: const EdgeInsets.symmetric(horizontal: 16),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.secondBackground,
          borderRadius: BorderRadius.circular(100),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Size',
              style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
            ),
            Row(
              children: [
                BlocBuilder<ProductSizeSelectionCubit, int>(
                  builder: (context, state) => Text(
                    _getSelectedSize(state),
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ),
                const SizedBox(width: 15),
                const Icon(Icons.keyboard_arrow_down, size: 30),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
