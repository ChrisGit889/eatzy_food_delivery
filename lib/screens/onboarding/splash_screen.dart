import 'package:eatzy_food_delivery/constants.dart';
import 'package:flutter/material.dart';
import '../auth/login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final List<String> texts = [
    "Lapar? Eatzy hadirkan makanan favoritmu, secepat kilat!",
    "Nikmati hidangan lezat tanpa ribet!",
    "Mulai petualangan rasa sekarang!",
  ];
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Logo Eatzy
              Icon(Icons.fastfood, color: EATZY_ORANGE, size: 100),
              const SizedBox(height: 30),

              // Teks utama (langsung tampil, ga ganti2 otomatis lagi)
              Text(
                texts[currentIndex],
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 18,
                  color: Color.fromARGB(221, 196, 19, 19),
                  fontWeight: FontWeight.w500,
                ),
              ),

              const SizedBox(height: 50),

              // Tombol lanjut ke Login
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: EATZY_ORANGE,
                  minimumSize: const Size(double.infinity, 50),
                ),
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (_) => const LoginScreen()),
                  );
                },
                child: const Text("Mulai"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
