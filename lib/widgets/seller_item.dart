import 'package:eatzy_food_delivery/constants.dart';
import 'package:eatzy_food_delivery/screens/seller/seller_delete_food.dart';
import 'package:eatzy_food_delivery/screens/seller/seller_edit_food.dart';
import 'package:eatzy_food_delivery/utils/utils.dart';
import 'package:flutter/material.dart';

class SellerItem extends StatelessWidget {
  const SellerItem({
    super.key,
    required this.price,
    required this.name,
    required this.desc,
  });
  final int price;
  final String name;
  final String desc;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: SizedBox(
          width: MediaQuery.widthOf(context),
          height: 200,
          child: DecoratedBox(
            decoration: BoxDecoration(
              border: BoxBorder.all(
                color: Colors.black,
                width: 1,
                style: BorderStyle.solid,
              ),
              color: Color(0xFFFFFFFF),
              boxShadow: [
                BoxShadow(
                  blurRadius: 5,
                  color: Colors.black12,
                  blurStyle: BlurStyle.normal,
                  spreadRadius: 5,
                  offset: Offset(1, 1),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.only(left: 8.0, right: 8.0),
              child: SellerItemContent(name: name, price: price, desc: desc),
            ),
          ),
        ),
      ),
    );
  }
}

class SellerItemContent extends StatelessWidget {
  const SellerItemContent({
    super.key,
    required this.name,
    required this.price,
    required this.desc,
  });

  final String name;
  final int price;
  final String desc;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          width: 200,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 150,
                width: 150,
                child: DecoratedBox(
                  decoration: BoxDecoration(),
                  child: Image.asset(
                    "assets/images/Water.png",
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Text(
                numToRupiah(price),
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 50,
                  child: Text(
                    name,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(
                  height: 90,
                  child: Text(desc, style: TextStyle(fontSize: 16)),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    IconButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                SellerDeleteFood(foodIdentifier: name),
                          ),
                        );
                      },
                      icon: Icon(
                        Icons.delete_forever_outlined,
                        color: EATZY_ORANGE,
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                SellerEditFood(foodIdentifier: name),
                          ),
                        );
                      },
                      icon: Icon(Icons.edit_square, color: EATZY_ORANGE),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
