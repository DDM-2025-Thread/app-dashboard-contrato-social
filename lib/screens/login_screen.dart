import 'package:dashboard_application/core/routes/routes.dart';
import 'package:dashboard_application/utils/constant.dart';
import 'package:dashboard_application/utils/validator.dart';
import 'package:dashboard_application/widgets/custom_button.dart';
import 'package:dashboard_application/widgets/custom_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:dashboard_application/widgets/cpf_field.dart';
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

  void _login() {
    if (_formKey.currentState!.validate()) {
      _showSnackBar('Login realizado com sucesso!');
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), duration: Duration(seconds: 2)),
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
                      "Login",
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 20),
                    CpfField(controller: _cpfController),
                    SizedBox(height: 20),
                    PasswordField(
                      controller: _passwordController,
                      labelText: AppConstants.passwordHint,
                      validator: Validators.validatePassword,
                    ),
                    SizedBox(height: 20),
                    Row(
                      children: [
                        Expanded(
                          child: CustomButton(
                            text: "Registrar",
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
                            text: "Entrar",
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
