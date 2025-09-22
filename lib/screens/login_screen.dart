import 'package:flutter/material.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Background image
          Image.asset("asset_images/onboarding1.jpg", fit: BoxFit.cover),

          // Overlay semi transparan biar teks lebih jelas
          Container(color: Colors.black.withOpacity(0.3)),

          // Content
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 50),

                  // Title
                  Text(
                    "Temukan hidangan lezat",
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 12),

                  // Subtitle
                  Text(
                    "Makanan favorit Anda, diantar cepat dengan Eatzy",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.9),
                      fontSize: 16,
                    ),
                  ),

                  const Spacer(),

                  // Tombol "Create new account"
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 224, 123, 7),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      padding: const EdgeInsets.symmetric(
                        vertical: 16,
                        horizontal: 50,
                      ),
                    ),
                    onPressed: () {
                      // Arahkan ke register_screen.dart
                      Navigator.pushNamed(context, "/register");
                    },
                    child: const Text(
                      "Create new account",
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ),

                  const SizedBox(height: 12),

                  // Tombol "I already have an account"
                  TextButton(
                    onPressed: () {
                      // Arahkan ke halaman login form
                      Navigator.pushNamed(context, "/login");
                    },
                    child: const Text(
                      "I already have an account",
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Social login
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _socialIcon("asset_images/apple.png"),
                      const SizedBox(width: 20),
                      _socialIcon("asset_images/google.png"),
                      const SizedBox(width: 20),
                      _socialIcon("asset_images/facebook.png"),
                    ],
                  ),

                  const SizedBox(height: 50),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _socialIcon(String assetPath) {
    return InkWell(
      onTap: () {},
      child: CircleAvatar(
        backgroundColor: Colors.white,
        radius: 24,
        child: Image.asset(assetPath, height: 24),
      ),
    );
  }
}
