import 'package:ecommerce_app_with_flutter/common/bloc/button/button_state.dart';
import 'package:ecommerce_app_with_flutter/common/bloc/button/button_state_cubit.dart';
import 'package:ecommerce_app_with_flutter/common/helpr/navigator/app_navigator.dart';
import 'package:ecommerce_app_with_flutter/common/widget/appbar/app_bar.dart';
import 'package:ecommerce_app_with_flutter/common/widget/button/basic_reactive_button.dart';
import 'package:ecommerce_app_with_flutter/domain/auth/usecases/send_password_reset_email.dart';
import 'package:ecommerce_app_with_flutter/presentation/auth/pages/password_reset_email.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ForgotPasswordPage extends StatelessWidget {
  ForgotPasswordPage({super.key});
  final TextEditingController _emailCon = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BasicAppbar(),
      body: BlocProvider(
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
              AppNavigator.push(context, PasswordResetEmailPage());
            }
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _signinText(context),
                SizedBox(height: 20),
                _emailFiled(context),
                SizedBox(height: 20),
                _continueButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _signinText(BuildContext context) {
    return Text(
      'Forgot Password',
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

  Widget _continueButton() {
    return Builder(
      builder: (context) {
        return BasicReactiveButton(
          onPressed: () {
            if (_validateEmail(context)) {
              context.read<ButtonStateCubit>().execute(
                usecase: SendpasswordResetEmailUseCase(),
                params: _emailCon.text.trim(),
              );
            }
          },
          title: "Continue",
        );
      },
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
}
