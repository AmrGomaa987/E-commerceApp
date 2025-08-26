import 'package:ecommerce_app_with_flutter/common/helpr/navigator/app_navigator.dart';
import 'package:ecommerce_app_with_flutter/common/widget/appbar/app_bar.dart';
import 'package:ecommerce_app_with_flutter/core/configs/payment/paymob_config.dart';
import 'package:ecommerce_app_with_flutter/data/order/models/order_registration_req.dart';
import 'package:ecommerce_app_with_flutter/data/payment/models/payment_request.dart';
import 'package:ecommerce_app_with_flutter/domain/order/entity/product_ordered.dart';
import 'package:ecommerce_app_with_flutter/domain/order/usecases/order_registration.dart';
import 'package:ecommerce_app_with_flutter/presentation/payment/pages/payment_success.dart';
import 'package:ecommerce_app_with_flutter/service_locator.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PaymentIframePage extends StatefulWidget {
  final String paymentToken;
  final List<ProductOrderedEntity> products;
  final PaymentRequest paymentRequest;

  const PaymentIframePage({
    super.key,
    required this.paymentToken,
    required this.products,
    required this.paymentRequest,
  });

  @override
  State<PaymentIframePage> createState() => _PaymentIframePageState();
}

class _PaymentIframePageState extends State<PaymentIframePage> {
  late final WebViewController _controller;
  bool _isLoading = true;
  bool _orderProcessed = false; // Flag to prevent double execution

  @override
  void initState() {
    super.initState();
    try {
      final iframeUrl =
          '${PayMobConfig.iframeUrl}?payment_token=${widget.paymentToken}';

      _controller = WebViewController()
        ..setJavaScriptMode(JavaScriptMode.unrestricted)
        ..setNavigationDelegate(
          NavigationDelegate(
            onPageStarted: (url) {
              setState(() => _isLoading = true);
            },
            onPageFinished: (url) {
              setState(() => _isLoading = false);
              _handleUrl(url);
            },
            onNavigationRequest: (NavigationRequest request) {
              _handleUrl(request.url);
              return NavigationDecision.navigate;
            },
            onWebResourceError: (WebResourceError error) {},
          ),
        )
        ..loadRequest(Uri.parse(iframeUrl));
    } catch (e) {
      if (!mounted) return;
    }
  }

  void _handleUrl(String url) {

    // Prevent double execution
    if (_orderProcessed) {
      return;
    }

    // Heuristic: Paymob appends query params or redirects on success/failure.
    // Common indicators: success=true, success=1, or txn_response_code=APPROVED/0000
    final uri = Uri.tryParse(url);
    if (uri == null) return;

    final success = uri.queryParameters['success'];
    final txnCode = uri.queryParameters['txn_response_code'];


    if ((success == 'true' || success == '1') ||
        (txnCode == 'APPROVED' || txnCode == '0000')) {
      // Payment successful - register the order and clear cart
      _orderProcessed = true; // Set flag to prevent double execution
      _registerOrderAndNavigateToSuccess();
    }

    // You can add failure detection if Paymob provides a clear signal in your setup
  }

  Future<void> _registerOrderAndNavigateToSuccess() async {

    // Double-check to prevent multiple executions (this should not happen due to flag in _handleUrl)
    if (!mounted) return;

    try {
      // Register the order (this will also clear the cart)
      final result = await sl<OrderRegistrationUseCase>().call(
        params: OrderRegistrationReq(
          products: widget.products,
          createdDate: DateTime.now().toString(),
          itemCount: widget.products.length,
          totalPrice: widget.paymentRequest.amount,
          shippingAddress: widget.paymentRequest.shippingAddress,
        ),
      );

      if (!mounted) return;

      result.fold(
        (error) {
          // Show error but still navigate to success since payment was completed
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Order registration failed: $error')),
          );
          _navigateToSuccess();
        },
        (success) {
          // Order registered successfully, cart is now cleared
          _navigateToSuccess();
        },
      );
    } catch (e) {
      if (!mounted) return;
      // Show error but still navigate to success since payment was completed
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Order registration failed: $e')));
      _navigateToSuccess();
    }
  }

  void _navigateToSuccess() {
    AppNavigator.pushAndRemove(
      context,
      const PaymentSuccessPage(
        message: 'Payment completed successfully via Paymob iFrame',
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const BasicAppbar(title: Text('Complete Payment')),
      body: Stack(
        children: [
          WebViewWidget(controller: _controller),
          if (_isLoading) const Center(child: CircularProgressIndicator()),
        ],
      ),
    );
  }
}
