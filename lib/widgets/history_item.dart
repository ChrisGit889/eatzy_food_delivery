import 'package:eatzy_food_delivery/constants.dart';
import 'package:eatzy_food_delivery/screens/history/history_detail_screen.dart';
import 'package:eatzy_food_delivery/utils/utils.dart';
import 'package:flutter/material.dart';

class HistoryItem extends StatelessWidget {
  const HistoryItem({
    super.key,
    required this.storeName,
    required this.productCount,
    required this.dateBought,
    required this.totalPrice,
    required this.productName,
  });

  final String storeName;
  final int productCount;
  final String productName;
  final DateTime dateBought;
  final int totalPrice;

  //TODO: Prettify HistoryItem and History Logic
  @override
  Widget build(BuildContext context) {
    bool productShorten = productName.length > 16 ? true : false;
    bool storeShorten = storeName.length > 16 ? true : false;
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const HistoryDetailScreen()),
        );
      },
      child: SizedBox(
        width: MediaQuery.widthOf(context),
        height: 100,
        child: Padding(
          padding: const EdgeInsets.only(top: 5, left: 5, right: 5, bottom: 5),
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: Colors.white10,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey,
                  blurStyle: BlurStyle.outer,
                  blurRadius: 1,
                ),
              ],
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: Colors.grey,
                style: BorderStyle.solid,
                strokeAlign: BorderSide.strokeAlignCenter,
                width: 1.2,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.only(left: 15),
              child: Row(
                children: [
                  Icon(Icons.shopping_cart_sharp),
                  SizedBox(width: 20),
                  HistoryProductInfo(
                    storeName: storeName,
                    storeShorten: storeShorten,
                    dateBought: dateBought,
                    productName: productName,
                    productShorten: productShorten,
                    productCount: productCount,
                  ),
                  HistoryProductPrice(totalPrice: totalPrice),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class HistoryProductPrice extends StatelessWidget {
  const HistoryProductPrice({super.key, required this.totalPrice});

  final int totalPrice;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.only(left: 16, right: 16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              numToRupiah(totalPrice),
              style: TextStyle(
                color: EATZY_ORANGE,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class HistoryProductInfo extends StatelessWidget {
  const HistoryProductInfo({
    super.key,
    required this.storeName,
    required this.storeShorten,
    required this.dateBought,
    required this.productName,
    required this.productShorten,
    required this.productCount,
  });

  final String storeName;
  final bool storeShorten;
  final DateTime dateBought;
  final String productName;
  final bool productShorten;
  final int productCount;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "${storeName.substring(0, storeShorten ? 16 : storeName.length)}${storeShorten ? "..." : ""}",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        Text(
          dateBought.toString(),
          style: TextStyle(
            fontSize: 12,
            color: Color.fromARGB(255, 112, 112, 112),
          ),
        ),
        Text(
          "${productName.substring(0, productShorten ? 16 : productName.length)}${productShorten ? "..." : ""} x $productCount",
          style: TextStyle(fontSize: 14),
        ),
      ],
    );
  }
}
