import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:eatzy_food_delivery/constants.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:custom_map_markers/custom_map_markers.dart';
import 'package:eatzy_food_delivery/services/location_service.dart';
import 'package:geolocator/geolocator.dart';
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

  late List<MarkerData> _customMarkers;

  // Default location on Jakarta
  CameraPosition _initialPosition = const CameraPosition(
    target: LatLng(-6.2088, 106.8456),
    zoom: 15,
  );

  @override
  void initState() {
    super.initState();
    _customMarkers = [];
    _getCurrentLocation();
  }

  @override
  void dispose() {
    _mapController?.dispose();
    super.dispose();
  }

  Future<void> _getCurrentLocation() async {
    setState(() => _isLoading = true);

    try {
      // Call service untuk get current location
      await _locationService.getCurrentLocation();

      // Ambil lat lng dari service dengan null check
      final lat = _locationService.lat;
      final lng = _locationService.lng;

      // Validasi bahwa lat dan lng tidak null
      if (lat == null || lng == null) {
        throw Exception('Failed to get location coordinates');
      }

      if (mounted) {
        setState(() {
          _currentLat = lat;
          _currentLng = lng;
          _initialPosition = CameraPosition(target: LatLng(lat, lng), zoom: 15);
        });

        // Update marker
        _updateMarker(lat, lng);

        // Get address
        await _getAddressFromLatLng(lat, lng);

        // Animate camera
        _mapController?.animateCamera(
          CameraUpdate.newCameraPosition(_initialPosition),
        );

        setState(() => _isLoading = false);
      }
    } catch (e) {
      // Handle error
      if (mounted) {
        setState(() {
          _isLoading = false;
          _currentAddress = "Tidak dapat mengakses lokasi";
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            duration: const Duration(seconds: 3),
            action: SnackBarAction(
              label: 'Coba Lagi',
              onPressed: _getCurrentLocation,
            ),
          ),
        );
      }
    }
  }

  // Get address from coordinates
  Future<void> _getAddressFromLatLng(double lat, double lng) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(lat, lng);

      if (placemarks.isNotEmpty && mounted) {
        Placemark place = placemarks[0];
        setState(() {
          _currentAddress =
              "${place.street}, ${place.subLocality}, ${place.locality}, ${place.postalCode}, ${place.country}";
        });
      }
    } catch (e) {
      debugPrint("Error getting address: $e");
      if (mounted) {
        setState(() {
          _currentAddress = "Lat: $lat, Lng: $lng";
        });
      }
    }
  }

  // Update marker posisi
  void _updateMarker(double lat, double lng) {
    setState(() {
      _customMarkers = [
        MarkerData(
          marker: Marker(
            markerId: const MarkerId('current-location'),
            position: LatLng(lat, lng),
          ),
          child: _customMarker('Current', Colors.red),
        ),
      ];
    });
  }

  // Handle ketika map di-drag
  void _onCameraMove(CameraPosition position) {
    final center = position.target;
    _updateMarker(center.latitude, center.longitude);
  }

  // Handle ketika selesai drag
  Future<void> _onCameraIdle() async {
    if (_mapController != null) {
      final center = await _mapController!.getVisibleRegion();
      final centerLat =
          (center.northeast.latitude + center.southwest.latitude) / 2;
      final centerLng =
          (center.northeast.longitude + center.southwest.longitude) / 2;

      // Update current position
      setState(() {
        _currentLat = centerLat;
        _currentLng = centerLng;
      });

      // Get address untuk posisi baru
      await _getAddressFromLatLng(centerLat, centerLng);
    }
  }

  // Search address
  Future<void> _searchAddress(String address) async {
    if (address.trim().isEmpty) return;

    try {
      List<Location> locations = await locationFromAddress(address);
      if (locations.isNotEmpty) {
        final location = locations.first;

        // Update position
        setState(() {
          _currentLat = location.latitude;
          _currentLng = location.longitude;
        });

        // Animate camera
        _mapController?.animateCamera(
          CameraUpdate.newLatLngZoom(
            LatLng(location.latitude, location.longitude),
            15,
          ),
        );

        // Get formatted address
        await _getAddressFromLatLng(location.latitude, location.longitude);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Alamat tidak ditemukan: $e')));
      }
    }
  }

  Widget _customMarker(String symbol, Color color) {
    return SizedBox(
      width: 50,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(
            'assets/images/map_pin.png',
            width: 40,
            fit: BoxFit.contain,
          ),
        ],
      ),
    );
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
          // Button untuk kembali ke lokasi saat ini
          IconButton(
            icon: const Icon(Icons.my_location, color: Colors.red),
            onPressed: _getCurrentLocation,
            tooltip: 'Lokasi saya',
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
                  Text('Mendapatkan lokasi Anda...'),
                ],
              ),
            )
          : Stack(
              children: [
                // Google Map
                CustomGoogleMapMarkerBuilder(
                  customMarkers: _customMarkers,
                  builder: (BuildContext context, Set<Marker>? markers) {
                    if (markers == null) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    return GoogleMap(
                      mapType: MapType.normal,
                      initialCameraPosition: _initialPosition,
                      myLocationEnabled: true,
                      myLocationButtonEnabled: false,
                      compassEnabled: false,
                      zoomControlsEnabled: false,
                      gestureRecognizers: Set()
                        ..add(
                          Factory<PanGestureRecognizer>(
                            () => PanGestureRecognizer(),
                          ),
                        ),
                      markers: markers,
                      onMapCreated: (GoogleMapController controller) {
                        _mapController = controller;
                      },
                      onCameraMove: _onCameraMove,
                      onCameraIdle: _onCameraIdle,
                    );
                  },
                ),

                // Current Address Indicator (atas)
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
                          color: Colors.black.withOpacity(0.1),
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
                          color: Colors.black.withOpacity(0.1),
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
                                // Navigate ke saved places screen
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
                                        // Return selected location
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
