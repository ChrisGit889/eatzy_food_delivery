import 'package:eatzy_food_delivery/firebase_options.dart';
import 'package:eatzy_food_delivery/screens/auth_gate.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  //Init Firebase
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
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
      home: const AuthGate(), // masuk ke Login sebelum ke MainScreen
    );
  }
}
