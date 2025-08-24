import 'package:ecommerce_app_with_flutter/common/helpr/navigator/app_navigator.dart';
import 'package:ecommerce_app_with_flutter/common/widget/appbar/app_bar.dart';
import 'package:ecommerce_app_with_flutter/common/widget/button/basic_app_button.dart';
import 'package:ecommerce_app_with_flutter/data/auth/models/user_creation_req.dart';
import 'package:ecommerce_app_with_flutter/presentation/auth/pages/gender_and_age_selection.dart';
import 'package:ecommerce_app_with_flutter/presentation/auth/pages/signin.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final TextEditingController _firstNameCon = TextEditingController();
  final TextEditingController _lastNameCon = TextEditingController();
  final TextEditingController _emailCon = TextEditingController();
  final TextEditingController _passwordCon = TextEditingController();

  // Validation state
  String? _firstNameError;
  String? _lastNameError;
  String? _emailError;
  String? _passwordError;

  @override
  void dispose() {
    _firstNameCon.dispose();
    _lastNameCon.dispose();
    _emailCon.dispose();
    _passwordCon.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const BasicAppbar(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _siginText(),
            const SizedBox(height: 20),
            _firstNameField(),
            const SizedBox(height: 20),
            _lastNameField(),
            const SizedBox(height: 20),
            _emailField(),
            const SizedBox(height: 20),
            _passwordField(context),
            const SizedBox(height: 20),
            _continueButton(context),
            const SizedBox(height: 20),
            _createAccount(context),
          ],
        ),
      ),
    );
  }

  Widget _siginText() {
    return const Text(
      'Create Account',
      style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
    );
  }

  Widget _firstNameField() {
    return TextField(
      controller: _firstNameCon,
      onChanged: (value) => _validateFirstName(value),
      decoration: InputDecoration(
        hintText: 'Firstname',
        errorText: _firstNameError,
      ),
    );
  }

  Widget _lastNameField() {
    return TextField(
      controller: _lastNameCon,
      onChanged: (value) => _validateLastName(value),
      decoration: InputDecoration(
        hintText: 'Lastname',
        errorText: _lastNameError,
      ),
    );
  }

  Widget _emailField() {
    return TextField(
      controller: _emailCon,
      keyboardType: TextInputType.emailAddress,
      autocorrect: false,
      onChanged: (value) => _validateEmail(value),
      decoration: InputDecoration(
        hintText: 'Email Address',
        errorText: _emailError,
      ),
    );
  }

  Widget _passwordField(BuildContext context) {
    return TextField(
      controller: _passwordCon,
      obscureText: true,
      onChanged: (value) => _validatePassword(value),
      decoration: InputDecoration(
        hintText: 'Password',
        errorText: _passwordError,
      ),
    );
  }

  Widget _continueButton(BuildContext context) {
    return BasicAppButton(
      onPressed: () {
        if (_isFormValid()) {
          AppNavigator.push(
            context,
            GenderAndAgeSelectionPage(
              userCreationReq: UserCreationReq(
                firstName: _firstNameCon.text.trim(),
                email: _emailCon.text.trim(),
                lastName: _lastNameCon.text.trim(),
                password: _passwordCon.text,
              ),
            ),
          );
        }
      },
      title: 'Continue',
    );
  }

  // Real-time validation methods
  void _validateFirstName(String value) {
    setState(() {
      if (value.trim().isEmpty) {
        _firstNameError = 'First name is required';
      } else {
        _firstNameError = null;
      }
    });
  }

  void _validateLastName(String value) {
    setState(() {
      if (value.trim().isEmpty) {
        _lastNameError = 'Last name is required';
      } else {
        _lastNameError = null;
      }
    });
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

  void _validatePassword(String value) {
    setState(() {
      if (value.isEmpty) {
        _passwordError = 'Password is required';
      } else if (!_isValidPasswordFormat(value)) {
        _passwordError = 'Password must be at least 6 characters long';
      } else {
        _passwordError = null;
      }
    });
  }

  bool _isFormValid() {
    return _firstNameError == null &&
        _lastNameError == null &&
        _emailError == null &&
        _passwordError == null &&
        _firstNameCon.text.trim().isNotEmpty &&
        _lastNameCon.text.trim().isNotEmpty &&
        _emailCon.text.trim().isNotEmpty &&
        _passwordCon.text.isNotEmpty;
  }

  bool _isValidEmailFormat(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }

  bool _isValidPasswordFormat(String password) {
    return password.length >= 6;
  }

  Widget _createAccount(BuildContext context) {
    return RichText(
      text: TextSpan(
        children: [
          const TextSpan(text: "Do you have an account? "),
          TextSpan(
            text: 'Signin',
            recognizer: TapGestureRecognizer()
              ..onTap = () {
                AppNavigator.pushReplacment(context, SigninPage());
              },
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
