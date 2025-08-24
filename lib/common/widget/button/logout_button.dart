import 'package:ecommerce_app_with_flutter/common/bloc/button/button_state.dart';
import 'package:ecommerce_app_with_flutter/common/bloc/button/button_state_cubit.dart';
import 'package:ecommerce_app_with_flutter/common/helpr/navigator/app_navigator.dart';
import 'package:ecommerce_app_with_flutter/domain/auth/usecases/logout.dart';
import 'package:ecommerce_app_with_flutter/presentation/auth/pages/signin.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LogoutButton extends StatelessWidget {
  final String? text;
  final IconData? icon;
  final Color? color;
  final bool showConfirmDialog;

  const LogoutButton({
    super.key,
    this.text = 'Logout',
    this.icon = Icons.logout,
    this.color = Colors.red,
    this.showConfirmDialog = true,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ButtonStateCubit(),
      child: BlocListener<ButtonStateCubit, ButtonState>(
        listener: (context, state) {
          if (state is ButtonSuccessState) {
            // Navigate to signin page and clear all previous routes
            AppNavigator.pushAndRemove(context, SigninPage());
          }
          if (state is ButtonFailureState) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.errorMessage),
                backgroundColor: Colors.red,
                behavior: SnackBarBehavior.floating,
              ),
            );
          }
        },
        child: BlocBuilder<ButtonStateCubit, ButtonState>(
          builder: (context, state) {
            return ElevatedButton.icon(
              onPressed: state is ButtonLoadingState 
                  ? null 
                  : () => _handleLogout(context),
              icon: state is ButtonLoadingState
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : Icon(icon, color: Colors.white),
              label: Text(
                text!,
                style: const TextStyle(color: Colors.white),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: color,
                foregroundColor: Colors.white,
              ),
            );
          },
        ),
      ),
    );
  }

  void _handleLogout(BuildContext context) {
    if (showConfirmDialog) {
      _showLogoutDialog(context);
    } else {
      _executeLogout(context);
    }
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Logout'),
          content: const Text('Are you sure you want to logout?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
                _executeLogout(context);
              },
              child: const Text(
                'Logout',
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );
  }

  void _executeLogout(BuildContext context) {
    context.read<ButtonStateCubit>().execute(
      usecase: LogoutUseCase(),
      params: null,
    );
  }
}
