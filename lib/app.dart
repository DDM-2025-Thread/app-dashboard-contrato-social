import 'package:dashboard_application/core/routes/routes.dart';
import 'package:dashboard_application/screens/dashboard_screen.dart';
import 'package:dashboard_application/screens/login_screen.dart';
import 'package:dashboard_application/screens/register_screen.dart';
import 'package:dashboard_application/widgets/auth_guard.dart';
import 'package:flutter/material.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gerenciamento de Estoque',
      theme: ThemeData(primarySwatch: Colors.cyan),
      debugShowCheckedModeBanner: false,
      initialRoute: Routes.login,
      routes: {
        Routes.login: (context) => const LoginScreen(),
        Routes.register: (context) => const RegisterScreen(),
        Routes.home: (context) => const AuthGuard(child: DashboardScreen()),
      },
    );
    }
  }