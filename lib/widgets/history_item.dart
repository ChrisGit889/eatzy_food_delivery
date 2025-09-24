import 'package:flutter/material.dart';

class HistoryItem extends StatelessWidget {
  const HistoryItem({
    super.key,
    required this.storeName,
    required this.productCount,
    required this.dateBought,
    required this.totalPrice,
  });

  final String storeName;
  final int productCount;
  final DateTime dateBought;
  final double totalPrice;

  //TODO: Prettify HistoryItem and History Logic
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.widthOf(context),
      height: 200,
      child: Padding(
        padding: const EdgeInsets.only(top: 5, bottom: 5),
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: Colors.white10,
            boxShadow: [
              BoxShadow(
                color: Colors.grey,
                blurStyle: BlurStyle.outer,
                blurRadius: 3,
              ),
            ],
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: Colors.grey,
              style: BorderStyle.solid,
              strokeAlign: BorderSide.strokeAlignCenter,
              width: 1.2,
            ),
          ),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 20, top: 10),
                child: Row(
                  children: [
                    Text(
                      storeName,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20),
                child: Row(
                  children: [
                    Text(
                      "${dateBought.year}-${dateBought.month}-${dateBought.day}",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey.shade800,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20),
                child: Row(
                  children: [
                    Text(
                      "$productCount x item",
                      style: TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20),
                child: Row(
                  children: [
                    Text(
                      "Rp ${totalPrice.toInt()}", //TODO: add conversion function from double to rupiah
                      style: TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
