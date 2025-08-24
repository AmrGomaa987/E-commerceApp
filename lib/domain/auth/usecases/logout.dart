import 'package:dartz/dartz.dart';
import 'package:ecommerce_app_with_flutter/core/usecase/usecase.dart';
import 'package:ecommerce_app_with_flutter/domain/auth/repository/auth.dart';
import 'package:ecommerce_app_with_flutter/service_locator.dart';

class LogoutUseCase implements UseCase<Either, dynamic> {
  @override
  Future<Either> call({dynamic params}) async {
    return await sl<AuthRepositry>().logout();
  }
}
