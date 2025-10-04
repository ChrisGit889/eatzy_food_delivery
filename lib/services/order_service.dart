import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eatzy_food_delivery/data/models/cart_model.dart';

final FirebaseFirestore _firestore = FirebaseFirestore.instance;

Future<void> placeOrder({
  required List<CartItem> items,
  required double totalPrice,
  required String userId,
  required String restaurantName,
}) async {
  final newOrderRef = _firestore.collection('orders').doc();

<<<<<<< HEAD
    await newOrderRef.set({
      'orderId': newOrderRef.id,
      'userId': userId,
      'items': items.map((item) => item.toMap()).toList(),
      'totalPrice': totalPrice,
      'status': 'Pending',
      'createdAt': Timestamp.now(),
      'restaurantName': restaurantName,
      'deliveryFee': 0.50,
      'paymentMethod': 'Eatpay',
      'deliveryAddress': 'Untar 2, Grogol.',
      'pickupPoint': '$restaurantName, Jl. Raya Lenteng Agung No. 25',
      'note': 'Please add more sauce, thank you.',
    });
  }

  Stream<QuerySnapshot> getOrdersStream() {
    return _firestore
        .collection('orders')
        .orderBy('createdAt', descending: true)
        .snapshots();
  }

  Future<void> updateOrderStatus({
    required String orderId,
    required String newStatus,
  }) async {
    try {
      await _firestore.collection('orders').doc(orderId).update({
        'status': newStatus,
      });
    } catch (e) {
      print("Error updating order status: $e");
      rethrow;
    }
  }
}
=======
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
>>>>>>> 0595b94cea354b4db50f717730372d1387fc58bc
