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
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                CpfField(controller: _cpfController),
                const SizedBox(height: 16.0),
                PasswordField(
                  controller: _passwordController,
                  labelText: 'Senha',
                  helperText: 'A senha deve ter exatamente 8 caracteres.',
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, insira sua senha.';
                    } else if (value.length != 8) {
                      return 'A senha deve ter exatamente 8 caracteres.';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24.0),
                ElevatedButton(onPressed: _login, child: const Text('Entrar')),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
