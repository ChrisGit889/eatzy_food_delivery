import 'package:flutter/material.dart';
import 'screens/login_screen.dart';
import 'screens/main_screen.dart';
import 'screens/register_screen.dart';

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
      home: const LoginScreen(), // default buka LoginScreen
      routes: {
        "/main": (context) => const MainScreen(),
        "/register": (context) => const RegisterScreen(),
      },
    );
  }
}
