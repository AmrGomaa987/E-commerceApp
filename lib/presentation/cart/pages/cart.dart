import 'package:ecommerce_app_with_flutter/common/widget/appbar/app_bar.dart';
import 'package:ecommerce_app_with_flutter/domain/order/entity/product_ordered.dart';
import 'package:ecommerce_app_with_flutter/presentation/cart/bloc/cart_products_display_cubit.dart';
import 'package:ecommerce_app_with_flutter/presentation/cart/bloc/cart_products_display_state.dart';

import 'package:ecommerce_app_with_flutter/presentation/cart/widgets/checkout.dart';

import 'package:ecommerce_app_with_flutter/presentation/cart/widgets/grouped_product_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../core/configs/assets/app_vectors.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const BasicAppbar(title: Text('Cart')),
      body: BlocProvider(
        create: (context) => CartProductsDisplayCubit()..displayCartProducts(),
        child: BlocBuilder<CartProductsDisplayCubit, CartProductsDisplayState>(
          builder: (context, state) {
            if (state is CartProductsLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state is CartProductsLoaded) {
              return state.products.isEmpty
                  ? Center(child: _cartIsEmpty())
                  : Stack(
                      children: [
                        _products(state.products),
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: Checkout(products: state.products),
                        ),
                      ],
                    );
            }
            if (state is LoadCartProductsFailure) {
              return Center(child: Text(state.errorMessage));
            }
            return Container();
          },
        ),
      ),
    );
  }

  Widget _products(List<ProductOrderedEntity> products) {
    // Group products by productId
    Map<String, List<ProductOrderedEntity>> groupedProducts = {};
    for (var product in products) {
      if (groupedProducts.containsKey(product.productId)) {
        groupedProducts[product.productId]!.add(product);
      } else {
        groupedProducts[product.productId] = [product];
      }
    }

    return ListView.builder(
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        top: 16,
        bottom:
            MediaQuery.of(context).size.height / 3.5 +
            20, // Dynamic padding based on checkout height
      ),
      itemCount: groupedProducts.length,
      itemBuilder: (context, index) {
        String productId = groupedProducts.keys.elementAt(index);
        List<ProductOrderedEntity> variants = groupedProducts[productId]!;

        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: GroupedProductCard(
            productId: productId,
            variants: variants,
            cubit: context.read<CartProductsDisplayCubit>(),
          ),
        );
      },
    );
  }

  Widget _cartIsEmpty() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SvgPicture.asset(AppVectors.cartBag),
        const SizedBox(height: 20),
        const Text(
          "Cart is empty",
          textAlign: TextAlign.center,
          style: TextStyle(fontWeight: FontWeight.w500, fontSize: 20),
        ),
      ],
    );
  }
}
