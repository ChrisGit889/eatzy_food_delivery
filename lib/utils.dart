import 'package:cloud_firestore/cloud_firestore.dart';

String numToRupiah(int number) {
  var temp = number.toString();
  for (var i = 3; i < temp.length; i += 4) {
    temp =
        "${temp.substring(0, temp.length - i)}.${temp.substring(temp.length - i, temp.length)}";
  }
  return "Rp.$temp,00";
}

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
