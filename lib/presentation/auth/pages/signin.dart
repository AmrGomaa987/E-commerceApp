import 'package:ecommerce_app_with_flutter/common/helpr/navigator/app_navigator.dart';
import 'package:ecommerce_app_with_flutter/common/widget/button/basic_app_button.dart';
import 'package:ecommerce_app_with_flutter/data/auth/models/user_signin_req.dart';
import 'package:ecommerce_app_with_flutter/presentation/auth/pages/enter_password.dart';
import 'package:ecommerce_app_with_flutter/presentation/auth/pages/signup.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class SigninPage extends StatefulWidget {
  const SigninPage({super.key});

  @override
  State<SigninPage> createState() => _SigninPageState();
}

class _SigninPageState extends State<SigninPage> {
  final TextEditingController _emailCon = TextEditingController();
  String? _emailError;

  @override
  void dispose() {
    _emailCon.dispose();
    super.dispose();
  }

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
      onChanged: (value) => _validateEmail(value),
      decoration: InputDecoration(
        hintText: "Enter Email",
        errorText: _emailError,
      ),
    );
  }

  Widget _continueButton(BuildContext context) {
    return BasicAppButton(
      onPressed: () {
        if (_isFormValid()) {
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

  void _validateEmail(String value) {
    setState(() {
      if (value.trim().isEmpty) {
        _emailError = 'Email is required';
      } else if (!_isValidEmailFormat(value.trim())) {
        _emailError = 'Please enter a valid email address';
      } else {
        _emailError = null;
      }
    });
  }

  bool _isFormValid() {
    return _emailError == null && _emailCon.text.trim().isNotEmpty;
  }

  bool _isValidEmailFormat(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
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
