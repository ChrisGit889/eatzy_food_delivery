import 'package:flutter/material.dart';
import 'screens/main_screen.dart';

void main() {
  runApp(const EatzyApp());
}

class EatzyApp extends StatelessWidget {
  const EatzyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Eatzy',
      theme: ThemeData(
        brightness: Brightness.light,
        scaffoldBackgroundColor: Colors.white,
        primaryColor: const Color(0xFFFD6C00),
      ),
      home: const MainScreen(), // masuk ke MainScreen setelah login
    );
  }
}
