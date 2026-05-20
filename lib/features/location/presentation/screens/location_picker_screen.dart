import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';
import 'package:izu/core/services/location_service.dart';

class LocationPickerScreen extends StatefulWidget {
  const LocationPickerScreen({super.key});

  @override
  State<LocationPickerScreen> createState() => _LocationPickerScreenState();
}

class _LocationPickerScreenState extends State<LocationPickerScreen> {
  late final MapController _mapController;
  final TextEditingController _searchController = TextEditingController();
  LatLng _mapCenter = const LatLng(40.7128, -74.0060); // Default to NYC
  LatLng? _selectedLatLng;
  String? _resolvedAddress;
  bool _isLoading = true;
  bool _isResolvingAddress = false;
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    _mapController = MapController();
    _initLocation();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _mapController.dispose();
    super.dispose();
  }

  Future<void> _initLocation() async {
    try {
      final currentPos = await LocationService().getCurrentPosition();
      if (currentPos != null) {
        _mapCenter = LatLng(currentPos.latitude, currentPos.longitude);
        _selectedLatLng = _mapCenter;
        _resolveAddress(_mapCenter);
      } else {
        _selectedLatLng = _mapCenter;
        _resolveAddress(_mapCenter);
      }
    } catch (e) {
      _selectedLatLng = _mapCenter;
      _resolveAddress(_mapCenter);
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _resolveAddress(LatLng point) async {
    setState(() {
      _isResolvingAddress = true;
    });

    try {
      final dio = Dio();
      final response = await dio.get(
        'https://nominatim.openstreetmap.org/reverse',
        queryParameters: {
          'format': 'json',
          'lat': point.latitude,
          'lon': point.longitude,
          'zoom': 18,
          'addressdetails': 1,
        },
        options: Options(
          headers: {
            'User-Agent': 'izu_app/1.0.0',
          },
        ),
      );

      if (response.statusCode == 200 && response.data != null) {
        final displayName = response.data['display_name'] as String?;
        if (displayName != null) {
          setState(() {
            _resolvedAddress = displayName;
            _isResolvingAddress = false;
          });
          return;
        }
      }
    } catch (e) {
      debugPrint('Error reverse geocoding: $e');
    }

    setState(() {
      _resolvedAddress = 'Selected Coordinates (${point.latitude.toStringAsFixed(4)}, ${point.longitude.toStringAsFixed(4)})';
      _isResolvingAddress = false;
    });
  }

  Future<void> _searchLocation(String query) async {
    if (query.trim().isEmpty) return;

    setState(() {
      _isSearching = true;
    });

    try {
      final dio = Dio();
      final response = await dio.get(
        'https://nominatim.openstreetmap.org/search',
        queryParameters: {
          'q': query,
          'format': 'json',
          'limit': 5,
        },
        options: Options(
          headers: {
            'User-Agent': 'izu_app/1.0.0',
          },
        ),
      );

      if (response.statusCode == 200 && response.data != null) {
        final List<dynamic> results = response.data;
        if (results.isNotEmpty) {
          final first = results.first;
          final lat = double.parse(first['lat']);
          final lon = double.parse(first['lon']);
          final resolvedPoint = LatLng(lat, lon);
          final displayName = first['display_name'] as String?;

          setState(() {
            _selectedLatLng = resolvedPoint;
            _resolvedAddress = displayName ?? 'Selected Location';
            _mapCenter = resolvedPoint;
          });

          _mapController.move(resolvedPoint, 15.0);
        } else {
          Get.snackbar(
            'No results',
            'No locations found for "$query".',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.black.withOpacity(0.8),
            colorText: Colors.white,
          );
        }
      }
    } catch (e) {
      debugPrint('Error searching location: $e');
      Get.snackbar(
        'Search Error',
        'Could not search for location.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withOpacity(0.8),
        colorText: Colors.white,
      );
    } finally {
      setState(() {
        _isSearching = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black87, size: 20),
          onPressed: () => Get.back(),
        ),
        title: const Text(
          'Select Delivery Location',
          style: TextStyle(
            color: Colors.black87,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: false,
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF2870BC)),
              ),
            )
          : Stack(
              children: [
                FlutterMap(
                  mapController: _mapController,
                  options: MapOptions(
                    initialCenter: _mapCenter,
                    initialZoom: 15.0,
                    onTap: (tapPosition, point) {
                      setState(() {
                        _selectedLatLng = point;
                      });
                      _resolveAddress(point);
                    },
                  ),
                  children: [
                    TileLayer(
                      urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                      userAgentPackageName: 'com.example.izu',
                    ),
                    if (_selectedLatLng != null)
                      MarkerLayer(
                        markers: [
                          Marker(
                            point: _selectedLatLng!,
                            width: 50,
                            height: 50,
                            child: const Icon(
                              Icons.location_on,
                              color: Color(0xFF2870BC),
                              size: 40,
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
                // Search Bar overlay
                Positioned(
                  top: 16,
                  left: 16,
                  right: 16,
                  child: Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Row(
                        children: [
                          const Icon(Icons.search, color: Colors.grey),
                          const SizedBox(width: 8),
                          Expanded(
                            child: TextField(
                              controller: _searchController,
                              decoration: const InputDecoration(
                                hintText: 'Search address or place...',
                                border: InputBorder.none,
                                hintStyle: TextStyle(color: Colors.grey, fontSize: 14),
                              ),
                              textInputAction: TextInputAction.search,
                              onSubmitted: (value) => _searchLocation(value),
                            ),
                          ),
                          if (_isSearching)
                            const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF2870BC)),
                                ),
                              ),
                            )
                          else if (_searchController.text.isNotEmpty)
                            IconButton(
                              icon: const Icon(Icons.clear, color: Colors.grey, size: 18),
                              onPressed: () {
                                setState(() {
                                  _searchController.clear();
                                });
                              },
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
                // Overlay for Instructions and Select Button
                Positioned(
                  bottom: 24,
                  left: 24,
                  right: 24,
                  child: Card(
                    color: Colors.white,
                    elevation: 8,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Delivery Location',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: Colors.grey,
                            ),
                          ),
                          const SizedBox(height: 6),
                          _isResolvingAddress
                              ? const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF2870BC)),
                                  ),
                                )
                              : Text(
                                  _resolvedAddress ?? 'Tap on map to select...',
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black87,
                                  ),
                                ),
                          const SizedBox(height: 16),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: _selectedLatLng != null && !_isResolvingAddress
                                  ? () {
                                      Get.back(result: {
                                        'address': _resolvedAddress,
                                        'latitude': _selectedLatLng!.latitude,
                                        'longitude': _selectedLatLng!.longitude,
                                      });
                                    }
                                  : null,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF2870BC),
                                padding: const EdgeInsets.symmetric(vertical: 14),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(28),
                                ),
                              ),
                              child: const Text(
                                'Confirm Location',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
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
              ],
            ),
    );
  }
}
