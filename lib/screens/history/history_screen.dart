import 'package:eatzy_food_delivery/widgets/history_item.dart';
import 'package:flutter/material.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Scaffold(
          appBar: AppBar(centerTitle: true, title: Text("History")),
          body: Column(
            children: [
              Expanded(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemBuilder: (context, index) => HistoryItem(
                    dateBought: DateTime.now(),
                    productCount: 2,
                    storeName: "Idontcare",
                    totalPrice: 99999999,
                    productName: "PlaceHolderFood Long name",
                  ),
                  itemCount: 10,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
