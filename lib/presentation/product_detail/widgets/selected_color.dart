import 'package:ecommerce_app_with_flutter/common/helpr/bottomsheet/app_bottomsheet.dart';
import 'package:ecommerce_app_with_flutter/core/configs/theme/app_colors.dart';
import 'package:ecommerce_app_with_flutter/domain/product/entity/product.dart';
import 'package:ecommerce_app_with_flutter/presentation/product_detail/bloc/product_color_selection_cubit.dart';
import 'package:ecommerce_app_with_flutter/presentation/product_detail/widgets/product_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SelectedColor extends StatelessWidget {
  final ProductEntity productEntity;
  const SelectedColor({required this.productEntity, super.key});

  Color _getSelectedColor(int selectedIndex) {
    if (productEntity.colors.isEmpty) {
      return Colors.grey; // Default color when no colors available
    }
    if (selectedIndex >= 0 && selectedIndex < productEntity.colors.length) {
      final colorEntity = productEntity.colors[selectedIndex];
      if (colorEntity.rgb.length >= 3) {
        return Color.fromRGBO(
          colorEntity.rgb[0],
          colorEntity.rgb[1],
          colorEntity.rgb[2],
          1,
        );
      }
    }
    // Fallback: try first color or default to grey
    if (productEntity.colors.isNotEmpty &&
        productEntity.colors[0].rgb.length >= 3) {
      final firstColor = productEntity.colors[0];
      return Color.fromRGBO(
        firstColor.rgb[0],
        firstColor.rgb[1],
        firstColor.rgb[2],
        1,
      );
    }
    return Colors.grey; // Ultimate fallback
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        AppBottomsheet.display(
          context,
          BlocProvider.value(
            value: BlocProvider.of<ProductColorSelectionCubit>(context),
            child: ProductColors(productEntity: productEntity),
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
              'Color',
              style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
            ),
            Row(
              children: [
                BlocBuilder<ProductColorSelectionCubit, int>(
                  builder: (context, state) => Container(
                    height: 20,
                    width: 20,
                    decoration: BoxDecoration(
                      color: _getSelectedColor(state),
                      shape: BoxShape.circle,
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
