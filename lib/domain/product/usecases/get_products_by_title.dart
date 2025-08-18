import 'package:dartz/dartz.dart';
import 'package:ecommerce_app_with_flutter/core/usecase/usecase.dart';
import 'package:ecommerce_app_with_flutter/domain/product/repository/product.dart';
import 'package:ecommerce_app_with_flutter/service_locator.dart';


class GetProductsByTitleUseCase implements UseCase<Either,String> {

  @override
  Future<Either> call({String? params}) async {
    return await sl<ProductRepository>().getProductsByTitle(params!);
  }

}