import 'package:flutter/material.dart';

class CustomScaffold extends StatelessWidget {
  final Widget body;
  final String title;
  final Widget? floatingActionButton;
  final bool hasDrawer;
  final PreferredSizeWidget? bottom;
  final Widget? bottomNavBar;
  final bool automaticallyImplyLeading;

  CustomScaffold({
    required this.body,
    this.title = "Dashboard API ",
    this.floatingActionButton,
    this.hasDrawer = true,
    this.bottom,
    this.bottomNavBar,
    this.automaticallyImplyLeading = true,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title, style: TextStyle(color: Colors.white),),
        backgroundColor: Colors.black,
        centerTitle: true,
        bottom: bottom, 
        iconTheme: IconThemeData(color: Colors.white),
        automaticallyImplyLeading: automaticallyImplyLeading,
      ),
      body: body,
      bottomNavigationBar: bottomNavBar,
      floatingActionButton: floatingActionButton,
    );
  }
}