import 'package:eatzy_food_delivery/constants.dart';
import 'package:eatzy_food_delivery/firebase_options.dart';
import 'package:eatzy_food_delivery/screens/auth_gate.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'screens/onboarding_screen.dart';
import 'package:provider/provider.dart';
import 'data/models/cart_model.dart';

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
    return ChangeNotifierProvider(
      create: (context) {
        CartModel cartModel = CartModel();
        cartModel.loadCartFromPrefs();
        return cartModel;
      },
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Eatzy',
        theme: ThemeData(
          brightness: Brightness.light,
          scaffoldBackgroundColor: Colors.white,
          primaryColor: EATZY_ORANGE,
        ),
        home: const OnboardingScreen(),
      ),
    );
  }
}
