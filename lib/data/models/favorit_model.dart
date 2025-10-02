import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FavoriteModel extends ChangeNotifier {
  final List<Map<String, dynamic>> _favorites = [];

  List<Map<String, dynamic>> get favorites => _favorites;

  Future<void> loadFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    List<String>? favItems = prefs.getStringList('favorites');

    if (favItems != null) {
      _favorites.clear();

      for (var item in favItems) {
        Map<String, dynamic> parsedItem = {};

        for (var pair in item.split('||')) {
          var keyValue = pair.split('##');
          if (keyValue.length == 2) {
            parsedItem[keyValue[0]] = keyValue[1];
          }
        }

        if (parsedItem.containsKey('price')) {
          parsedItem['price'] =
              double.tryParse(parsedItem['price'].toString()) ?? 0.0;
        }

        _favorites.add(parsedItem);
      }

      notifyListeners();
    }
  }

  Future<void> toggleFav(Map<String, dynamic> food) async {
    final prefs = await SharedPreferences.getInstance();
    final exists = _favorites.any((f) => f['name'] == food['name']);

    if (exists) {
      _favorites.removeWhere((f) => f['name'] == food['name']);
    } else {
      _favorites.add(food);
    }

    List<String> saveList = _favorites.map((f) {
      return "name##${f['name']}||restaurant##${f['restaurant']}||description##${f['description']}||price##${f['price']}||type##${f['type'] ?? ''}";
    }).toList();

    await prefs.setStringList("favorites", saveList);
    notifyListeners();
  }

  Future<void> clearFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    _favorites.clear();
    await prefs.remove("favorites");
    notifyListeners();
  }

  bool isFavorite(String name) {
    return _favorites.any((f) => f['name'] == name);
  }
}
