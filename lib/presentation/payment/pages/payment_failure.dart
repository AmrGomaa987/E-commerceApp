import 'package:ecommerce_app_with_flutter/common/helpr/navigator/app_navigator.dart';
import 'package:ecommerce_app_with_flutter/common/widget/appbar/app_bar.dart';
import 'package:ecommerce_app_with_flutter/common/widget/button/basic_app_button.dart';
import 'package:ecommerce_app_with_flutter/core/configs/theme/app_colors.dart';
import 'package:ecommerce_app_with_flutter/presentation/home/pages/home.dart';
import 'package:flutter/material.dart';

class PaymentFailurePage extends StatelessWidget {
  final String errorMessage;
  final VoidCallback? onRetry;

  const PaymentFailurePage({
    required this.errorMessage,
    this.onRetry,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const BasicAppbar(
        title: Text('Payment Failed'),
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
                color: Colors.red,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.close,
                color: Colors.white,
                size: 60,
              ),
            ),
            const SizedBox(height: 30),
            const Text(
              'Payment Failed',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.red,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Text(
              errorMessage,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.red.shade50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.red.shade200),
              ),
              child: Column(
                children: [
                  const Icon(
                    Icons.info_outline,
                    color: Colors.red,
                    size: 24,
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'What to do next?',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.red,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    '• Check your card details and try again\n'
                    '• Ensure you have sufficient balance\n'
                    '• Try a different payment method\n'
                    '• Contact your bank if the issue persists',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.red,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
            if (onRetry != null) ...[
              BasicAppButton(
                onPressed: onRetry!,
                title: 'Try Again',
              ),
              const SizedBox(height: 16),
            ],
            BasicAppButton(
              onPressed: () => _goToHome(context),
              title: 'Back to Home',
            ),
            const SizedBox(height: 16),
            TextButton(
              onPressed: () => _contactSupport(context),
              child: const Text(
                'Contact Support',
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

  void _goToHome(BuildContext context) {
    AppNavigator.pushAndRemove(context, const HomePage());
  }

  void _contactSupport(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Contact Support'),
        content: const Text(
          'For payment issues, please contact our support team:\n\n'
          'Email: support@yourapp.com\n'
          'Phone: +20 123 456 7890\n\n'
          'Please include your order details when contacting us.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}
