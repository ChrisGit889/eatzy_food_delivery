import 'package:eatzy_food_delivery/services/seller_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SellerProfile extends StatefulWidget {
  const SellerProfile({super.key});

  @override
  State<SellerProfile> createState() => _SellerProfileState();
}

class _SellerProfileState extends State<SellerProfile> {
  TextEditingController textController = TextEditingController();
  bool editing = false;
  bool alert = false;

  @override
  Widget build(BuildContext context) {
    var dbData = getSellerData();

    return SafeArea(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 80,
                backgroundImage: AssetImage("assets/images/buatisiprofile.jpg"),
              ),
              Row(
                children: [
                  FutureBuilder(
                    future: dbData,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        if (editing) {
                          return SizedBox(
                            width: 100,
                            height: 100,
                            child: TextField(
                              controller: textController,
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                              maxLength: 20,
                            ),
                          );
                        }
                        return snapshot.data!["store"] == null
                            ? Text(
                                "Unnamed Seller",
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              )
                            : Text(
                                snapshot.data!["store"],
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              );
                      } else {
                        return CircularProgressIndicator();
                      }
                    },
                  ),
                  IconButton(
                    onPressed: () async {
                      alert = false;
                      if (editing) {
                        if (textController.text.isNotEmpty) {
                          await setSellerStoreName(textController.text);
                          editing = false;
                        } else {
                          alert = true;
                        }
                      } else {
                        editing = true;
                      }
                      setState(() {});
                    },
                    icon: Icon(Icons.mode_edit_outlined),
                  ),
                ],
              ),
              alert
                  ? Text("Type in a valid store name!")
                  : SizedBox(width: 0, height: 0),
            ],
          ),
        ],
      ),
    );
  }
}

class SellerNameSpot extends StatelessWidget {
  const SellerNameSpot({super.key, required this.currentUser});

  final User currentUser;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getSellerData(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return snapshot.data!["store"] == null
              ? Text("No name")
              : Text(snapshot.data!["store"]);
        } else {
          return CircularProgressIndicator();
        }
      },
    );
  }
}
