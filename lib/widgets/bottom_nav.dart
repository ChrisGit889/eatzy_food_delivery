import 'package:flutter/material.dart';
import 'package:eatzy_food_delivery/constants.dart';

// Model sederhana untuk menyimpan data setiap item nav bar
class NavItem {
  final IconData icon;
  final String label;

  const NavItem({required this.icon, required this.label});
}

class CustomBottomNav extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const CustomBottomNav({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  // Daftar item navigasi Anda
  static const List<NavItem> _navItems = [
    NavItem(icon: Icons.home, label: "Home"),
    NavItem(icon: Icons.receipt_long, label: "Order"),
    NavItem(icon: Icons.favorite, label: "Favorite"),
    NavItem(icon: Icons.person, label: "Profile"),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      // Dekorasi untuk background dan shadow
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            spreadRadius: 2,
          ),
        ],
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: _navItems.asMap().entries.map((entry) {
              int index = entry.key;
              NavItem item = entry.value;
              bool isSelected = index == currentIndex;

              // Membangun setiap item
              return _buildNavItem(item, isSelected, index);
            }).toList(),
          ),
        ),
      ),
    );
  }

  // Widget helper untuk membuat setiap item nav bar
  Widget _buildNavItem(NavItem item, bool isSelected, int index) {
    return GestureDetector(
      onTap: () => onTap(index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? EATZY_ORANGE : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(item.icon, color: isSelected ? Colors.white : secondaryText),
            // Tampilkan teks hanya jika item terpilih
            if (isSelected) const SizedBox(width: 8),
            if (isSelected)
              Text(
                item.label,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
