import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eatzy_food_delivery/data/models/cart_model.dart';

class OrderService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> placeOrder({
    required List<CartItem> items,
    required double totalPrice,
    required String userId,
    required String restaurantName,
  }) async {
    final newOrderRef = _firestore.collection('orders').doc();

    await newOrderRef.set({
      'orderId': newOrderRef.id,
      'userId': userId,
      'items': items
          .map((item) => item.toMap())
          .toList(), // Mengubah list of CartItem menjadi List of Map
      'totalPrice': totalPrice,
      'status': 'Pending',
      'createdAt': Timestamp.now(),
      'restaurantName': restaurantName,
    });
  }

  Stream<QuerySnapshot> getOrdersStream() {
    return _firestore
        .collection('orders')
        .orderBy('createdAt', descending: true)
        .snapshots();
  }
}
