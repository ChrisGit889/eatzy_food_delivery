import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CartModel extends ChangeNotifier {
  final List<Map<String, dynamic>> _items = [];

  List<Map<String, dynamic>> get items => List.unmodifiable(_items);

  double get totalPrice =>
      _items.fold(0, (sum, item) => sum + item['price'] * item['quantity']);

  double get totalQuantity =>
      _items.fold(0, (sum, item) => sum + item['quantity']);

  void addItem(Map<String, dynamic> item) {
    int index = _items.indexWhere((element) => element['id'] == item['id']);
    if (index != -1) {
      _items[index]['quantity'] += item['quantity'];
    } else {
      _items.add(item);
    }
    saveCartToPrefs();
    notifyListeners();
  }

  void removeItem(String id) {
    _items.removeWhere((item) => item['id'] == id);
    saveCartToPrefs();
    notifyListeners();
  }

  void clearCart() {
    _items.clear();
    saveCartToPrefs();
    notifyListeners();
  }

  void updateQuantity(String id, int quantity) {
    int index = _items.indexWhere((item) => item['id'] == id);
    if (index != -1) {
      _items[index]['quantity'] = quantity;
      if (_items[index]['quantity'] <= 0) {
        removeItem(id);
      } else {
        saveCartToPrefs();
        notifyListeners();
      }
    }
  }

  Future<void> saveCartToPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    List<String> cartItems = _items.map((item) => item.toString()).toList();
    await prefs.setStringList('cart_items', cartItems);
  }

  Future<void> loadCartFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    List<String>? cartItems = prefs.getStringList('cart_items');
    if (cartItems != null) {
      _items.clear();
      for (var item in cartItems) {
        Map<String, dynamic> parsedItem = {};
        item.substring(1, item.length - 1).split(', ').forEach((pair) {
          var keyValue = pair.split(': ');
          parsedItem[keyValue[0]] = keyValue[1];
        });
        parsedItem['price'] = double.parse(parsedItem['price'].toString());
        parsedItem['quantity'] = int.parse(parsedItem['quantity'].toString());
        _items.add(parsedItem);
      }
      notifyListeners();
    }
  }

  bool get isEmpty => _items.isEmpty;
}
