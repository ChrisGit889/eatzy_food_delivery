import 'package:eatzy_food_delivery/widgets/history_item.dart';
import 'package:flutter/material.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Scaffold(
          body: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              children: [
                Text("History"),
                Expanded(
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemBuilder: (context, index) => HistoryItem(
                      dateBought: DateTime.now(),
                      productCount: 2,
                      storeName: "Idontcare",
                      totalPrice: 100000,
                    ),
                    itemCount: 10,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
