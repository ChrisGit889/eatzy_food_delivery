import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eatzy_food_delivery/constants.dart';
import 'package:eatzy_food_delivery/screens/seller_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AddFood extends StatefulWidget {
  const AddFood({super.key});

  @override
  State<AddFood> createState() => _AddFoodState();
}

class _AddFoodState extends State<AddFood> {
  TextEditingController nameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController priceController = TextEditingController();

  bool isError = false;
  String errorMessage = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const SellerScreen()),
            );
          },
          icon: Icon(Icons.arrow_back),
        ),
      ),
      body: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Input food information"),
              SizedBox(
                width: MediaQuery.widthOf(context) * 3 / 4,
                child: TextField(
                  controller: nameController,
                  decoration: InputDecoration(label: Text("Food Name")),
                ),
              ),
              SizedBox(
                width: MediaQuery.widthOf(context) * 3 / 4,
                child: TextField(
                  minLines: 1,
                  maxLines: 4,
                  controller: descriptionController,
                  decoration: InputDecoration(label: Text("Food Description")),
                ),
              ),
              SizedBox(
                width: MediaQuery.widthOf(context) * 3 / 4,
                child: TextField(
                  controller: priceController,
                  keyboardType: TextInputType.numberWithOptions(
                    decimal: true,
                    signed: false,
                  ),
                  decoration: InputDecoration(label: Text("Food Price")),
                ),
              ),
              isError
                  ? Text(errorMessage, style: TextStyle(color: Colors.red))
                  : SizedBox(),
              TextButton(
                onPressed: () async {
                  setState(() {
                    isError = false;
                    if (nameController.text.isEmpty) {
                      isError = true;
                      errorMessage = "Please input a name";
                      return;
                    }
                    if (descriptionController.text.isEmpty) {
                      isError = true;
                      errorMessage = "Please add a description";
                      return;
                    }
                    if (priceController.text.isEmpty) {
                      isError = true;
                      errorMessage = "Please input a price!";
                      return;
                    } else if (int.tryParse(priceController.text) == null) {
                      isError = true;
                      errorMessage = "Please input a valid number!";
                      return;
                    } else if (int.parse(priceController.text) < 0) {
                      isError = true;
                      errorMessage = "Please input a positive number!";
                      return;
                    }
                  });
                  if (!isError) {
                    var currentDoc = FirebaseFirestore.instance
                        .collection("seller-food")
                        .doc(FirebaseAuth.instance.currentUser!.email!);
                    var tempData = [];
                    await currentDoc.get().then((value) {
                      if (value.exists) {
                        tempData = value.data()!["foods"];
                      }
                    });
                    var newItem = {
                      "name": nameController.text,
                      "description": descriptionController.text,
                      "price": int.parse(priceController.text),
                    };
                    tempData.add(newItem);
                    await currentDoc.set({"foods": tempData});
                  }
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => SellerScreen()),
                  );
                },
                style: ButtonStyle(
                  backgroundColor: WidgetStateProperty.resolveWith((states) {
                    return EATZY_ORANGE;
                  }),
                ),
                child: const Text(
                  "Submit",
                  style: TextStyle(color: Color(0xFFFFFFFF)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
