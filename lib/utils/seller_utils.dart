import 'package:cloud_firestore/cloud_firestore.dart';

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
