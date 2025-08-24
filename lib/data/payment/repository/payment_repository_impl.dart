import 'package:dartz/dartz.dart';
import 'package:ecommerce_app_with_flutter/data/payment/models/payment_request.dart';
import 'package:ecommerce_app_with_flutter/data/payment/models/payment_response.dart';
import 'package:ecommerce_app_with_flutter/data/payment/source/paymob_service.dart';
import 'package:ecommerce_app_with_flutter/core/configs/payment/paymob_config.dart';
import 'package:ecommerce_app_with_flutter/domain/payment/repository/payment_repository.dart';
import 'package:ecommerce_app_with_flutter/service_locator.dart';

class PaymentRepositoryImpl implements PaymentRepository {
  @override
  Future<Either<String, PaymentResponse>> processPayment({
    required PaymentRequest paymentRequest,
    required PaymentMethod paymentMethod,
    CardDetails? cardDetails,
  }) async {
    try {
      if (paymentMethod == PaymentMethod.cashOnDelivery) {
        // For cash on delivery, we just return success
        return Right(
          PaymentResponse.success(
            message:
                'Order placed successfully. Payment will be collected on delivery.',
          ),
        );
      }

      if (paymentMethod == PaymentMethod.creditCard) {
        if (cardDetails == null) {
          return Left('Card details are required for credit card payment');
        }

        return await _processCreditCardPayment(paymentRequest, cardDetails);
      }

      return Left('Unsupported payment method');
    } catch (e) {
      return Left('Payment processing failed: $e');
    }
  }

  Future<Either<String, PaymentResponse>> _processCreditCardPayment(
    PaymentRequest paymentRequest,
    CardDetails cardDetails,
  ) async {
    try {
      final payMobService = sl<PayMobService>();

      // Step 1: Authenticate
      final authResult = await payMobService.authenticate();
      if (authResult.isLeft()) {
        return Left('Authentication failed');
      }

      // Step 2: Create order
      final orderResult = await payMobService.createOrder(
        paymentRequest.amount,
        paymentRequest.currency,
      );
      if (orderResult.isLeft()) {
        return Left('Order creation failed');
      }

      final orderId = orderResult.getOrElse(() => 0);

      // Step 3: Create payment key
      final billingData = paymentRequest.toBillingData();
      // Add cardholder name to billing data (ensure valid strings)
      final nameParts = cardDetails.holderName.trim().split(' ');
      billingData['first_name'] = nameParts.first.trim();
      billingData['last_name'] = nameParts.length > 1
          ? nameParts.last.trim()
          : nameParts.first
                .trim(); // Use first name as last name if only one name provided

      // Ensure names are not empty
      if (billingData['first_name'].toString().isEmpty) {
        billingData['first_name'] = 'Test';
      }
      if (billingData['last_name'].toString().isEmpty) {
        billingData['last_name'] = 'User';
      }

      // Debug: Print final billing data

      final paymentKeyResult = await payMobService.createPaymentKey(
        orderId: orderId,
        amount: paymentRequest.amount,
        currency: paymentRequest.currency,
        billingData: billingData,
      );
      if (paymentKeyResult.isLeft()) {
        return Left('Payment key creation failed');
      }

      final paymentKey = paymentKeyResult.getOrElse(() => '');

      // iFrame flow: return redirect info so UI can open the iFrame
      final iframeUrl = '${PayMobConfig.iframeUrl}?payment_token=$paymentKey';
      return Right(
        PaymentResponse.failure(
          message: 'REDIRECT_IFRAME',
          data: {
            'payment_token': paymentKey,
            'iframe_url': iframeUrl,
            'order_id': orderId.toString(),
          },
        ),
      );
    } catch (e) {
      return Left('Credit card payment failed: $e');
    }
  }

  @override
  Future<Either<String, String>> validatePayment(String transactionId) async {
    try {
      // Here you would typically verify the payment status with PayMob
      // For now, we'll return success
      return Right('Payment validated successfully');
    } catch (e) {
      return Left('Payment validation failed: $e');
    }
  }
}
