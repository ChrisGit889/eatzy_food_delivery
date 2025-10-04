import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddressModel extends ChangeNotifier {
  String _address = '123 Main Street. Bekasi';
  double? _latitude;
  double? _longitude;

  String get address => _address;
  double? get latitude => _latitude;
  double? get longitude => _longitude;

  // Load address
  Future<void> loadAddress() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      _address = prefs.getString('saved_address') ?? '123 Main Street. Bekasi';
      _latitude = prefs.getDouble('saved_latitude');
      _longitude = prefs.getDouble('saved_longitude');
      notifyListeners();
    } catch (e) {
      debugPrint('Error loading address: $e');
    }
  }

  // Update address
  Future<void> updateAddress({
    required String address,
    required double latitude,
    required double longitude,
  }) async {
    _address = address;
    _latitude = latitude;
    _longitude = longitude;

    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('saved_address', address);
      await prefs.setDouble('saved_latitude', latitude);
      await prefs.setDouble('saved_longitude', longitude);
    } catch (e) {
      debugPrint('Error saving address: $e');
    }

    notifyListeners();
  }
}