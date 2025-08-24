import 'package:ecommerce_app_with_flutter/common/helpr/cart/cart.dart';
import 'package:ecommerce_app_with_flutter/common/helpr/navigator/app_navigator.dart';
import 'package:ecommerce_app_with_flutter/common/widget/appbar/app_bar.dart';
import 'package:ecommerce_app_with_flutter/common/widget/button/basic_app_button.dart';
import 'package:ecommerce_app_with_flutter/domain/auth/entity/user.dart';
import 'package:ecommerce_app_with_flutter/domain/order/entity/product_ordered.dart';
import 'package:ecommerce_app_with_flutter/presentation/home/bloc/user_info_display_cubit.dart';
import 'package:ecommerce_app_with_flutter/presentation/home/bloc/user_info_display_state.dart';
import 'package:ecommerce_app_with_flutter/presentation/payment/pages/payment_method_selection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CheckOutPage extends StatefulWidget {
  final List<ProductOrderedEntity> products;
  const CheckOutPage({required this.products, super.key});

  @override
  State<CheckOutPage> createState() => _CheckOutPageState();
}

class _CheckOutPageState extends State<CheckOutPage> {
  final TextEditingController _addressCon = TextEditingController();
  final TextEditingController _phoneCon = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _addressCon.dispose();
    _phoneCon.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const BasicAppbar(title: Text('Checkout')),
      body: BlocProvider(
        create: (context) => UserInfoDisplayCubit()..displayUserInfo(),
        child: BlocBuilder<UserInfoDisplayCubit, UserInfoDisplayState>(
          builder: (context, state) {
            if (state is UserInfoLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state is UserInfoLoaded) {
              return _buildCheckoutForm(state.user);
            }
            if (state is LoadUserInfoFailure) {
              return const Center(
                child: Text('Failed to load user information'),
              );
            }
            return Container();
          },
        ),
      ),
    );
  }

  Widget _buildCheckoutForm(UserEntity user) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildUserInfo(user),
            const SizedBox(height: 20),
            _buildPhoneField(),
            const SizedBox(height: 20),
            _buildAddressField(),
            const SizedBox(height: 20),
            _buildOrderSummary(),
            const SizedBox(height: 30),
            BasicAppButton(
              onPressed: () => _proceedToPayment(user),
              title: 'Continue to Payment',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUserInfo(UserEntity user) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Customer Information',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text('${user.firstName} ${user.lastName}'),
          Text(user.email),
        ],
      ),
    );
  }

  Widget _buildPhoneField() {
    return TextFormField(
      controller: _phoneCon,
      keyboardType: TextInputType.phone,
      decoration: const InputDecoration(
        labelText: 'Phone Number',
        hintText: '+20 123 456 7890',
        prefixIcon: Icon(Icons.phone),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter your phone number';
        }
        return null;
      },
    );
  }

  Widget _buildAddressField() {
    return TextFormField(
      controller: _addressCon,
      minLines: 2,
      maxLines: 4,
      decoration: const InputDecoration(
        labelText: 'Shipping Address',
        hintText: 'Enter your complete address',
        prefixIcon: Icon(Icons.location_on),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter your shipping address';
        }
        return null;
      },
    );
  }

  Widget _buildOrderSummary() {
    final total = CartHelper.calculateCartSubtotal(widget.products);
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
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
              Text('Items (${widget.products.length})'),
              Text('\$${total.toStringAsFixed(2)}'),
            ],
          ),
          const SizedBox(height: 8),
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Delivery'),
              Text('Free', style: TextStyle(color: Colors.green)),
            ],
          ),
          const Divider(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Total',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(
                '\$${total.toStringAsFixed(2)}',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _proceedToPayment(UserEntity user) {
    if (_formKey.currentState!.validate()) {
      final total = CartHelper.calculateCartSubtotal(widget.products);

      AppNavigator.push(
        context,
        PaymentMethodSelectionPage(
          products: widget.products,
          totalAmount: total,
          shippingAddress: _addressCon.text.trim(),
          customerEmail: user.email,
          customerPhone: _phoneCon.text.trim(),
          customerFirstName: user.firstName,
          customerLastName: user.lastName,
        ),
      );
    }
  }
}
