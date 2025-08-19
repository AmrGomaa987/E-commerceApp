import 'package:dartz/dartz.dart';
import 'package:ecommerce_app_with_flutter/core/usecase/usecase.dart';

import 'package:ecommerce_app_with_flutter/domain/order/repository/order.dart';
import 'package:ecommerce_app_with_flutter/service_locator.dart';

class RemoveCartProductUseCase implements UseCase<Either,String> {
  @override
  Future<Either> call({String ? params}) async {
    return sl<OrderRepository>().removeCartProduct(params!);
  }

}