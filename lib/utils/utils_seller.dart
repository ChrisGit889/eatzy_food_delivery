import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eatzy_food_delivery/utils/utils_user.dart';

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

Future<bool> makeNewSellerItem(name, desc, price) async {
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
