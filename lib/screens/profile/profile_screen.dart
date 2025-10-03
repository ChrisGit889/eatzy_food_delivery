import 'package:eatzy_food_delivery/screens/auth/auth_gate.dart';
import 'package:eatzy_food_delivery/screens/auth/auth_screen.dart';
import 'package:eatzy_food_delivery/screens/profile/my_info_screen.dart';
import 'package:eatzy_food_delivery/screens/seller/seller_screen.dart';
import 'package:eatzy_food_delivery/utils/utils_seller.dart';
import 'package:eatzy_food_delivery/utils/utils_user.dart';
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
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
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
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),

            Text(getUserEmail(), style: TextStyle(color: Colors.grey)),

            const SizedBox(height: 20),

            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Setting",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
            ),

            const SizedBox(height: 10),

            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                children: [
                  ProfileScreen._buildMenuItem(Icons.person, "My Info", () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => MyInfoScreen()),
                    );
                  }),
                  FutureBuilder(
                    future: getSellerStatus(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        if (snapshot.data!) {
                          return ProfileScreen._buildMenuItem(
                            Icons.store,
                            "My Store",
                            () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => SellerScreen(),
                                ),
                              );
                            },
                          );
                        }
                      }
                      return ProfileScreen._buildMenuItem(
                        Icons.store,
                        "Create a Store",
                        () {
                          makeSeller();
                          setState(() {});
                        },
                      );
                    },
                  ),
                  ProfileScreen._buildMenuItem(
                    Icons.payment,
                    "My Payment",
                    () {},
                  ),
                  ProfileScreen._buildMenuItem(
                    Icons.lock,
                    "Change Password",
                    () {},
                  ),
                  ProfileScreen._buildMenuItem(
                    Icons.support_agent,
                    "Help and Support",
                    () {},
                  ),

                  const SizedBox(height: 20),

                  OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      side: const BorderSide(color: Color(0xFFFD6C00)),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () async {
                      await signUserOut(context);
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              AuthGate(whereToGo: AuthScreen()),
                        ),
                      );
                    },
                    child: const Text(
                      "Logout",
                      style: TextStyle(color: Color(0xFFFD6C00), fontSize: 16),
                    ),
                  ),

                  const SizedBox(height: 20),
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
