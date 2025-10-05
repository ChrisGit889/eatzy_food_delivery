import 'package:eatzy_food_delivery/screens/auth/auth_gate.dart';
import 'package:eatzy_food_delivery/screens/auth/auth_screen.dart';
import 'package:eatzy_food_delivery/screens/profile/my_info_screen.dart';
import 'package:eatzy_food_delivery/screens/profile/change_password_screen.dart';
import 'package:eatzy_food_delivery/screens/profile/payment_screen.dart';
import 'package:eatzy_food_delivery/screens/profile/about_us_screen.dart';
import 'package:eatzy_food_delivery/screens/profile/help_support_screen.dart';
import 'package:eatzy_food_delivery/screens/seller/seller_screen.dart';
import 'package:eatzy_food_delivery/services/seller_service.dart';
import 'package:eatzy_food_delivery/services/user_service.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();

  static Widget _buildMenuItem(
    IconData icon,
    String title,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(icon, color: Colors.black54),
            const SizedBox(width: 12),
            Expanded(child: Text(title, style: const TextStyle(fontSize: 16))),
            const Icon(Icons.arrow_forward_ios, size: 18, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        top: false,
        child: Column(
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                ClipPath(
                  clipper: TopHalfCircleClipper(),
                  child: Container(
                    height: 150,
                    width: double.infinity,
                    color: const Color(0xFFFD6C00),
                    alignment: Alignment.center,
                    child: Image.asset(
                      "assets/images/diprofilebackground.png",
                      height: 150,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                const Positioned(
                  bottom: -50,
                  left: 0,
                  right: 0,
                  child: CircleAvatar(
                    radius: 50,
                    backgroundImage: AssetImage(
                      "assets/images/buatisiprofile.jpg",
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 60),

            Text(
              getUserName(),
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Text(getUserEmail(), style: const TextStyle(color: Colors.grey)),

            const SizedBox(height: 20),

            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Settings",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
            ),

            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                children: [
                  ProfileScreen._buildMenuItem(Icons.person, "My Info", () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const MyInfoScreen(),
                      ),
                    );
                  }),

                  ProfileScreen._buildMenuItem(
                    Icons.lock,
                    "Change Password",
                    () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ChangePasswordScreen(),
                        ),
                      );
                    },
                  ),

                  FutureBuilder<bool>(
                    future: getSellerStatus(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const SizedBox(height: 0);
                      }
                      if (snapshot.hasData && snapshot.data == true) {
                        return ProfileScreen._buildMenuItem(
                          Icons.store,
                          "My Store",
                          () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const SellerScreen(),
                              ),
                            );
                          },
                        );
                      }
                      return ProfileScreen._buildMenuItem(
                        Icons.storefront,
                        "Create a Store",
                        () async {
                          makeSeller();
                          setState(() {});
                        },
                      );
                    },
                  ),

                  ProfileScreen._buildMenuItem(
                    Icons.payment,
                    "Payment Method",
                    () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const PaymentScreen(),
                        ),
                      );
                    },
                  ),

                  ProfileScreen._buildMenuItem(
                    Icons.info_outline,
                    "About Us",
                    () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const AboutUsScreen(),
                        ),
                      );
                    },
                  ),

                  ProfileScreen._buildMenuItem(
                    Icons.support_agent,
                    "Help & Support",
                    () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const HelpSupportScreen(),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 30),

                  OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      side: const BorderSide(color: Color(0xFFFD6C00)),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () async {
                      await signUserOut();
                      if (!mounted) return;
                      Navigator.of(
                        context,
                        rootNavigator: true,
                      ).pushReplacement(
                        MaterialPageRoute(
                          builder: (context) =>
                              AuthGate(whereToGo: const AuthScreen()),
                        ),
                      );
                    },
                    child: const Text(
                      "Logout",
                      style: TextStyle(color: Color(0xFFFD6C00), fontSize: 16),
                    ),
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TopHalfCircleClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.addOval(
      Rect.fromLTWH(
        -size.width * 0.25,
        -size.height,
        size.width * 1.5,
        size.height * 2,
      ),
    );
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}
