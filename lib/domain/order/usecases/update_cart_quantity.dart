import 'package:dartz/dartz.dart';
import 'package:ecommerce_app_with_flutter/core/usecase/usecase.dart';
import 'package:ecommerce_app_with_flutter/domain/order/repository/order.dart';
import 'package:ecommerce_app_with_flutter/service_locator.dart';

class UpdateCartQuantityParams {
  final String cartItemId;
  final int newQuantity;
  final double unitPrice;

  UpdateCartQuantityParams({
    required this.cartItemId,
    required this.newQuantity,
    required this.unitPrice,
  });
}

class UpdateCartQuantityUseCase implements UseCase<Either, UpdateCartQuantityParams> {
  @override
  Future<Either> call({UpdateCartQuantityParams? params}) async {
    return sl<OrderRepository>().updateCartQuantity(params!);
  }
}
