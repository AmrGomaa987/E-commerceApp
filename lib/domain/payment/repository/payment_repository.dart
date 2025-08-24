import 'package:dartz/dartz.dart';
import 'package:ecommerce_app_with_flutter/data/payment/models/payment_request.dart';
import 'package:ecommerce_app_with_flutter/data/payment/models/payment_response.dart';

abstract class PaymentRepository {
  Future<Either<String, PaymentResponse>> processPayment({
    required PaymentRequest paymentRequest,
    required PaymentMethod paymentMethod,
    CardDetails? cardDetails,
  });

  Future<Either<String, String>> validatePayment(String transactionId);
}
