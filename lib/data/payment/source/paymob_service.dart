import 'dart:convert';
import 'package:dartz/dartz.dart';
import 'package:ecommerce_app_with_flutter/core/configs/payment/paymob_config.dart';
import 'package:http/http.dart' as http;
import 'package:crypto/crypto.dart';

abstract class PayMobService {
  Future<Either<String, String>> authenticate();
  Future<Either<String, int>> createOrder(double amount, String currency);
  Future<Either<String, String>> createPaymentKey({
    required int orderId,
    required double amount,
    required String currency,
    required Map<String, dynamic> billingData,
  });
  Future<Either<String, String>> processPayment({
    required String paymentKey,
    required String cardNumber,
    required String expiryMonth,
    required String expiryYear,
    required String cvv,
    required String cardholderName,
  });
}

class PayMobServiceImpl implements PayMobService {
  String? _authToken;

  @override
  Future<Either<String, String>> authenticate() async {
    try {
      final response = await http.post(
        Uri.parse(PayMobConfig.authUrl),
        headers: PayMobConfig.getHeaders(),
        body: jsonEncode({'api_key': PayMobConfig.apiKey}),
      );

      if (response.statusCode == 201) {
        final data = jsonDecode(response.body);
        _authToken = data['token'];
        return Right(_authToken!);
      } else {
        return Left('Authentication failed: ${response.body}');
      }
    } catch (e) {
      return Left('Authentication error: $e');
    }
  }

  @override
  Future<Either<String, int>> createOrder(
    double amount,
    String currency,
  ) async {
    if (_authToken == null) {
      final authResult = await authenticate();
      if (authResult.isLeft()) {
        return Left('Authentication required');
      }
    }

    try {
      final response = await http.post(
        Uri.parse(PayMobConfig.orderUrl),
        headers: PayMobConfig.getHeaders(authToken: _authToken),
        body: jsonEncode({
          'auth_token': _authToken,
          'delivery_needed': 'false',
          'amount_cents': (amount * 100).toInt(), // Convert to cents
          'currency': currency,
          'items': [],
        }),
      );

      if (response.statusCode == 201) {
        final data = jsonDecode(response.body);
        return Right(data['id']);
      } else {
        return Left('Order creation failed: ${response.body}');
      }
    } catch (e) {
      return Left('Order creation error: $e');
    }
  }

  @override
  Future<Either<String, String>> createPaymentKey({
    required int orderId,
    required double amount,
    required String currency,
    required Map<String, dynamic> billingData,
  }) async {
    if (_authToken == null) {
      final authResult = await authenticate();
      if (authResult.isLeft()) {
        return Left('Authentication required');
      }
    }

    try {
      final requestBody = {
        'auth_token': _authToken,
        'amount_cents': (amount * 100).toInt(),
        'expiration': 3600,
        'order_id': orderId,
        'billing_data': billingData,
        'currency': currency,
        'integration_id': PayMobConfig.integrationId,
      };

      // Debug logging

      final response = await http.post(
        Uri.parse(PayMobConfig.paymentKeyUrl),
        headers: PayMobConfig.getHeaders(authToken: _authToken),
        body: jsonEncode(requestBody),
      );

      // Debug logging
    

      if (response.statusCode == 201) {
        final data = jsonDecode(response.body);
        return Right(data['token']);
      } else {
        return Left('Payment key creation failed: ${response.body}');
      }
    } catch (e) {
      return Left('Payment key creation error: $e');
    }
  }

  @override
  Future<Either<String, String>> processPayment({
    required String paymentKey,
    required String cardNumber,
    required String expiryMonth,
    required String expiryYear,
    required String cvv,
    required String cardholderName,
  }) async {
    // Validate required fields
    if (cardNumber.trim().isEmpty) {
      return Left('Card number is required');
    }
    if (cvv.trim().isEmpty) {
      return Left('CVV is required');
    }

    try {
      // PayMob Payment Request with cardholder_name in source
      final requestBody = {
        'source': {
          'identifier': cardNumber.replaceAll(' ', ''),
          'subtype': 'CARD',
          'month': expiryMonth.padLeft(2, '0'),
          'year': expiryYear,
          'cvn': cvv,
          'cardholder_name': cardholderName.trim(),
        },
        'payment_token': paymentKey,
      };

      // Debug logging

      final response = await http.post(
        Uri.parse(PayMobConfig.paymentUrl),
        headers: PayMobConfig.getHeaders(),
        body: jsonEncode(requestBody),
      );

      // Debug logging
 
      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);
        if (data['success'] == true) {
          return Right('Payment successful');
        } else {
          // Extract more detailed error information
          String errorMessage = 'Payment failed';
          if (data['data'] != null) {
            if (data['data']['message'] != null) {
              errorMessage = data['data']['message'];
            } else if (data['data']['txn_response_code'] != null) {
              errorMessage =
                  'Transaction failed: ${data['data']['txn_response_code']}';
            }
          }
          return Left(errorMessage);
        }
      } else {
        // Parse error response for better error messages
        try {
          final errorData = jsonDecode(response.body);
          String errorMessage = 'Payment processing failed';
          if (errorData['detail'] != null) {
            errorMessage = errorData['detail'];
          } else if (errorData['message'] != null) {
            errorMessage = errorData['message'];
          }
          return Left(errorMessage);
        } catch (e) {
          return Left('Payment processing failed: ${response.body}');
        }
      }
    } catch (e) {
      return Left('Payment processing error: $e');
    }
  }

  // Helper method to generate HMAC for webhook verification
  String generateHmac(Map<String, dynamic> data) {
    final sortedKeys = data.keys.toList()..sort();
    final concatenatedString = sortedKeys
        .map((key) => data[key].toString())
        .join('');

    final bytes = utf8.encode(concatenatedString + PayMobConfig.hmacSecret);
    final digest = sha512.convert(bytes);
    return digest.toString();
  }

  // Method to verify webhook HMAC
  bool verifyHmac(Map<String, dynamic> data, String receivedHmac) {
    final calculatedHmac = generateHmac(data);
    return calculatedHmac == receivedHmac;
  }
}
