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
  var data = <String, dynamic>{
    "email": getCurrentUser().email,
    "store": null,
    "address": null,
    "image": null,
  };
  db
      .collection('sellers')
      .doc(getCurrentUser().email)
      .set(data)
      // ignore: avoid_print
      .onError((e, _) => print("Error writing document to seller"));
  return;
}

Future makeSellerFromInfo({email, storeName, address, image}) async {
  var db = FirebaseFirestore.instance;
  var data = <String, dynamic>{
    "email": email,
    "store": storeName,
    "address": address,
    "image": image,
  };
  await db
      .collection('sellers')
      .doc(email)
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

Future<bool> makeNewSellerItem({name, desc, price, type}) async {
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
      "type": type,
      "price": double.parse(price),
      "rating": 0,
      "reviews": 0,
      "last_updated": DateTime.now(),
    };
    tempData.add(newItem);
    await currentDoc.set({"foods": tempData});
    return true;
  } catch (e) {
    print(e);
    return false;
  }
}

Future<bool> makeNewSellerItemForStore({
  String email = '',
  String name = '',
  String desc = '',
  double price = 0.0,
  String type = '',
  double rating = 0.0,
  double reviews = 0.0,
}) async {
  print(email);
  try {
    var currentDoc = FirebaseFirestore.instance
        .collection("seller-food")
        .doc(email);
    var tempData = [];
    await currentDoc.get().then((DocumentSnapshot q) {
      if (q.exists) {
        if ((q.data() as Map<String, dynamic>).containsKey("foods")) {
          tempData = (q.data() as Map<String, dynamic>)["foods"];
        }
      }
    });
    var newItem = {
      "name": name,
      "description": desc,
      "type": type,
      "price": price,
      "rating": rating,
      "reviews": reviews,
      "last_updated": DateTime.now(),
    };
    tempData.add(newItem);
    await currentDoc.set({"foods": tempData}).onError((error, stackTrace) {
      print(error);
      print(stackTrace);
    });
    return true;
  } catch (e, s) {
    print(e);
    print(s);
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

Future<Map<String, dynamic>?> getSellerDataFromName({name}) async {
  var data = await FirebaseFirestore.instance
      .collection('sellers')
      .where('store', isEqualTo: name)
      .get()
      .then((res) {
        for (var querySnapshot in res.docs) {
          return querySnapshot.data();
        }
      });
  return data;
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

Future changeFoodItemFromName({
  context,
  itemName,
  newName,
  newDesc,
  newPrice,
  newType,
  newImage,
}) async {
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
        i["type"] = newType;
        i["image"] = newImage;
        i["last_updated"] = DateTime.now();
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
