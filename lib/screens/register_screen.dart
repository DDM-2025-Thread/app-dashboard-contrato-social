import 'package:dashboard_application/core/routes/routes.dart';
import 'package:dashboard_application/widgets/custom_button.dart';
import 'package:dashboard_application/widgets/custom_scaffold.dart';
import 'package:dashboard_application/widgets/custom_text_field.dart';
import 'package:dashboard_application/services/auth_service.dart';
import 'package:flutter/material.dart';
import '../widgets/password_field.dart';
import '../utils/validator.dart';
import '../utils/constant.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  bool _isLoading = false;

  void _register() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);

      try {
        final response = await AuthService.register(
          name: _nameController.text.trim(),
          email: _emailController.text.trim(),
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

  String? _validateConfirmPassword(String? value) {
    return Validators.validateConfirmPassword(_passwordController.text, value);
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
                      AppConstants.registerTitle,
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 30),
                    CustomTextField(
                      controller: _nameController,
                      labelText: AppConstants.nameHint,
                      validator: Validators.validateName,
                      enabled: !_isLoading,
                    ),
                    SizedBox(height: 30),
                    CustomTextField(
                      controller: _emailController,
                      labelText: AppConstants.emailHint,
                      validator: Validators.validateEmail,
                      enabled: !_isLoading,
                    ),
                    SizedBox(height: 20),
                    PasswordField(
                      controller: _passwordController,
                      labelText: AppConstants.passwordHint,
                      helperText: AppConstants.passwordHelper,
                      validator: Validators.validatePassword,
                      enabled: !_isLoading,
                    ),
                    SizedBox(height: 20),
                    PasswordField(
                      controller: _confirmPasswordController,
                      labelText: AppConstants.confirmPasswordHint,
                      validator: _validateConfirmPassword,
                      enabled: !_isLoading,
                    ),
                    SizedBox(height: 30),
                    Row(
                      children: [
                        Expanded(
                          child: CustomButton(
                            text: AppConstants.loginButton,
                            onPressed: () {
                              Navigator.pushNamed(context, Routes.login);
                            },
                            width: double.infinity,
                            backgroundColor: Colors.grey[300],
                            textColor: Colors.black,
                          ),
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: CustomButton(
                            text: _isLoading ? 'Criando...' : AppConstants.registerButton,
                            onPressed: _register,
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

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }
}
