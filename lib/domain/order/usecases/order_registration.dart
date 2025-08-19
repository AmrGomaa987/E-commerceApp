import 'package:dartz/dartz.dart';
import 'package:ecommerce_app_with_flutter/core/usecase/usecase.dart';
import 'package:ecommerce_app_with_flutter/data/order/models/order_registration_req.dart';
import 'package:ecommerce_app_with_flutter/domain/order/repository/order.dart';
import 'package:ecommerce_app_with_flutter/service_locator.dart';


class OrderRegistrationUseCase implements UseCase<Either,OrderRegistrationReq> {
  @override
  Future<Either> call({OrderRegistrationReq ? params}) async {
    return sl<OrderRepository>().orderRegistration(params!);
  }

}