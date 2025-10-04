import 'package:eatzy_food_delivery/constants.dart';
import 'package:eatzy_food_delivery/utils/utils.dart';
import 'package:eatzy_food_delivery/services/seller_service.dart';
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

  String dropDownValue = "other";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back),
        ),
      ),
      body: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Column(
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
                        "Creating a new food item",
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
                      value: "drink",
                      child: Text("Drinks"),
                    ),
                  ],
                ),
              ),
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

              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextButton(
                  onPressed: () async {
                    isError = false;
                    await errorCheckInput();
                    setState(() {});
                    if (!isError) {
                      var res = await makeNewSellerItem(
                        name: nameController.text,
                        desc: descriptionController.text,
                        price: priceController.text,
                        type: dropDownValue,
                      );
                      if (res) {
                        Navigator.pop(context);
                      }
                    }
                    return;
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
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> errorCheckInput() async {
    if (await itemExistsFromName(nameController.text)) {
      isError = true;
      errorMessage = "Use a unique name!";
    }
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
    } else if (double.tryParse(priceController.text) == null) {
      print(priceController.text);
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
