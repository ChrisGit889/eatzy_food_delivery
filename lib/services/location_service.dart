import 'package:geolocator/geolocator.dart';

class LocationService {
  double? lat;
  double? lng;

  Future<void> getCurrentLocation() async {
    bool isServiceEnabled;
    LocationPermission permission;

    // Check if location services enabled
    isServiceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!isServiceEnabled) {
      throw Exception('Location services are disabled!');
    }

    // Check permission
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw Exception('Location permissions are denied');
      }
    }
    if (permission == LocationPermission.deniedForever) {
      throw Exception('Location permissions are permanently denied.');
    }

    // Permission are already granted
    Position currentPosition = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
    lat = currentPosition.latitude;
    lng = currentPosition.longitude;
  }

  bool hasLocation() {
    return lat != null && lng != null;
  }
}