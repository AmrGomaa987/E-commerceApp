class PaymentRequest {
  final double amount;
  final String currency;
  final String customerEmail;
  final String customerPhone;
  final String customerFirstName;
  final String customerLastName;
  final String shippingAddress;
  final List<PaymentItem> items;

  PaymentRequest({
    required this.amount,
    required this.currency,
    required this.customerEmail,
    required this.customerPhone,
    required this.customerFirstName,
    required this.customerLastName,
    required this.shippingAddress,
    required this.items,
  });

  Map<String, dynamic> toBillingData() {
    return {
      'apartment': '803',
      'email': customerEmail,
      'floor': '42',
      'first_name': customerFirstName,
      'street': shippingAddress,
      'building': '8028',
      'phone_number': customerPhone,
      'shipping_method': 'PKG',
      'postal_code': '11511',
      'city': 'Cairo',
      'country': 'EG',
      'last_name': customerLastName,
      'state': 'Cairo',
    };
  }

  Map<String, dynamic> toMap() {
    return {
      'amount': amount,
      'currency': currency,
      'customer_email': customerEmail,
      'customer_phone': customerPhone,
      'customer_first_name': customerFirstName,
      'customer_last_name': customerLastName,
      'shipping_address': shippingAddress,
      'items': items.map((item) => item.toMap()).toList(),
    };
  }
}

class PaymentItem {
  final String name;
  final String description;
  final double amount;
  final int quantity;

  PaymentItem({
    required this.name,
    required this.description,
    required this.amount,
    required this.quantity,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'description': description,
      'amount_cents': (amount * 100).toInt(),
      'quantity': quantity,
    };
  }
}

class CardDetails {
  final String cardNumber;
  final String expiryMonth;
  final String expiryYear;
  final String cvv;
  final String holderName;

  CardDetails({
    required this.cardNumber,
    required this.expiryMonth,
    required this.expiryYear,
    required this.cvv,
    required this.holderName,
  });

  Map<String, dynamic> toMap() {
    return {
      'card_number': cardNumber,
      'expiry_month': expiryMonth,
      'expiry_year': expiryYear,
      'cvv': cvv,
      'holder_name': holderName,
    };
  }
}

enum PaymentMethod { cashOnDelivery, creditCard }

extension PaymentMethodExtension on PaymentMethod {
  String get displayName {
    switch (this) {
      case PaymentMethod.cashOnDelivery:
        return 'Cash on Delivery';
      case PaymentMethod.creditCard:
        return 'Credit Card';
    }
  }

  String get value {
    switch (this) {
      case PaymentMethod.cashOnDelivery:
        return 'cod';
      case PaymentMethod.creditCard:
        return 'card';
    }
  }
}
