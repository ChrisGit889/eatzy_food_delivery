import 'package:eatzy_food_delivery/constants.dart';
import 'package:eatzy_food_delivery/utils/utils.dart';
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
  bool load = true;
  String errorMessage = '';
  String dropDownValue = 'other';
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
                    if (load) {
                      dropDownValue = data["type"];
                      load = false;
                    }
                    return Column(
                      children: [
                        SizedBox(
                          height: 350,
                          width: MediaQuery.widthOf(context),
                          child: DecoratedBox(
                            decoration: BoxDecoration(color: EATZY_ORANGE),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                imageOfCategory(dropDownValue, 200.0, 200.0),
                                Text(
                                  "Editing food item",
                                  style: TextStyle(
                                    fontSize: 32,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Text(
                                    "Input food information",
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: 20),
                        SizedBox(
                          width: MediaQuery.widthOf(context) * 1 / 4,
                          child: DropdownButton(
                            value: dropDownValue,
                            onChanged: (value) {
                              setState(() {
                                dropDownValue = value!;
                                print(dropDownValue);
                              });
                            },
                            items: [
                              DropdownMenuItem<String>(
                                value: "pizza",
                                child: Text("Pizza"),
                              ),
                              DropdownMenuItem<String>(
                                value: "burger",
                                child: Text("Burger"),
                              ),
                              DropdownMenuItem<String>(
                                value: "snacks",
                                child: Text("Snacks"),
                              ),
                              DropdownMenuItem<String>(
                                value: "other",
                                child: Text("Others"),
                              ),
                              DropdownMenuItem<String>(
                                value: "drinks",
                                child: Text("Drinks"),
                              ),
                            ],
                          ),
                        ),
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
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextButton(
                            onPressed: () async {
                              isError = false;
                              await errorCheckInput();
                              if (!isError) {
                                var res = await changeFoodItemFromName(
                                  context: context,
                                  itemName: widget.foodIdentifier,
                                  newName: nameController.text,
                                  newDesc: descController.text,
                                  newPrice: priceController.text,
                                  newType: dropDownValue,
                                  newImage: null,
                                );
                                if (res) {
                                  Navigator.pop(context);
                                }
                              }
                              setState(() {});
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
    } else if (double.tryParse(priceController.text) == null) {
      isError = true;
      errorMessage = "Please input a valid number!";
      return;
    } else if (double.parse(priceController.text) < 0) {
      isError = true;
      errorMessage = "Please input a positive number!";
      return;
    }
  }
}
