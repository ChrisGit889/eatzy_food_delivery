import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PaymentModel extends ChangeNotifier {
  String _selectedMethod = "COD";
  double _eatzyBalance = 0.0;
  bool _isLoading = true;

  String get selectedMethod => _selectedMethod;
  double get eatzyBalance => _eatzyBalance;
  bool get isLoading => _isLoading;

  Future<void> loadSavedData() async {
    _isLoading = true;
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    _selectedMethod = prefs.getString('selected_method') ?? "COD";
    _eatzyBalance = prefs.getDouble('eatzy_balance') ?? 0.0;

    _isLoading = false;
    notifyListeners();
  }

  Future<void> setSelectedMethod(String method) async {
    _selectedMethod = method;
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('selected_method', method);
  }

  Future<void> topUpBalance(double amount) async {
    if (amount <= 0) return;

    _eatzyBalance += amount;
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('eatzy_balance', _eatzyBalance);
  }

  Future<bool> deductBalance(double amount) async {
    if (amount <= 0 || _eatzyBalance < amount) {
      return false;
    }

    _eatzyBalance -= amount;
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('eatzy_balance', _eatzyBalance);

    return true;
  }

  Future<void> resetBalance() async {
    _eatzyBalance = 0.0;
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('eatzy_balance', 0.0);
  }

  bool hasInsufficientBalance(double requiredAmount) {
    return _selectedMethod == "Eatzy" && _eatzyBalance < requiredAmount;
  }
}
