import 'package:dartz/dartz.dart';

import 'package:ecommerce_app_with_flutter/data/order/models/add_to_cart_req.dart';

abstract class OrderRepository {

  Future<Either> addToCart(AddToCartReq addToCartReq);
  Future<Either> getCartProducts();
   Future<Either> removeCartProduct(String id);
  // Future<Either> orderRegistration(OrderRegistrationReq order);
  // Future<Either> getOrders();
}