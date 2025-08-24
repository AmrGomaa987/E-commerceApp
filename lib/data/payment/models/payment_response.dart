class PaymentResponse {
  final bool success;
  final String? transactionId;
  final String? orderId;
  final String message;
  final Map<String, dynamic>? data;

  PaymentResponse({
    required this.success,
    this.transactionId,
    this.orderId,
    required this.message,
    this.data,
  });

  factory PaymentResponse.fromMap(Map<String, dynamic> map) {
    return PaymentResponse(
      success: map['success'] ?? false,
      transactionId: map['transaction_id']?.toString(),
      orderId: map['order_id']?.toString(),
      message: map['message'] ?? '',
      data: map['data'],
    );
  }

  factory PaymentResponse.success({
    String? transactionId,
    String? orderId,
    String message = 'Payment completed successfully',
  }) {
    return PaymentResponse(
      success: true,
      transactionId: transactionId,
      orderId: orderId,
      message: message,
    );
  }

  factory PaymentResponse.failure({
    required String message,
    Map<String, dynamic>? data,
  }) {
    return PaymentResponse(
      success: false,
      message: message,
      data: data,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'success': success,
      'transaction_id': transactionId,
      'order_id': orderId,
      'message': message,
      'data': data,
    };
  }
}

class PayMobOrderResponse {
  final int id;
  final String createdAt;
  final bool deliveryNeeded;
  final String merchant;
  final String collector;
  final int amountCents;
  final String shippingData;
  final String currency;
  final bool isPaymentLocked;
  final bool isReturn;
  final bool isCancel;
  final bool isReturned;
  final bool isCanceled;
  final String merchantOrderId;
  final int walletNotification;
  final int paidAmountCents;
  final bool notifyUserWithEmail;
  final List<dynamic> items;
  final String orderUrl;
  final int commissionFees;
  final int deliveryFeesCents;
  final int deliveryVatCents;
  final String paymentMethod;
  final String merchantStaffTag;
  final String apiSource;
  final Map<String, dynamic> data;

  PayMobOrderResponse({
    required this.id,
    required this.createdAt,
    required this.deliveryNeeded,
    required this.merchant,
    required this.collector,
    required this.amountCents,
    required this.shippingData,
    required this.currency,
    required this.isPaymentLocked,
    required this.isReturn,
    required this.isCancel,
    required this.isReturned,
    required this.isCanceled,
    required this.merchantOrderId,
    required this.walletNotification,
    required this.paidAmountCents,
    required this.notifyUserWithEmail,
    required this.items,
    required this.orderUrl,
    required this.commissionFees,
    required this.deliveryFeesCents,
    required this.deliveryVatCents,
    required this.paymentMethod,
    required this.merchantStaffTag,
    required this.apiSource,
    required this.data,
  });

  factory PayMobOrderResponse.fromMap(Map<String, dynamic> map) {
    return PayMobOrderResponse(
      id: map['id'] ?? 0,
      createdAt: map['created_at'] ?? '',
      deliveryNeeded: map['delivery_needed'] ?? false,
      merchant: map['merchant']?.toString() ?? '',
      collector: map['collector']?.toString() ?? '',
      amountCents: map['amount_cents'] ?? 0,
      shippingData: map['shipping_data']?.toString() ?? '',
      currency: map['currency'] ?? '',
      isPaymentLocked: map['is_payment_locked'] ?? false,
      isReturn: map['is_return'] ?? false,
      isCancel: map['is_cancel'] ?? false,
      isReturned: map['is_returned'] ?? false,
      isCanceled: map['is_canceled'] ?? false,
      merchantOrderId: map['merchant_order_id']?.toString() ?? '',
      walletNotification: map['wallet_notification'] ?? 0,
      paidAmountCents: map['paid_amount_cents'] ?? 0,
      notifyUserWithEmail: map['notify_user_with_email'] ?? false,
      items: map['items'] ?? [],
      orderUrl: map['order_url'] ?? '',
      commissionFees: map['commission_fees'] ?? 0,
      deliveryFeesCents: map['delivery_fees_cents'] ?? 0,
      deliveryVatCents: map['delivery_vat_cents'] ?? 0,
      paymentMethod: map['payment_method'] ?? '',
      merchantStaffTag: map['merchant_staff_tag'] ?? '',
      apiSource: map['api_source'] ?? '',
      data: map['data'] ?? {},
    );
  }
}
