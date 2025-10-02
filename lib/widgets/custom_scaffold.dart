import 'package:flutter/material.dart';

class CustomScaffold extends StatelessWidget {
  final Widget body;
  final String title;
  final Widget? floatingActionButton;
  final bool hasDrawer;
  final PreferredSizeWidget? bottom;

  CustomScaffold({
    required this.body,
    this.title = "Dashboard API ",
    this.floatingActionButton,
    this.hasDrawer = true,
    this.bottom,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        backgroundColor: Colors.blue.shade700,
        centerTitle: true,
        bottom: bottom,   
      ),
      body: body,
      floatingActionButton: floatingActionButton,
    );
  }
}