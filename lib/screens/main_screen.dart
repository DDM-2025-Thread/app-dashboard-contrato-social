import 'package:dashboard_application/screens/api_key_screen.dart';
import 'package:dashboard_application/screens/dashboard_screen.dart';
import 'package:dashboard_application/screens/user_screen.dart';
import 'package:dashboard_application/screens/upload_pdf_screen.dart';
import 'package:dashboard_application/widgets/bottom_nav_bar.dart';
import 'package:dashboard_application/widgets/custom_scaffold.dart';
import 'package:flutter/material.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = const [
    DashboardScreen(),
    ApiKeyScreen(),
    UserScreen(),
    UploadPdfScreen(),
  ];

  final List<String> _titles = const [
    'Dashboard',
    'API Keys',
    'User',
    'Upload PDF',
  ];

  void _onTap(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      title: _titles[_currentIndex],
      automaticallyImplyLeading: false,
      body: _screens[_currentIndex],
      bottomNavBar: BottomNavBar(currentIndex: _currentIndex, onTap: _onTap),
    );
  }
}
