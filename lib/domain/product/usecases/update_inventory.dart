import 'package:dartz/dartz.dart';
import 'package:ecommerce_app_with_flutter/core/usecase/usecase.dart';
import 'package:ecommerce_app_with_flutter/domain/order/entity/product_ordered.dart';
import 'package:ecommerce_app_with_flutter/domain/product/repository/product.dart';
import 'package:ecommerce_app_with_flutter/service_locator.dart';

class UpdateInventoryParams {
  final List<ProductOrderedEntity> products;

  UpdateInventoryParams({
    required this.products,
  });
}

class UpdateInventoryUseCase implements UseCase<Either, UpdateInventoryParams> {
  @override
  Future<Either> call({UpdateInventoryParams? params}) async {
    return sl<ProductRepository>().updateInventory(params!);
  }
}
