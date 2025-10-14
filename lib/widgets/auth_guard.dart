import 'package:flutter/material.dart';
import '../services/auth_service.dart';

class AuthGuard extends StatelessWidget {
  final Widget child;
  final String redirectTo;

  const AuthGuard({
    Key? key,
    required this.child,
    this.redirectTo = '/login',
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (AuthService.isAuthenticated) {
      return child;
    } else {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushReplacementNamed(context, redirectTo);
      });
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
  }
}