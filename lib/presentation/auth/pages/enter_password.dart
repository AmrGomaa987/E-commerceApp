import 'package:ecommerce_app_with_flutter/common/bloc/button/button_state.dart';
import 'package:ecommerce_app_with_flutter/common/bloc/button/button_state_cubit.dart';
import 'package:ecommerce_app_with_flutter/common/helpr/navigator/app_navigator.dart';
import 'package:ecommerce_app_with_flutter/common/widget/appbar/app_bar.dart';
import 'package:ecommerce_app_with_flutter/common/widget/button/basic_reactive_button.dart';
import 'package:ecommerce_app_with_flutter/data/auth/models/user_signin_req.dart';
import 'package:ecommerce_app_with_flutter/domain/auth/usecases/signin.dart';
import 'package:ecommerce_app_with_flutter/presentation/auth/pages/forgot_password.dart';
import 'package:ecommerce_app_with_flutter/presentation/home/pages/home.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EnterPasswordPage extends StatefulWidget {
  final UserSigninReq signinReq;
  const EnterPasswordPage({super.key, required this.signinReq});

  @override
  State<EnterPasswordPage> createState() => _EnterPasswordPageState();
}

class _EnterPasswordPageState extends State<EnterPasswordPage> {
  final TextEditingController _passwordCon = TextEditingController();
  String? _passwordError;

  @override
  void dispose() {
    _passwordCon.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BasicAppbar(),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: BlocProvider(
          create: (context) => ButtonStateCubit(),
          child: BlocListener<ButtonStateCubit, ButtonState>(
            listener: (context, state) {
              if (state is ButtonFailureState) {
                var snackbar = SnackBar(
                  content: Text(state.errorMessage),
                  behavior: SnackBarBehavior.floating,
                );
                ScaffoldMessenger.of(context).showSnackBar(snackbar);
              }
              if (state is ButtonSuccessState) {
                AppNavigator.pushAndRemove(context, HomePage());
              }
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _signinText(context),
                SizedBox(height: 20),
                _passwordFiled(context),
                SizedBox(height: 20),
                _continueButton(context),
                SizedBox(height: 20),
                _forgotPassword(context),
              ],
            ),
          ),
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

  Widget _passwordFiled(BuildContext context) {
    return TextField(
      controller: _passwordCon,
      obscureText: true,
      onChanged: (value) => _validatePassword(value),
      decoration: InputDecoration(
        hintText: "Enter Password",
        errorText: _passwordError,
      ),
    );
  }

  Widget _continueButton(BuildContext context) {
    return Builder(
      builder: (context) {
        return BasicReactiveButton(
          onPressed: () {
            if (_isFormValid()) {
              widget.signinReq.password = _passwordCon.text;
              context.read<ButtonStateCubit>().execute(
                usecase: SigninUseCase(),
                params: widget.signinReq,
              );
            }
          },
          title: "Continue",
        );
      },
    );
  }

  void _validatePassword(String value) {
    setState(() {
      if (value.isEmpty) {
        _passwordError = 'Password is required';
      } else {
        _passwordError = null;
      }
    });
  }

  bool _isFormValid() {
    return _passwordError == null && _passwordCon.text.isNotEmpty;
  }

  Widget _forgotPassword(BuildContext context) {
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(text: "Forgot Password? "),
          TextSpan(
            text: "Reset",
            recognizer: TapGestureRecognizer()
              ..onTap = () {
                AppNavigator.push(context, ForgotPasswordPage());
              },
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
