import 'package:dartz/dartz.dart';
import 'package:ecommerce_app_with_flutter/core/usecase/usecase.dart';
import 'package:ecommerce_app_with_flutter/domain/category/repository/category.dart';
import 'package:ecommerce_app_with_flutter/service_locator.dart';


class GetCategoriesUseCase implements UseCase<Either,dynamic> {

  @override
  Future<Either> call({dynamic params}) async {
    return await sl<CategoryRepository>().getCategories();
  }

}