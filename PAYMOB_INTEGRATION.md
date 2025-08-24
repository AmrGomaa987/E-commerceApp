# PayMob Egypt Integration Guide

This document explains how to integrate and use PayMob Egypt payment gateway in your Flutter ecommerce app.

## Overview

PayMob Egypt is a leading payment gateway in Egypt that allows you to accept online payments through credit cards, debit cards, and other payment methods. This integration provides:

- Credit card payments
- Cash on delivery option
- Secure payment processing
- Test and production environments
- Comprehensive error handling

## Features Implemented

✅ **Payment Method Selection**: Users can choose between Cash on Delivery and Credit Card payment
✅ **Credit Card Processing**: Full credit card payment flow with PayMob
✅ **Payment Validation**: Form validation and card details verification
✅ **Error Handling**: Comprehensive error handling with user-friendly messages
✅ **Success/Failure Pages**: Dedicated pages for payment outcomes
✅ **Order Integration**: Seamless integration with existing order system
✅ **Test Environment**: Ready for testing with PayMob test credentials

## Setup Instructions

### 1. PayMob Account Setup

1. **Create PayMob Account**:
   - Visit [PayMob Egypt](https://paymob.com/en/)
   - Sign up for a merchant account
   - Complete the verification process

2. **Get API Credentials**:
   - Login to your PayMob dashboard
   - Navigate to Settings > API Keys
   - Copy your API Key, Integration ID, and HMAC Secret

### 2. Configure Credentials

Update the credentials in `lib/core/configs/payment/paymob_config.dart`:

```dart
class PayMobConfig {
  // Replace with your actual PayMob credentials
  static const String apiKey = 'YOUR_API_KEY_HERE';
  static const int integrationId = YOUR_INTEGRATION_ID;
  static const String hmacSecret = 'YOUR_HMAC_SECRET';
  
  // ... rest of the configuration
}
```

### 3. Test the Integration

1. **Run the Test Page**:
   ```dart
   // Navigate to PaymentTestPage to test the integration
   Navigator.push(context, MaterialPageRoute(
     builder: (context) => PaymentTestPage(),
   ));
   ```

2. **Test Payment Flow**:
   - Use the test card details provided in the config
   - Test both successful and failed payment scenarios

## Usage

### 1. Basic Payment Flow

The payment flow follows these steps:

1. **Checkout**: User enters shipping details and phone number
2. **Payment Method Selection**: User chooses between Cash on Delivery or Credit Card
3. **Credit Card Details**: If credit card is selected, user enters card details
4. **Payment Processing**: Payment is processed through PayMob
5. **Order Confirmation**: Order is saved and user sees confirmation

### 2. Code Example

```dart
// Create payment request
final paymentRequest = PaymentRequest(
  amount: 100.0,
  currency: 'EGP',
  customerEmail: 'customer@example.com',
  customerPhone: '+201234567890',
  customerFirstName: 'John',
  customerLastName: 'Doe',
  shippingAddress: '123 Main St, Cairo, Egypt',
  items: [
    PaymentItem(
      name: 'Product Name',
      description: 'Product Description',
      amount: 100.0,
      quantity: 1,
    ),
  ],
);

// Process payment
final result = await ProcessPaymentUseCase().call(
  params: ProcessPaymentParams(
    paymentRequest: paymentRequest,
    paymentMethod: PaymentMethod.creditCard,
    cardDetails: CardDetails(
      cardNumber: '4987654321098769',
      expiryMonth: '05',
      expiryYear: '25',
      cvv: '123',
      holderName: 'John Doe',
    ),
  ),
);
```

## File Structure

```
lib/
├── core/configs/payment/
│   └── paymob_config.dart              # PayMob configuration
├── data/payment/
│   ├── models/
│   │   ├── payment_request.dart        # Payment request models
│   │   └── payment_response.dart       # Payment response models
│   ├── repository/
│   │   └── payment_repository_impl.dart # Payment repository implementation
│   └── source/
│       └── paymob_service.dart         # PayMob API service
├── domain/payment/
│   ├── repository/
│   │   └── payment_repository.dart     # Payment repository interface
│   └── usecases/
│       └── process_payment.dart        # Payment processing use case
└── presentation/payment/pages/
    ├── payment_method_selection.dart   # Payment method selection UI
    ├── payment_iframe_page.dart        # PayMob iFrame integration
    ├── order_confirmation.dart         # Order confirmation UI
    ├── payment_success.dart            # Payment success page
    └── payment_failure.dart            # Payment failure page
```

## Testing

### Test Card Details

Use these test card details for testing:

- **Card Number**: 4987654321098769
- **Expiry Date**: 05/25
- **CVV**: 123
- **Cardholder Name**: Test User

### Test Scenarios

1. **Successful Payment**: Use the test card details above
2. **Failed Payment**: Use invalid card details or insufficient funds
3. **Network Error**: Test with no internet connection
4. **Invalid API Key**: Test with wrong credentials

## Security Considerations

1. **API Keys**: Never commit real API keys to version control
2. **HTTPS**: Always use HTTPS in production
3. **Validation**: Validate all payment data on both client and server
4. **PCI Compliance**: Follow PCI DSS guidelines for card data handling
5. **HMAC Verification**: Verify webhook signatures using HMAC

## Production Deployment

### 1. Environment Configuration

Create separate configurations for test and production:

```dart
class PayMobConfig {
  static bool get isProduction => const bool.fromEnvironment('PRODUCTION');
  
  static String get apiKey => isProduction 
    ? 'PRODUCTION_API_KEY' 
    : 'TEST_API_KEY';
    
  static String get baseUrl => isProduction
    ? 'https://accept.paymob.com/api'
    : 'https://accept-staging.paymob.com/api';
}
```

### 2. Build Commands

```bash
# Test build
flutter build apk --dart-define=PRODUCTION=false

# Production build
flutter build apk --dart-define=PRODUCTION=true
```

## Troubleshooting

### Common Issues

1. **Authentication Failed**:
   - Check API key is correct
   - Ensure no extra spaces in credentials
   - Verify account is active

2. **Order Creation Failed**:
   - Check amount format (should be positive number)
   - Verify currency code (EGP for Egypt)
   - Ensure authentication was successful

3. **Payment Failed**:
   - Verify card details are correct
   - Check if card has sufficient funds
   - Ensure integration ID is correct

### Debug Mode

Enable debug logging by adding print statements in the PayMob service:

```dart
print('PayMob Request: ${jsonEncode(requestBody)}');
print('PayMob Response: ${response.body}');
```

## Support

For PayMob-specific issues:
- PayMob Documentation: [https://docs.paymob.com/](https://docs.paymob.com/)
- PayMob Support: support@paymob.com

For integration issues:
- Check the test page for debugging
- Review error messages in the app logs
- Verify all credentials are correctly configured

## Next Steps

1. **Webhook Integration**: Implement webhook handling for payment confirmations
2. **Refund Support**: Add refund functionality
3. **Multiple Payment Methods**: Add support for wallets and bank transfers
4. **Analytics**: Implement payment analytics and reporting
5. **Subscription Payments**: Add support for recurring payments

---

**Note**: This integration is ready for testing. Make sure to replace test credentials with production credentials before going live.
