import 'package:dartz/dartz.dart';
import 'package:ecommerce_app_with_flutter/core/usecase/usecase.dart';
import 'package:ecommerce_app_with_flutter/domain/auth/repository/auth.dart';
import 'package:ecommerce_app_with_flutter/service_locator.dart';


class SendpasswordResetEmailUseCase implements UseCase<Either, String> {
  @override
  Future<Either> call({String? params}) async {
    return sl<AuthRepositry>().sendPasswordResetEmail(params!);
  }
}
