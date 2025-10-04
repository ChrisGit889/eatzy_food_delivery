import 'package:eatzy_food_delivery/services/seller_service.dart';
import 'package:flutter/material.dart';

class SellerDeleteFood extends StatelessWidget {
  const SellerDeleteFood({super.key, required this.foodIdentifier});
  final String foodIdentifier;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Color(0x00000000)),
      extendBodyBehindAppBar: true,
      body: Scaffold(
        body: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Are you sure?"),
                  TextButton(
                    onPressed: () async {
                      await deleteItemFromName(foodIdentifier);
                      if (context.mounted) {
                        Navigator.pop(context);
                      }
                    },
                    child: Text("Yes"),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text("No"),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
