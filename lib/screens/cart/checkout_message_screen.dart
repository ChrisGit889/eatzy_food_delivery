import 'package:eatzy_food_delivery/constants.dart';
import 'package:flutter/material.dart';
import 'package:eatzy_food_delivery/screens/main_screen.dart';

class CheckoutMessageScreen extends StatefulWidget {
  const CheckoutMessageScreen({super.key});

  @override
  State<CheckoutMessageScreen> createState() => _CheckoutMessageScreenState();
}

class _CheckoutMessageScreenState extends State<CheckoutMessageScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 25),
      width: MediaQuery.sizeOf(context).width,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(15),
          topRight: Radius.circular(15),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.end,
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(vertical: 15),
            child: Image.asset(
              "assets/images/thank_you.png",
              width: MediaQuery.sizeOf(context).width * 0.4,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            "Thank You!",
            style: TextStyle(
              color: primaryText,
              fontSize: 26,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            "For Ordering",
            style: TextStyle(
              color: primaryText,
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 25),
          Text(
            "Your Order is now being processed. We will let you know once the order is picked from the outlet. Check the status of your Order",
            textAlign: TextAlign.center,
            style: TextStyle(color: primaryText, fontSize: 14),
          ),
          const SizedBox(height: 35),
          InkWell(
            onTap: () {
              Navigator.pop(context);
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (context) => const MainScreen(initialIndex: 1),
                ),
                (route) => false,
              );
            },
            child: Container(
              height: 56,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                border: Border.all(color: EATZY_ORANGE, width: 1),
                color: EATZY_ORANGE,
                borderRadius: BorderRadius.circular(28),
              ),
              child: Text(
                "Check my Order",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const MainScreen()),
                (route) => false,
              );
            },
            child: Text(
              "Back To Home",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: primaryText,
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}
