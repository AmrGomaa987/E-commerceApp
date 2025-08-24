import 'package:dartz/dartz.dart';
import 'package:ecommerce_app_with_flutter/core/usecase/usecase.dart';
import 'package:ecommerce_app_with_flutter/data/payment/models/payment_request.dart';
import 'package:ecommerce_app_with_flutter/data/payment/models/payment_response.dart';
import 'package:ecommerce_app_with_flutter/domain/payment/repository/payment_repository.dart';
import 'package:ecommerce_app_with_flutter/service_locator.dart';

class ProcessPaymentParams {
  final PaymentRequest paymentRequest;
  final PaymentMethod paymentMethod;
  final CardDetails? cardDetails;

  ProcessPaymentParams({
    required this.paymentRequest,
    required this.paymentMethod,
    this.cardDetails,
  });
}

class ProcessPaymentUseCase
    implements UseCase<Either<String, PaymentResponse>, ProcessPaymentParams> {
  @override
  Future<Either<String, PaymentResponse>> call({
    ProcessPaymentParams? params,
  }) async {
    if (params == null) {
      return Left('Payment parameters are required');
    }

    return await sl<PaymentRepository>().processPayment(
      paymentRequest: params.paymentRequest,
      paymentMethod: params.paymentMethod,
      cardDetails: params.cardDetails,
    );
  }
}
