import 'package:eatzy_food_delivery/constants.dart';
import 'package:eatzy_food_delivery/screens/seller_add_food.dart';
import 'package:flutter/material.dart';

class SellerDashboard extends StatefulWidget {
  const SellerDashboard({super.key});

  @override
  State<SellerDashboard> createState() => _SellerDashboardState();
}

class _SellerDashboardState extends State<SellerDashboard> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: ListView(
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                    top: 10.0,
                    bottom: 10.0,
                    left: 8,
                  ),
                  child: Text(
                    "Manage Restaurant",
                    style: TextStyle(
                      fontSize: 32,
                      fontFamily: "Times New Roman",
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                RestaurantButtonRow(),
                Padding(
                  padding: const EdgeInsets.only(
                    top: 10.0,
                    bottom: 10.0,
                    left: 8,
                  ),
                  child: Text(
                    "Your Items",
                    style: TextStyle(
                      fontSize: 32,
                      fontFamily: "Times New Roman",
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class RestaurantButtonRow extends StatelessWidget {
  const RestaurantButtonRow({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 8, right: 8),
      child: Row(
        children: [
          TextButton(
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const AddFood()),
              );
            },
            style: ButtonStyle(
              backgroundColor: WidgetStateProperty.resolveWith((states) {
                return EATZY_ORANGE;
              }),
            ),
            child: const Text(
              "Add Food",
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
