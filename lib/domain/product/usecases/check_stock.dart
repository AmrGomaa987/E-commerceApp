import 'package:dartz/dartz.dart';
import 'package:ecommerce_app_with_flutter/core/usecase/usecase.dart';
import 'package:ecommerce_app_with_flutter/domain/product/repository/product.dart';
import 'package:ecommerce_app_with_flutter/service_locator.dart';

class CheckStockParams {
  final String productId;
  final String color;
  final String size;
  final int requestedQuantity;

  CheckStockParams({
    required this.productId,
    required this.color,
    required this.size,
    required this.requestedQuantity,
  });
}

class CheckStockUseCase implements UseCase<Either, CheckStockParams> {
  @override
  Future<Either> call({CheckStockParams? params}) async {
    return sl<ProductRepository>().checkStock(params!);
  }
}
