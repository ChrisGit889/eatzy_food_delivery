import 'package:eatzy_food_delivery/constants.dart';
import 'package:eatzy_food_delivery/screens/main_screen.dart';
import 'package:eatzy_food_delivery/screens/seller/seller_dashboard_screen.dart';
import 'package:eatzy_food_delivery/screens/seller/seller_profile_screen.dart';
import 'package:flutter/material.dart';

class SellerScreen extends StatefulWidget {
  const SellerScreen({super.key});

  @override
  State<SellerScreen> createState() => _SellerScreenState();
}

class _SellerScreenState extends State<SellerScreen> {
  int _selectedIndex = 0;
  final List<Widget> _pages = [SellerDashboard(), SellerProfile()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        selectedItemColor: EATZY_ORANGE, // Orange Eatzy
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.shifting,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.add_business_outlined),
            activeIcon: Icon(Icons.add_business_rounded),
            label: "Dashboard",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle_outlined),
            activeIcon: Icon(Icons.account_circle),
            label: "Profile",
          ),
        ],
      ),
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const MainScreen()),
            );
          },
          icon: Icon(Icons.arrow_back),
        ),
      ),
    );
  }
}
