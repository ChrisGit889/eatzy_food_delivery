import 'package:eatzy_food_delivery/utils/snackbar_helper.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:eatzy_food_delivery/constants.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:eatzy_food_delivery/services/location_service.dart';
import 'package:geocoding/geocoding.dart';

class ChangeAddressView extends StatefulWidget {
  const ChangeAddressView({super.key});

  @override
  State<ChangeAddressView> createState() => _ChangeAddressViewState();
}

class _ChangeAddressViewState extends State<ChangeAddressView> {
  GoogleMapController? _mapController;
  final LocationService _locationService = LocationService();

  double? _currentLat;
  double? _currentLng;
  String _currentAddress = "Looking for location...";
  bool _isLoading = true;
  bool _isUpdatingAddress = false;

  static const _defaultLocation = LatLng(-6.2088, 106.8456);
  CameraPosition _initialPosition = const CameraPosition(
    target: _defaultLocation,
    zoom: 15,
  );

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  @override
  void dispose() {
    _mapController?.dispose();
    _mapController = null;
    super.dispose();
  }

  Future<void> _getCurrentLocation() async {
    if (!mounted) return;

    setState(() {
      _isLoading = true;
      _currentAddress = "Getting your location...";
    });

    try {
      await _locationService.getCurrentLocation();

      if (!_locationService.hasLocation()) {
        throw Exception('Failed to get location coordinates');
      }

      final lat = _locationService.lat!;
      final lng = _locationService.lng!;

      if (!mounted) return;

      setState(() {
        _currentLat = lat;
        _currentLng = lng;
        _initialPosition = CameraPosition(target: LatLng(lat, lng), zoom: 16);
      });

      await _getAddressFromLatLng(lat, lng);

      if (_mapController != null && mounted) {
        await _mapController!.animateCamera(
          CameraUpdate.newCameraPosition(_initialPosition),
        );
      }

      if (mounted) {
        setState(() => _isLoading = false);
      }
    } catch (e) {
      debugPrint("Location Error: $e");
      if (!mounted) return;

      setState(() {
        _isLoading = false;
        _currentAddress = "Unable to access location";
      });

      String errorMsg = _getUserError(e.toString());

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(errorMsg),
            duration: const Duration(seconds: 4),
            action: SnackBarAction(
              label: 'Retry',
              onPressed: _getCurrentLocation,
            ),
          ),
        );
      }
    }
  }

  String _getUserError(String error) {
    if (error.contains('disabled')) {
      return 'Please enable GPS in your device settings';
    } else if (error.contains('denied')) {
      return 'Location permission denied. Please enable in app settings';
    } else if (error.contains('permanently')) {
      return 'Location permanently denied. Enable in Settings > Apps';
    }
    return 'Unable to get location. Please try again';
  }

  Future<void> _getAddressFromLatLng(double lat, double lng) async {
    if (_isUpdatingAddress) return;
    _isUpdatingAddress = true;

    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(lat, lng);

      if (placemarks.isNotEmpty && mounted) {
        Placemark place = placemarks[0];

        final parts = [
          place.street,
          place.subLocality,
          place.locality,
          place.postalCode,
          place.country,
        ].where((part) => part != null && part.isNotEmpty).join(', ');

        if (mounted) {
          setState(() {
            _currentAddress = parts.isNotEmpty
                ? parts
                : "Lat: ${lat.toStringAsFixed(6)}, Lng: ${lng.toStringAsFixed(6)}";
          });
        }
      }
    } catch (e) {
      print(e);
      if (mounted) {
        setState(() {
          _currentAddress =
              "Lat: ${lat.toStringAsFixed(6)}, Lng: ${lng.toStringAsFixed(6)}";
        });
      }
    } finally {
      _isUpdatingAddress = false;
    }
  }

  void _onCameraMove(CameraPosition position) {
    _currentLat = position.target.latitude;
    _currentLng = position.target.longitude;
  }

  Future<void> _onCameraIdle() async {
    if (_mapController == null || !mounted) return;
    if (_currentLat == null || _currentLng == null) return;

    await _getAddressFromLatLng(_currentLat!, _currentLng!);
  }

  Future<void> _searchAddress(String address) async {
    if (address.trim().isEmpty) return;

    try {
      List<Location> locations = await locationFromAddress(address);

      if (locations.isNotEmpty && mounted) {
        final location = locations.first;

        setState(() {
          _currentLat = location.latitude;
          _currentLng = location.longitude;
        });

        await _mapController?.animateCamera(
          CameraUpdate.newLatLngZoom(
            LatLng(location.latitude, location.longitude),
            16,
          ),
        );

        await _getAddressFromLatLng(location.latitude, location.longitude);
      }
    } catch (e) {
      debugPrint("Search Error: $e");
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Address not found. Try different keywords'),
            duration: Duration(seconds: 2),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Change Address',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        actions: [
          IconButton(
            icon: const Icon(Icons.my_location, color: Colors.red),
            onPressed: _isLoading ? null : _getCurrentLocation,
            tooltip: 'My Location',
          ),
        ],
      ),
      body: _isLoading
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(color: Colors.red),
                  SizedBox(height: 16),
                  Text('Getting your location...'),
                ],
              ),
            )
          : Stack(
              children: [
                GoogleMap(
                  mapType: MapType.normal,
                  initialCameraPosition: _initialPosition,
                  myLocationEnabled: true,
                  myLocationButtonEnabled: false,
                  compassEnabled: false,
                  zoomControlsEnabled: false,
                  mapToolbarEnabled: false,
                  gestureRecognizers: <Factory<OneSequenceGestureRecognizer>>{
                    Factory<PanGestureRecognizer>(() => PanGestureRecognizer()),
                  },
                  onMapCreated: (GoogleMapController controller) async {
                    if (_mapController == null) {
                      _mapController = controller;

                      if (_currentLat != null && _currentLng != null) {
                        await controller.animateCamera(
                          CameraUpdate.newCameraPosition(_initialPosition),
                        );
                      }
                    }
                  },
                  onCameraMove: _onCameraMove,
                  onCameraIdle: _onCameraIdle,
                ),

                Positioned.fill(
                  child: Center(
                    child: Image.asset(
                      'assets/images/map_pin.png',
                      width: 40,
                      height: 40,
                    ),
                  ),
                ),

                // Current Address Display 
                Positioned(
                  top: 16,
                  left: 16,
                  right: 16,
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withAlpha(26),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.location_on,
                          color: Colors.red,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            _currentAddress,
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Bottom Card
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withAlpha(26),
                          blurRadius: 10,
                          offset: const Offset(0, -2),
                        ),
                      ],
                    ),
                    child: SafeArea(
                      top: false,
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // Search Field
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.grey[100],
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: TextField(
                                decoration: InputDecoration(
                                  hintText: "Search address",
                                  hintStyle: TextStyle(color: Colors.grey[400]),
                                  border: InputBorder.none,
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 14,
                                  ),
                                  prefixIcon: const Icon(
                                    Icons.search,
                                    color: Colors.red,
                                  ),
                                ),
                                onSubmitted: _searchAddress,
                              ),
                            ),

                            const SizedBox(height: 16),

                            // Saved Places Button
                            InkWell(
                              onTap: () {
                                // TODO: Navigate to saved places
                              },
                              borderRadius: BorderRadius.circular(12),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 12,
                                ),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Colors.grey[300]!,
                                    width: 1,
                                  ),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.bookmark_outline,
                                      color: primaryText,
                                      size: 20,
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Text(
                                        "Choose a saved place",
                                        style: TextStyle(
                                          color: primaryText,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                    Icon(
                                      Icons.chevron_right,
                                      color: primaryText,
                                      size: 20,
                                    ),
                                  ],
                                ),
                              ),
                            ),

                            const SizedBox(height: 16),

                            // Confirm Button
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed:
                                    _currentLat == null || _currentLng == null
                                    ? null
                                    : () {
                                        Navigator.pop(context, {
                                          'address': _currentAddress,
                                          'latitude': _currentLat,
                                          'longitude': _currentLng,
                                        });
                                      },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.red,
                                  disabledBackgroundColor: Colors.grey[300],
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 16,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  elevation: 0,
                                ),
                                child: const Text(
                                  'Confirm Location',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
