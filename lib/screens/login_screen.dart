import 'package:flutter/material.dart';
import 'package:dashboard_application/core/routes/routes.dart';
import 'package:dashboard_application/utils/constant.dart';
import 'package:dashboard_application/utils/validator.dart';
import 'package:dashboard_application/services/auth_service.dart';
import 'package:dashboard_application/widgets/custom_button.dart';
import 'package:dashboard_application/widgets/custom_scaffold.dart';
import 'package:dashboard_application/widgets/custom_text_field.dart';
import 'package:dashboard_application/widgets/password_field.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _cpfController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;

  void _login() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);

      try {
        final response = await AuthService.login(
          email: _cpfController.text.trim(),
          password: _passwordController.text,
        );

        _showSnackBar(response.message, isError: false);
        Navigator.pushReplacementNamed(context, Routes.home);
      } catch (e) {
        _showSnackBar(e.toString(), isError: true);
      } finally {
        if (mounted) setState(() => _isLoading = false);
      }
    }
  }

  void _showSnackBar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: Duration(seconds: 3),
        backgroundColor: isError ? Colors.red : Colors.green.shade600,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(20),
          child: Card(
            elevation: 8,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            child: Padding(
              padding: EdgeInsets.all(30),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      AppConstants.loginTitle,
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 20),
                    CustomTextField(
                      controller: _cpfController,
                      labelText: AppConstants.emailHint,
                      validator: Validators.validateEmail,
                      enabled: !_isLoading,
                    ),
                    SizedBox(height: 20),
                    PasswordField(
                      controller: _passwordController,
                      labelText: AppConstants.passwordHint,
                      validator: Validators.validatePassword,
                      enabled: !_isLoading,
                    ),
                    SizedBox(height: 20),
                    Row(
                      children: [
                        Expanded(
                          child: CustomButton(
                            text: AppConstants.registerButton,
                            onPressed: () {
                              Navigator.pushNamed(context, Routes.register);
                            },
                            width: double.infinity,
                            backgroundColor: Colors.grey[300],
                            textColor: Colors.black,
                          ),
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: CustomButton(
                            text: _isLoading ? 'Entrando...' : AppConstants.loginButton,
                            onPressed: _login,
                            width: double.infinity,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
