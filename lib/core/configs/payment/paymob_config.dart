class PayMobConfig {
  // PayMob Test Credentials
  // Replace these with your actual PayMob credentials from your dashboard
  static const String apiKey =
      'ZXlKaGJHY2lPaUpJVXpVeE1pSXNJblI1Y0NJNklrcFhWQ0o5LmV5SmpiR0Z6Y3lJNklrMWxjbU5vWVc1MElpd2ljSEp2Wm1sc1pWOXdheUk2TVRBM01UQTNNU3dpYm1GdFpTSTZJbWx1YVhScFlXd2lmUS5tNEp4NnE5TnMwX3pPODkzSVJYcU9MSEhybjdRYWZqS19wNUhCVHNPWDZTWmhaZ0FjVDN1MndCSnBfRlEyY3FDLW5OOG1MdTdEa1ZCRDFiakhJSHNidw==  ';
  static const int integrationId = 5245778;
  static const int iframeId = 952654;
  static const String hmacSecret = 'CCC927C9DA7E3DEECCA371FFE7292D82';

  // PayMob API URLs
  static const String baseUrl = 'https://accept.paymob.com/api';
  static const String authUrl = '$baseUrl/auth/tokens';
  static const String orderUrl = '$baseUrl/ecommerce/orders';
  static const String paymentKeyUrl = '$baseUrl/acceptance/payment_keys';
  static const String paymentUrl = '$baseUrl/acceptance/payments/pay';
  static const String iframeUrl = '$baseUrl/acceptance/iframes/$iframeId';

  // Test Card Details (for testing purposes)
  static const String testCardNumber = '4987654321098769';
  static const String testExpiryMonth = '05';
  static const String testExpiryYear = '25';
  static const String testCvv = '123';
  static const String testHolderName = 'Test User';

  // Currency
  static const String defaultCurrency = 'EGP';

  // Validation
  static bool isValidApiKey(String apiKey) {
    return apiKey.isNotEmpty && apiKey.length > 10;
  }

  static bool isValidIntegrationId(int integrationId) {
    return integrationId > 0;
  }

  // Helper methods
  static Map<String, String> getHeaders({String? authToken}) {
    final headers = <String, String>{'Content-Type': 'application/json'};

    if (authToken != null) {
      headers['Authorization'] = 'Bearer $authToken';
    }

    return headers;
  }

  static Map<String, dynamic> getDefaultBillingData() {
    return {
      'apartment': 'N/A',
      'email': 'test@example.com',
      'floor': 'N/A',
      'first_name': 'Test',
      'street': 'Test Street',
      'building': 'N/A',
      'phone_number': '+201234567890',
      'shipping_method': 'PKG',
      'postal_code': '11511',
      'city': 'Cairo',
      'country': 'EG',
      'last_name': 'User',
      'state': 'Cairo',
    };
  }
}

// PayMob Error Codes
class PayMobErrorCodes {
  static const String invalidApiKey = 'INVALID_API_KEY';
  static const String invalidIntegrationId = 'INVALID_INTEGRATION_ID';
  static const String insufficientFunds = 'INSUFFICIENT_FUNDS';
  static const String cardDeclined = 'CARD_DECLINED';
  static const String expiredCard = 'EXPIRED_CARD';
  static const String invalidCard = 'INVALID_CARD';
  static const String networkError = 'NETWORK_ERROR';
  static const String unknownError = 'UNKNOWN_ERROR';

  static String getErrorMessage(String errorCode) {
    switch (errorCode) {
      case invalidApiKey:
        return 'Invalid API key. Please check your PayMob configuration.';
      case invalidIntegrationId:
        return 'Invalid integration ID. Please check your PayMob configuration.';
      case insufficientFunds:
        return 'Insufficient funds. Please check your account balance.';
      case cardDeclined:
        return 'Card declined. Please try a different card or contact your bank.';
      case expiredCard:
        return 'Card expired. Please use a valid card.';
      case invalidCard:
        return 'Invalid card details. Please check your card information.';
      case networkError:
        return 'Network error. Please check your internet connection and try again.';
      default:
        return 'An unexpected error occurred. Please try again.';
    }
  }
}
