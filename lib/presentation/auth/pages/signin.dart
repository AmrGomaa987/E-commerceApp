import 'package:ecommerce_app_with_flutter/common/helpr/navigator/app_navigator.dart';
import 'package:ecommerce_app_with_flutter/common/widget/button/basic_app_button.dart';
import 'package:ecommerce_app_with_flutter/data/auth/models/user_signin_req.dart';
import 'package:ecommerce_app_with_flutter/presentation/auth/pages/enter_password.dart';
import 'package:ecommerce_app_with_flutter/presentation/auth/pages/signup.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class SigninPage extends StatelessWidget {
  SigninPage({super.key});
  final TextEditingController _emailCon = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 80),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _signinText(context),
            SizedBox(height: 20),
            _emailFiled(context),
            SizedBox(height: 20),
            _continueButton(context),
            SizedBox(height: 20),
            _createAcount(context),
          ],
        ),
      ),
    );
  }

  Widget _signinText(BuildContext context) {
    return Text(
      'Sign in',
      style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
    );
  }

  Widget _emailFiled(BuildContext context) {
    return TextField(
      controller: _emailCon,
      keyboardType: TextInputType.emailAddress,
      autocorrect: false,
      decoration: InputDecoration(hintText: "Enter Email"),
    );
  }

  Widget _continueButton(BuildContext context) {
    return BasicAppButton(
      onPressed: () {
        if (_validateEmail(context)) {
          AppNavigator.push(
            context,
            EnterPasswordPage(
              signinReq: UserSigninReq(email: _emailCon.text.trim()),
            ),
          );
        }
      },
      title: "Continue",
    );
  }

  bool _validateEmail(BuildContext context) {
    final email = _emailCon.text.trim();

    if (email.isEmpty) {
      _showErrorSnackBar(context, 'Email is required');
      return false;
    }

    if (!_isValidEmail(email)) {
      _showErrorSnackBar(context, 'Please enter a valid email address');
      return false;
    }

    return true;
  }

  bool _isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }

  void _showErrorSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.red,
      ),
    );
  }

  Widget _createAcount(BuildContext context) {
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(text: "Don't have an account? "),
          TextSpan(
            text: "create one",
            recognizer: TapGestureRecognizer()
              ..onTap = () {
                AppNavigator.push(context, SignupPage());
              },
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
