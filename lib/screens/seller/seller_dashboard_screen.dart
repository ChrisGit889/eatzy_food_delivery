import 'package:eatzy_food_delivery/constants.dart';
import 'package:eatzy_food_delivery/screens/seller/seller_add_food.dart';
import 'package:eatzy_food_delivery/utils/utils_seller.dart';
import 'package:eatzy_food_delivery/widgets/seller_item.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
          FutureBuilder(
            future: getSellerItems(FirebaseAuth.instance.currentUser!.email!),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                List<Widget> currList = [];
                for (var i in snapshot.data!) {
                  currList.add(
                    SellerItem(
                      name: i["name"],
                      desc: i["description"],
                      price: int.tryParse(i["price"].toString())!,
                    ),
                  );
                }
                return Expanded(
                  child: ListView(shrinkWrap: true, children: currList),
                );
              }
              return CircularProgressIndicator();
            },
          ),
          RestaurantButtonRow(),
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
      padding: const EdgeInsets.all(8),
      child: Row(
        children: [
          Expanded(
            child: TextButton(
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
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
