import 'package:ecommerce_app_with_flutter/common/helpr/navigator/app_navigator.dart';
import 'package:ecommerce_app_with_flutter/common/widget/appbar/app_bar.dart';
import 'package:ecommerce_app_with_flutter/common/widget/button/basic_app_button.dart';
import 'package:ecommerce_app_with_flutter/core/configs/theme/app_colors.dart';
import 'package:ecommerce_app_with_flutter/presentation/home/pages/home.dart';
import 'package:flutter/material.dart';

class PaymentSuccessPage extends StatelessWidget {
  final String? transactionId;
  final String? orderId;
  final String message;

  const PaymentSuccessPage({
    this.transactionId,
    this.orderId,
    this.message = 'Payment completed successfully!',
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const BasicAppbar(
        title: Text('Payment Success'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 120,
              height: 120,
              decoration: const BoxDecoration(
                color: Colors.green,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.check,
                color: Colors.white,
                size: 60,
              ),
            ),
            const SizedBox(height: 30),
            const Text(
              'Payment Successful!',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Text(
              message,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30),
            if (transactionId != null) ...[
              _buildInfoCard('Transaction ID', transactionId!),
              const SizedBox(height: 12),
            ],
            if (orderId != null) ...[
              _buildInfoCard('Order ID', orderId!),
              const SizedBox(height: 30),
            ],
            const SizedBox(height: 30),
            BasicAppButton(
              onPressed: () => _goToHome(context),
              title: 'Continue Shopping',
            ),
            const SizedBox(height: 16),
            TextButton(
              onPressed: () => _goToOrders(context),
              child: const Text(
                'View My Orders',
                style: TextStyle(
                  color: AppColors.primary,
                  fontSize: 16,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard(String label, String value) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
              textAlign: TextAlign.end,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  void _goToHome(BuildContext context) {
    AppNavigator.pushAndRemove(context, const HomePage());
  }

  void _goToOrders(BuildContext context) {
    // Navigate to orders page - you'll need to implement this
    AppNavigator.pushAndRemove(context, const HomePage());
  }
}
