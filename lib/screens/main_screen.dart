import 'package:eatzy_food_delivery/constants.dart';
import 'package:eatzy_food_delivery/widgets/bottom_nav.dart';
import 'package:flutter/material.dart';
import 'home/home_screen.dart';
import 'order/order_screen.dart';
import 'history/history_screen.dart';
import 'favorite/favorite_screen.dart';
import 'profile/profile_screen.dart';

class MainScreen extends StatefulWidget {
  final int initialIndex;
  const MainScreen({super.key, this.initialIndex = 0});

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
  void initState() {
    super.initState();
    _selectedIndex = widget.initialIndex;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: CustomBottomNav(
        currentIndex: _selectedIndex,
        onTap: (index) => setState(() {
          _selectedIndex = index;
        }),
      ),
    );
  }
}