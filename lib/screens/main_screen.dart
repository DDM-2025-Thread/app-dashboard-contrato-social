import 'package:dashboard_application/models/user_model.dart';
import 'package:dashboard_application/screens/admin_screen.dart';
import 'package:dashboard_application/screens/api_key_screen.dart';
import 'package:dashboard_application/screens/dashboard_screen.dart';
import 'package:dashboard_application/screens/user_screen.dart';
import 'package:dashboard_application/widgets/bottom_nav_bar.dart';
import 'package:dashboard_application/widgets/custom_scaffold.dart';
import 'package:flutter/material.dart';
import '../services/auth_service.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  List<Widget> _screens = [];
  List<BottomNavigationBarItem> _navItems = [];
  List<String> _titles = [];

  @override
  void initState() {
    super.initState();
    _setupMenu();
  }

  void _setupMenu() {
    _screens = [
      const DashboardScreen(),
      const ApiKeyScreen(),
      const UserScreen(),
    ];

    _titles = ['Dashboard', 'API Keys', 'User'];

    _navItems = [
      const BottomNavigationBarItem(
        icon: Icon(Icons.dashboard),
        label: 'Dashboard',
      ),
      const BottomNavigationBarItem(icon: Icon(Icons.key), label: 'API Keys'),
      const BottomNavigationBarItem(icon: Icon(Icons.person), label: 'User'),
    ];

    final UserModel? user = AuthService.currentUser;
    if (user != null && (user.role == 'admin' || user.role == 'super_admin')) {
      _screens.add(const AdminScreen());
      _titles.add('Admin');
      _navItems.add(
        const BottomNavigationBarItem(
          icon: Icon(Icons.admin_panel_settings),
          label: 'Admin',
        ),
      );
    }
  }

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
      bottomNavBar: BottomNavBar(
        currentIndex: _currentIndex,
        onTap: _onTap,
        items: _navItems,
      ),
    );
  }
}
