import 'package:eatzy_food_delivery/constants.dart';
import 'package:eatzy_food_delivery/utils/utils_seller.dart';
import 'package:flutter/material.dart';

class SellerEditFood extends StatefulWidget {
  const SellerEditFood({super.key, required this.foodIdentifier});
  final String foodIdentifier;

  @override
  State<SellerEditFood> createState() => _SellerEditFoodState();
}

class _SellerEditFoodState extends State<SellerEditFood> {
  TextEditingController nameController = TextEditingController();
  TextEditingController descController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  bool isError = false;
  String errorMessage = '';
  @override
  Widget build(BuildContext context) {
    var itemData = getFoodItemFromName(widget.foodIdentifier);
    return Scaffold(
      appBar: AppBar(backgroundColor: Color(0x00000000)),
      extendBodyBehindAppBar: true,
      body: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FutureBuilder(
                future: itemData,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    var data = snapshot.data!;
                    if (!isError) {
                      nameController.text = data["name"];
                      descController.text = data["description"];
                      priceController.text = data["price"].toString();
                    }
                    return Column(
                      children: [
                        Text("Input food information"),
                        SizedBox(
                          width: MediaQuery.widthOf(context) * 3 / 4,
                          child: TextField(
                            controller: nameController,
                            decoration: InputDecoration(
                              label: Text("Food Name"),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: MediaQuery.widthOf(context) * 3 / 4,
                          child: TextField(
                            minLines: 1,
                            maxLines: 4,
                            controller: descController,
                            decoration: InputDecoration(
                              label: Text("Food Description"),
                            ),
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
                            decoration: InputDecoration(
                              label: Text("Food Price"),
                            ),
                          ),
                        ),
                        isError
                            ? Text(
                                errorMessage,
                                style: TextStyle(color: Colors.red),
                              )
                            : SizedBox(),
                        TextButton(
                          onPressed: () async {
                            isError = false;
                            await errorCheckInput();
                            setState(() {});
                            if (!isError) {
                              var res = await changeFoodItemFromName(
                                context,
                                widget.foodIdentifier,
                                nameController.text,
                                descController.text,
                                priceController.text,
                              );
                              if (res) {
                                Navigator.pop(context);
                              }
                            }
                            return;
                          },
                          style: ButtonStyle(
                            backgroundColor: WidgetStateProperty.resolveWith((
                              states,
                            ) {
                              return EATZY_ORANGE;
                            }),
                          ),
                          child: const Text(
                            "Submit",
                            style: TextStyle(color: Color(0xFFFFFFFF)),
                          ),
                        ),
                      ],
                    );
                  }
                  return CircularProgressIndicator();
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> errorCheckInput() async {
    if (await itemExistsFromName(nameController.text) &&
        nameController.text != widget.foodIdentifier) {
      isError = true;
      errorMessage = "Use a unique name!";
    }
    if (nameController.text.isEmpty) {
      isError = true;
      errorMessage = "Please input a name";
      return;
    }
    if (descController.text.isEmpty) {
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
  }
}
