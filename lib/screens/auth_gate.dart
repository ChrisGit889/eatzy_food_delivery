import 'package:eatzy_food_delivery/screens/login_screen.dart';
import 'package:eatzy_food_delivery/screens/main_screen.dart';
import 'package:firebase_auth/firebase_auth.dart' hide EmailAuthProvider;
import 'package:flutter/material.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return LoginScreen();
        }
        return const MainScreen();
      },
    );
  }
}
