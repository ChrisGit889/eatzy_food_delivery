import 'package:eatzy_food_delivery/constants.dart';
import 'package:eatzy_food_delivery/data/models/favorit_model.dart';
import 'package:eatzy_food_delivery/data/models/address_model.dart';
import 'package:eatzy_food_delivery/screens/onboarding/onboarding_screen.dart';
import 'package:eatzy_food_delivery/services/firebase_options.dart';
import 'package:eatzy_food_delivery/screens/auth/auth_gate.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'data/models/cart_model.dart';

void main() async {
  //Init Firebase
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const EatzyApp());
}

//widget for the whole app
class EatzyApp extends StatelessWidget {
  const EatzyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) {
            CartModel cartModel = CartModel();
            cartModel.loadCartFromPrefs();
            return cartModel;
          },
        ),
        ChangeNotifierProvider(
          create: (context) {
            FavoriteModel favModel = FavoriteModel();
            favModel.loadFavorites();
            return favModel;
          },
        ),
        ChangeNotifierProvider(
          create: (context) { 
            AddressModel addressModel = AddressModel();
            addressModel.loadAddress();
            return addressModel;

        }),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Eatzy',
        theme: ThemeData(
          brightness: Brightness.light,
          scaffoldBackgroundColor: Colors.white,
          primaryColor: EATZY_ORANGE,
        ),
        home: AuthGate(whereToGo: OnboardingScreen()),
      ),
    );
  }
}
