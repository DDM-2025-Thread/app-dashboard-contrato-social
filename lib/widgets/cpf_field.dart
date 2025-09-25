import 'package:flutter/material.dart';
import '../utils/masks.dart';
import '../utils/validators.dart';

class CpfField extends StatelessWidget {
  final TextEditingController controller;
  final void Function(String)? onChanged;

  const CpfField({
    Key? key,
    required this.controller,
    this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomTextField(
      controller: controller,
      labelText: 'Digite seu CPF',
      prefixIcon: Icon(Icons.person),
      keyboardType: TextInputType.number,
      inputFormatters: [Masks.cpfMask],
      validator: Validators.validateCPF,
      onChanged: onChanged,
    );
  }
}