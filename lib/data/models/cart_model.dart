import 'package:flutter/foundation.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class CartItem {
  final String name;
  final String image;
  final double price;
  int quantity;

  CartItem({
    required this.name,
    required this.image,
    required this.price,
    required this.quantity,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'image': image,
      'price': price,
      'quantity': quantity,
    };
  }

  factory CartItem.fromMap(Map<String, dynamic> map) {
    return CartItem(
      name: map['name'] ?? '',
      image: map['image'] ?? '',
      price: (map['price'] as num).toDouble(),
      quantity: (map['quantity'] as num).toInt(),
    );
  }
}

class CartModel extends ChangeNotifier {
  final List<CartItem> _items = [];

  List<CartItem> get items => List.unmodifiable(_items);

  double get totalPrice =>
      _items.fold(0, (sum, item) => sum + item.price * item.quantity);

  int get totalQuantity =>
      _items.fold(0, (sum, item) => sum + item.quantity);

  void addItem(CartItem item) {
    int index = _items.indexWhere((element) => element.name == item.name);
    if (index != -1) {
      _items[index].quantity += item.quantity;
    } else {
      _items.add(item);
    }
    saveCartToPrefs();
    notifyListeners();
  }

  void removeItem(String name) {
    _items.removeWhere((item) => item.name == name);
    saveCartToPrefs();
    notifyListeners();
  }

  void clearCart() {
    _items.clear();
    saveCartToPrefs();
    notifyListeners();
  }

  void updateQuantity(String name, int newQuantity) {
    int index = _items.indexWhere((item) => item.name == name);
    if (index != -1) {
      if (newQuantity <= 0) {
        removeItem(name);
      } else {
        _items[index].quantity = newQuantity;
        saveCartToPrefs();
        notifyListeners();
      }
    }
  }

  Future<void> saveCartToPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    List<String> cartItems =
        _items.map((item) => jsonEncode(item.toMap())).toList();
    await prefs.setStringList('cart_items', cartItems);
  }

  Future<void> loadCartFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    List<String>? cartItems = prefs.getStringList('cart_items');
    if (cartItems != null) {
      _items.clear();
      _items.addAll(
          cartItems.map((item) => CartItem.fromMap(jsonDecode(item))));
      notifyListeners();
    }
  }

  bool get isEmpty => _items.isEmpty;
}