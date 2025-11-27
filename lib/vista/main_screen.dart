import 'package:flutter/material.dart';
import '../widgets/bottom_nav.dart';
import 'Home_screen.dart';
import 'Notifications_screen.dart';
import 'Profile_screen.dart';
import 'camera_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  // Pantallas del BottomNav
  final List<Widget> _screens = [
    const HomeScreen(),
    CameraScreen(mealType: 'desayuno'),
    const NotificationsScreen(),
    const ProfileScreen(),
  ];

  void _onTap(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],

      bottomNavigationBar: BottomNavBar(
        currentIndex: _currentIndex,
        onTap: _onTap,
      ),
    );
  }
}
