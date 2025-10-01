import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eatzy_food_delivery/utils/utils_user.dart';
import 'package:flutter/material.dart';

Future<List> getSellerItems(String sellerEmail) async {
  final fb = FirebaseFirestore.instance;

  return await fb.collection('seller-food').doc(sellerEmail).get().then((
    value,
  ) {
    if (value.exists) {
      return value.data()!["foods"];
    } else {
      return [];
    }
  });
}

void makeSeller() {
  var db = FirebaseFirestore.instance;
  var data = <String, dynamic>{"email": getCurrentUser().email, "store": null};
  db
      .collection('sellers')
      .doc(getCurrentUser().email)
      .set(data)
      // ignore: avoid_print
      .onError((e, _) => print("Error writing document to seller"));
  return;
}

Future<bool> getSellerStatus() {
  return FirebaseFirestore.instance
      .collection('sellers')
      .doc(getCurrentUser().email!)
      .get()
      .then((value) => value.exists);
}

Future<bool> makeNewSellerItem(name, desc, price, type) async {
  try {
    var currentDoc = FirebaseFirestore.instance
        .collection("seller-food")
        .doc(getCurrentUser().email!);
    var tempData = [];
    await currentDoc.get().then((value) {
      if (value.exists) {
        tempData = value.data()!["foods"];
      }
    });
    var newItem = {
      "name": name,
      "description": desc,
      "price": int.parse(price),
      "type": type,
    };
    tempData.add(newItem);
    await currentDoc.set({"foods": tempData});
    return true;
  } catch (e) {
    print(e);
    return false;
  }
}

Future getSellerData() {
  return FirebaseFirestore.instance
      .collection('sellers')
      .doc(getCurrentUser().email!)
      .get()
      .then((value) => value.data());
}

void setSellerStoreName(storeName) {
  FirebaseFirestore.instance
      .collection('sellers')
      .doc(getCurrentUser().email!)
      .set({"store": storeName});
}

Future getFoodItemFromName(itemName) {
  return FirebaseFirestore.instance
      .collection('seller-food')
      .doc(
        getCurrentUser().email!,
      ) //Assuming the seller is currently the signed in user
      .get()
      .then((val) {
        if (val.data() != null) {
          var data = val.data()!;
          for (var i in data['foods']) {
            if (i["name"] == itemName) {
              return i;
            }
          }
        }
        return null;
      })
      .onError((error, stackTrace) {
        print(error);
        print(stackTrace);
      });
}

Future changeFoodItemFromName(
  context,
  itemName,
  newName,
  newDesc,
  newPrice,
  type,
) async {
  try {
    var currentDoc = FirebaseFirestore.instance
        .collection("seller-food")
        .doc(getCurrentUser().email!);
    var tempData = [];
    await currentDoc.get().then((value) {
      if (value.exists) {
        tempData = value.data()!["foods"];
      }
    });
    for (var i in tempData) {
      if (i["name"] == itemName) {
        i["name"] = newName;
        i["description"] = newDesc;
        i["price"] = newPrice;
        i["type"] = type;
      }
    }
    await currentDoc.set({"foods": tempData});
    return true;
  } catch (e) {
    print(e);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Item with the same name already exists')),
      snackBarAnimationStyle: AnimationStyle(curve: ElasticInCurve()),
    );
    return false;
  }
}

Future itemExistsFromName(itemName) async {
  try {
    var currentDoc = FirebaseFirestore.instance
        .collection("seller-food")
        .doc(getCurrentUser().email!);
    var tempData = [];
    await currentDoc.get().then((value) {
      if (value.exists) {
        tempData = value.data()!["foods"];
      }
    });
    for (var i in tempData) {
      if (i["name"] == itemName) {
        throw Error();
      }
    }
    return false;
  } catch (e) {
    print(e);
    return true;
  }
}

Future deleteItemFromName(itemName) async {
  try {
    var currentDoc = FirebaseFirestore.instance
        .collection("seller-food")
        .doc(getCurrentUser().email!);
    var tempData = [];
    await currentDoc.get().then((value) {
      if (value.exists) {
        tempData = value.data()!["foods"];
      }
    });
    tempData.removeWhere((item) => item["name"] == itemName);
    await currentDoc.set({"foods": tempData});
    return false;
  } catch (e) {
    print(e);
    return true;
  }
}
