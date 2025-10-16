import 'package:flutter/material.dart';
import '../services/auth_service.dart';
class AuthGuard extends StatefulWidget {
  final Widget child;
  final String redirectTo;

  const AuthGuard({
    Key? key,
    required this.child,
    this.redirectTo = '/login',
  }) : super(key: key);

  @override
  State<AuthGuard> createState() => _AuthGuardState();
}

class _AuthGuardState extends State<AuthGuard> {
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _checkAuthStatus(); 
  }
  Future<void> _checkAuthStatus() async {
    await AuthService.tryAutoLogin();
    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
    if (AuthService.isAuthenticated) {
      return widget.child;
    }
    else {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushReplacementNamed(context, widget.redirectTo);
      });
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
  }
}