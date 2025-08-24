import 'package:ecommerce_app_with_flutter/common/helpr/navigator/app_navigator.dart';
import 'package:ecommerce_app_with_flutter/common/helpr/product/product_price.dart';
import 'package:ecommerce_app_with_flutter/common/widget/appbar/app_bar.dart';
import 'package:ecommerce_app_with_flutter/common/widget/button/basic_app_button.dart';
import 'package:ecommerce_app_with_flutter/core/configs/theme/app_colors.dart';
import 'package:ecommerce_app_with_flutter/data/payment/models/payment_request.dart';
import 'package:ecommerce_app_with_flutter/domain/order/entity/product_ordered.dart';
import 'package:ecommerce_app_with_flutter/domain/payment/usecases/process_payment.dart';
import 'package:ecommerce_app_with_flutter/presentation/payment/pages/order_confirmation.dart';
import 'package:ecommerce_app_with_flutter/presentation/payment/pages/payment_iframe_page.dart';
import 'package:flutter/material.dart';

class PaymentMethodSelectionPage extends StatefulWidget {
  final List<ProductOrderedEntity> products;
  final double totalAmount;
  final String shippingAddress;
  final String customerEmail;
  final String customerPhone;
  final String customerFirstName;
  final String customerLastName;

  const PaymentMethodSelectionPage({
    required this.products,
    required this.totalAmount,
    required this.shippingAddress,
    required this.customerEmail,
    required this.customerPhone,
    required this.customerFirstName,
    required this.customerLastName,
    super.key,
  });

  @override
  State<PaymentMethodSelectionPage> createState() =>
      _PaymentMethodSelectionPageState();
}

class _PaymentMethodSelectionPageState
    extends State<PaymentMethodSelectionPage> {
  PaymentMethod _selectedPaymentMethod = PaymentMethod.cashOnDelivery;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const BasicAppbar(title: Text('Payment Method')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Select Payment Method',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            _buildPaymentMethodTile(
              PaymentMethod.cashOnDelivery,
              Icons.money,
              'Cash on Delivery',
              'Pay when your order is delivered',
            ),
            const SizedBox(height: 12),
            _buildPaymentMethodTile(
              PaymentMethod.creditCard,
              Icons.credit_card,
              'Credit Card',
              'Pay securely with your credit card',
            ),
            const SizedBox(height: 30),
            _buildOrderSummary(),
            const Spacer(),
            BasicAppButton(onPressed: _proceedToPayment, title: 'Continue'),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentMethodTile(
    PaymentMethod method,
    IconData icon,
    String title,
    String subtitle,
  ) {
    final isSelected = _selectedPaymentMethod == method;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedPaymentMethod = method;
        });
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(
            color: isSelected ? AppColors.primary : Colors.grey.shade300,
            width: isSelected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(12),
          color: isSelected
              ? AppColors.primary.withValues(alpha: 0.1)
              : Colors.white,
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: isSelected ? AppColors.primary : Colors.grey.shade600,
              size: 28,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: isSelected ? AppColors.primary : Colors.black,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
                  ),
                ],
              ),
            ),
            Radio<PaymentMethod>(
              value: method,
              groupValue: _selectedPaymentMethod,
              onChanged: (PaymentMethod? value) {
                if (value != null) {
                  setState(() {
                    _selectedPaymentMethod = value;
                  });
                }
              },
              activeColor: AppColors.primary,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderSummary() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.secondBackground,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Order Summary',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Items (${widget.products.length})',
                style: const TextStyle(fontSize: 14),
              ),
              Text(
                ProductPriceHelper.formatPriceWithCurrency(widget.totalAmount),
                style: const TextStyle(fontSize: 14),
              ),
            ],
          ),
          const SizedBox(height: 8),
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Delivery', style: TextStyle(fontSize: 14)),
              Text('Free', style: TextStyle(fontSize: 14, color: Colors.green)),
            ],
          ),
          const Divider(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Total',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              Text(
                ProductPriceHelper.formatPriceWithCurrency(widget.totalAmount),
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _proceedToPayment() {
    final paymentRequest = PaymentRequest(
      amount: widget.totalAmount,
      currency: 'EGP',
      customerEmail: widget.customerEmail,
      customerPhone: widget.customerPhone,
      customerFirstName: widget.customerFirstName,
      customerLastName: widget.customerLastName,
      shippingAddress: widget.shippingAddress,
      items: widget.products
          .map(
            (product) => PaymentItem(
              name: product.productTitle,
              description: '${product.productColor} - ${product.productSize}',
              amount: product.productPrice,
              quantity: product.productQuantity,
            ),
          )
          .toList(),
    );

    if (_selectedPaymentMethod == PaymentMethod.cashOnDelivery) {
      AppNavigator.push(
        context,
        OrderConfirmationPage(
          products: widget.products,
          paymentRequest: paymentRequest,
          paymentMethod: _selectedPaymentMethod,
        ),
      );
    } else {
      // For credit card, go directly to PayMob iFrame
      _processCreditCardPayment(paymentRequest);
    }
  }

  Future<void> _processCreditCardPayment(PaymentRequest paymentRequest) async {
    // Use default card details since we're going directly to PayMob iFrame
    final defaultCardDetails = CardDetails(
      cardNumber: '5123450000000008', // PayMob test card
      expiryMonth: '12',
      expiryYear: '25',
      cvv: '123',
      holderName: '${widget.customerFirstName} ${widget.customerLastName}',
    );

    // Show loading and process payment
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );

    try {
      // Process payment to get PayMob iFrame URL
      final result = await ProcessPaymentUseCase().call(
        params: ProcessPaymentParams(
          paymentRequest: paymentRequest,
          paymentMethod: PaymentMethod.creditCard,
          cardDetails: defaultCardDetails,
        ),
      );

      if (!mounted) return;
      Navigator.of(context).pop(); // Close loading dialog

      result.fold(
        (error) {
          // Show error
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('Payment failed: $error')));
        },
        (response) {
          if (response.success == false &&
              response.message == 'REDIRECT_IFRAME') {
            final token = response.data?['payment_token'] as String?;
            if (token != null) {
              AppNavigator.push(
                context,
                PaymentIframePage(
                  paymentToken: token,
                  products: widget.products,
                  paymentRequest: paymentRequest,
                ),
              );
            }
          } else {
            // Handle other responses
            AppNavigator.push(
              context,
              OrderConfirmationPage(
                products: widget.products,
                paymentRequest: paymentRequest,
                paymentMethod: PaymentMethod.creditCard,
              ),
            );
          }
        },
      );
    } catch (e) {
      if (!mounted) return;
      Navigator.of(context).pop(); // Close loading dialog
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Payment failed: $e')));
    }
  }
}
