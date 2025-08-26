import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:ecommerce_app_with_flutter/data/order/models/order_registration_req.dart';
import 'package:ecommerce_app_with_flutter/domain/order/usecases/update_cart_quantity.dart';
import 'package:ecommerce_app_with_flutter/domain/product/usecases/check_stock.dart';
import 'package:ecommerce_app_with_flutter/domain/product/usecases/update_inventory.dart';
import 'package:ecommerce_app_with_flutter/service_locator.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/add_to_cart_req.dart';

abstract class OrderFirebaseService {
  Future<Either> addToCart(AddToCartReq addToCartReq);
  Future<Either> getCartProducts();
  Future<Either> removeCartProduct(String id);
  Future<Either> updateCartQuantity(UpdateCartQuantityParams params);
  Future<Either> orderRegistration(OrderRegistrationReq order);
  Future<Either> getOrders();
}

class OrderFirebaseServiceImpl extends OrderFirebaseService {
  @override
  Future<Either> addToCart(AddToCartReq addToCartReq) async {
    try {
      var user = FirebaseAuth.instance.currentUser;

      // Check stock availability first
      var stockCheckResult = await sl<CheckStockUseCase>().call(
        params: CheckStockParams(
          productId: addToCartReq.productId,
          color: addToCartReq.productColor,
          size: addToCartReq.productSize,
          requestedQuantity: addToCartReq.productQuantity,
        ),
      );

      // Handle stock check result
      var stockAvailable = false;
      String stockMessage = '';
      stockCheckResult.fold(
        (error) {
          return Left('Stock check failed: $error');
        },
        (stockData) {
          stockAvailable = stockData['available'] ?? false;
          stockMessage = stockData['message'] ?? '';
        },
      );

      if (!stockAvailable) {
        return Left(stockMessage);
      }

      // Check if the same product with same color and size already exists
      var existingProducts = await FirebaseFirestore.instance
          .collection('Users')
          .doc(user!.uid)
          .collection('Cart')
          .where('productId', isEqualTo: addToCartReq.productId)
          .where('productColor', isEqualTo: addToCartReq.productColor)
          .where('productSize', isEqualTo: addToCartReq.productSize)
          .get();

      if (existingProducts.docs.isNotEmpty) {
        // Update existing item quantity
        var existingDoc = existingProducts.docs.first;
        var existingData = existingDoc.data();
        int currentQuantity = existingData['productQuantity'] ?? 0;
        int newQuantity = currentQuantity + addToCartReq.productQuantity;

        // Check stock for the new total quantity
        var totalStockCheckResult = await sl<CheckStockUseCase>().call(
          params: CheckStockParams(
            productId: addToCartReq.productId,
            color: addToCartReq.productColor,
            size: addToCartReq.productSize,
            requestedQuantity: newQuantity,
          ),
        );

        var totalStockAvailable = false;
        String totalStockMessage = '';
        totalStockCheckResult.fold(
          (error) {
            return Left('Stock check failed: $error');
          },
          (stockData) {
            totalStockAvailable = stockData['available'] ?? false;
            totalStockMessage = stockData['message'] ?? '';
          },
        );

        if (!totalStockAvailable) {
          return Left(totalStockMessage);
        }

        double newTotalPrice = addToCartReq.productPrice * newQuantity;

        await existingDoc.reference.update({
          'productQuantity': newQuantity,
          'totalPrice': newTotalPrice,
        });

        return const Right('Cart updated successfully');
      } else {
        // Add new item
        await FirebaseFirestore.instance
            .collection('Users')
            .doc(user.uid)
            .collection('Cart')
            .add(addToCartReq.toMap());
        return const Right('Add to cart was successfully');
      }
    } catch (e) {
      return const Left('Please try again.');
    }
  }

  @override
  Future<Either> getCartProducts() async {
    try {
      var user = FirebaseAuth.instance.currentUser;
      var returnedData = await FirebaseFirestore.instance
          .collection('Users')
          .doc(user!.uid)
          .collection('Cart')
          .get();

      List<Map> products = [];
      for (var item in returnedData.docs) {
        var data = item.data();
        data.addAll({'id': item.id});
        products.add(data);
      }
      return Right(products);
    } catch (e) {
      return const Left('Please try again');
    }
  }

  @override
  Future<Either> removeCartProduct(String id) async {
    try {
      var user = FirebaseAuth.instance.currentUser;
      await FirebaseFirestore.instance
          .collection('Users')
          .doc(user!.uid)
          .collection('Cart')
          .doc(id)
          .delete();
      return const Right('Product removed successfully');
    } catch (e) {
      return const Left('Please try again');
    }
  }

  @override
  Future<Either> updateCartQuantity(UpdateCartQuantityParams params) async {
    try {
      var user = FirebaseAuth.instance.currentUser;

      // Calculate new total price
      double newTotalPrice = params.unitPrice * params.newQuantity;

      await FirebaseFirestore.instance
          .collection('Users')
          .doc(user!.uid)
          .collection('Cart')
          .doc(params.cartItemId)
          .update({
            'productQuantity': params.newQuantity,
            'totalPrice': newTotalPrice,
          });

      return const Right('Quantity updated successfully');
    } catch (e) {
      return const Left('Please try again');
    }
  }

  @override
  Future<Either> orderRegistration(OrderRegistrationReq order) async {
    try {
      print(
        '🚀 OrderRegistration called for ${order.products.length} products',
      );
      var user = FirebaseAuth.instance.currentUser;

      // First, update inventory (deduct stock)
      print('📦 Calling UpdateInventoryUseCase from orderRegistration...');
      var inventoryUpdateResult = await sl<UpdateInventoryUseCase>().call(
        params: UpdateInventoryParams(products: order.products),
      );

      // Check if inventory update failed
      var inventorySuccess = false;
      inventoryUpdateResult.fold(
        (error) {
          // Inventory update failed, don't proceed with order
          return Left('Order failed: $error');
        },
        (success) {
          inventorySuccess = true;
        },
      );

      if (!inventorySuccess) {
        return const Left('Order failed: Unable to update inventory');
      }

      // If inventory update succeeded, proceed with order registration
      await FirebaseFirestore.instance
          .collection('Users')
          .doc(user!.uid)
          .collection('Orders')
          .add(order.toMap());

      // Clear cart items
      for (var item in order.products) {
        await FirebaseFirestore.instance
            .collection('Users')
            .doc(user.uid)
            .collection('Cart')
            .doc(item.id)
            .delete();
      }

      return const Right('Order registered successfully');
    } catch (e) {
      return const Left('Please try again');
    }
  }

  @override
  Future<Either> getOrders() async {
    try {
      var user = FirebaseAuth.instance.currentUser;
      var returnedData = await FirebaseFirestore.instance
          .collection("Users")
          .doc(user!.uid)
          .collection('Orders')
          .get();
      return Right(returnedData.docs.map((e) => e.data()).toList());
    } catch (e) {
      return const Left('Please try again');
    }
  }
}
