import 'package:flutter/material.dart';
import 'custom_text_field.dart';

class PasswordField extends StatefulWidget {
  final TextEditingController controller;
  final String labelText;
  final String? helperText;
  final bool? enabled;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;

  const PasswordField({
    Key? key,
    required this.controller,
    required this.labelText,    
    this.helperText,
    this.enabled,
    this.validator,
    this.onChanged,
  }) : super(key: key);

  @override
  _PasswordFieldState createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<PasswordField> {
  bool _obscureText = true;

  void _toggleObscureText() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    return CustomTextField(
      controller: widget.controller,
      labelText: widget.labelText,
      helperText: widget.helperText,
      obscureText: _obscureText,
      prefixIcon: Icon(Icons.lock),
      suffixIcon: IconButton(
        icon: Icon(_obscureText ? Icons.visibility : Icons.visibility_off),
        onPressed: _toggleObscureText,
      ),
      validator: widget.validator,
      maxLength: 8,
      onChanged: widget.onChanged,
      enabled: widget.enabled,
    );
  }
}