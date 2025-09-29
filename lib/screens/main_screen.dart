import 'package:eatzy_food_delivery/widgets/bottom_nav.dart';
import 'package:flutter/material.dart';
import 'home/home_screen.dart';
import 'order/order_screen.dart';
import 'history/history_screen.dart';
import 'favorite/favorite_screen.dart';
import 'profile/profile_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  // Daftar halaman
  final List<Widget> _pages = const [
    HomeScreen(),
    OrderScreen(),
    HistoryScreen(),
    FavoriteScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNav(
        currentIndex: _selectedIndex,
        onTap: (index) => setState(() {
          _selectedIndex = index;
        }),
      ),
    );
  }
}
