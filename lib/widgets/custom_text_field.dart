import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;
  final String? helperText;
  final bool obscureText;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;
  final List<dynamic>? inputFormatters;
  final int? maxLength;
  final bool? enabled;
  final void Function(String)? onChanged;

  const CustomTextField({
    Key? key,
    required this.controller,
    required this.labelText,
    this.helperText,
    this.obscureText = false,
    this.prefixIcon,
    this.suffixIcon,
    this.validator,
    this.keyboardType,
    this.inputFormatters,
    this.maxLength,
    this.enabled,
    this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      validator: validator,
      keyboardType: keyboardType,
      inputFormatters: inputFormatters != null ? List.from(inputFormatters!) : null,
      maxLength: maxLength,
      onChanged: onChanged,
      enabled: enabled,
      decoration: InputDecoration(
        labelText: labelText,
        helperText: helperText,
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
        border: OutlineInputBorder(),
        contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      ),
    );
  }
}