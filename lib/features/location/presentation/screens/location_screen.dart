import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';
import 'package:izu/core/network/api_client.dart';
import 'package:izu/core/services/location_service.dart';
import 'package:izu/features/location/data/model/location_model.dart';

class LocationScreen extends StatefulWidget {
  final String? bookingId;
  final LocationData? locationData;

  const LocationScreen({
    super.key,
    this.bookingId,
    this.locationData,
  });

  @override
  State<LocationScreen> createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  late final MapController _mapController;
  bool _isLoading = true;
  String? _errorMessage;
  LatLng? _currentLatLng;
  LatLng? _bookingLatLng;
  String? _bookingAddress;
  String? _clientName;

  @override
  void initState() {
    super.initState();
    _mapController = MapController();
    _clientName = widget.locationData?.clientName;
    _loadLocationData();
  }

  Future<void> _loadLocationData() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      // 1. Get device's current location
      final currentPos = await LocationService().getCurrentPosition();
      if (currentPos != null) {
        _currentLatLng = LatLng(currentPos.latitude, currentPos.longitude);
      }

      // 2. Fetch booking location from API if bookingId is provided
      if (widget.bookingId != null) {
        final result = await ApiClient().get(
          '/api/v1/providers/${widget.bookingId}/location',
          fromJsonT: (json) => json as Map<String, dynamic>,
        );

        result.fold(
          (failure) {
            // Fallback to locationData if API fails
            if (widget.locationData != null &&
                widget.locationData!.latitude != 0 &&
                widget.locationData!.longitude != 0) {
              _bookingLatLng = LatLng(
                widget.locationData!.latitude,
                widget.locationData!.longitude,
              );
              _bookingAddress = widget.locationData!.address;
              setState(() {
                _isLoading = false;
              });
              WidgetsBinding.instance.addPostFrameCallback((_) => _fitMap());
            } else {
              setState(() {
                _errorMessage = 'Failed to load booking location: ${failure.message}';
                _isLoading = false;
              });
            }
          },
          (success) {
            final data = success.data;
            final locationMap = data['location'] as Map<String, dynamic>?;
            if (locationMap != null) {
              final coordinates = locationMap['coordinates'] as List<dynamic>?;
              _bookingAddress = locationMap['address'] as String?;
              if (coordinates != null && coordinates.length >= 2) {
                final double lng = (coordinates[0] as num).toDouble();
                final double lat = (coordinates[1] as num).toDouble();
                _bookingLatLng = LatLng(lat, lng);
              }
            }

            setState(() {
              _isLoading = false;
            });
            WidgetsBinding.instance.addPostFrameCallback((_) => _fitMap());
          },
        );
      } else {
        // Fallback to widget.locationData if bookingId is null
        if (widget.locationData != null) {
          _bookingAddress = widget.locationData!.address;
          if (widget.locationData!.latitude != 0 && widget.locationData!.longitude != 0) {
            _bookingLatLng = LatLng(
              widget.locationData!.latitude,
              widget.locationData!.longitude,
            );
          } else {
            // If coordinates are 0, use a default center (e.g. NYC)
            _bookingLatLng = const LatLng(40.7128, -74.0060);
          }
        } else {
          _bookingLatLng = const LatLng(40.7128, -74.0060);
        }

        setState(() {
          _isLoading = false;
        });
        WidgetsBinding.instance.addPostFrameCallback((_) => _fitMap());
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'An error occurred: $e';
        _isLoading = false;
      });
    }
  }

  void _fitMap() {
    if (!mounted) return;
    if (_bookingLatLng == null && _currentLatLng == null) return;

    if (_bookingLatLng != null && _currentLatLng != null) {
      _mapController.fitCamera(
        CameraFit.coordinates(
          coordinates: [
            _currentLatLng!,
            _bookingLatLng!,
          ],
          padding: const EdgeInsets.all(60.0),
        ),
      );
    } else {
      final target = _bookingLatLng ?? _currentLatLng!;
      _mapController.move(target, 15.0);
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
          'Booking Route Map',
          style: TextStyle(
            color: Colors.black87,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: false,
        actions: [
          if (!_isLoading && _errorMessage == null)
            IconButton(
              icon: const Icon(Icons.my_location, color: Color(0xFF2870BC)),
              onPressed: _fitMap,
            ),
        ],
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF2870BC)),
        ),
      );
    }

    if (_errorMessage != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, color: Colors.red, size: 48),
              const SizedBox(height: 16),
              Text(
                _errorMessage!,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 16, color: Colors.black87),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _loadLocationData,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2870BC),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }

    final markers = <Marker>[];

    if (_currentLatLng != null) {
      markers.add(
        Marker(
          point: _currentLatLng!,
          width: 50,
          height: 50,
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.blue.withOpacity(0.2),
              border: Border.all(color: Colors.blue, width: 2),
            ),
            child: const Center(
              child: Icon(
                Icons.my_location,
                color: Colors.blue,
                size: 20,
              ),
            ),
          ),
        ),
      );
    }

    if (_bookingLatLng != null) {
      markers.add(
        Marker(
          point: _bookingLatLng!,
          width: 50,
          height: 50,
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xFFFCA048).withOpacity(0.2),
              border: Border.all(color: const Color(0xFFFCA048), width: 2),
            ),
            child: const Center(
              child: Icon(
                Icons.location_on,
                color: Color(0xFFFCA048),
                size: 26,
              ),
            ),
          ),
        ),
      );
    }

    final polylines = <Polyline>[];
    if (_currentLatLng != null && _bookingLatLng != null) {
      polylines.add(
        Polyline(
          points: [_currentLatLng!, _bookingLatLng!],
          color: const Color(0xFF2870BC),
          strokeWidth: 4.0,
          borderColor: Colors.white,
          borderStrokeWidth: 1.0,
        ),
      );
    }

    final initialCenter = _bookingLatLng ?? _currentLatLng ?? const LatLng(40.7128, -74.0060);

    return Stack(
      children: [
        FlutterMap(
          mapController: _mapController,
          options: MapOptions(
            initialCenter: initialCenter,
            initialZoom: 14.0,
          ),
          children: [
            TileLayer(
              urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
              userAgentPackageName: 'com.example.izu',
            ),
            if (polylines.isNotEmpty) PolylineLayer(polylines: polylines),
            MarkerLayer(markers: markers),
          ],
        ),
        // Information overlay
        Positioned(
          bottom: 24,
          left: 24,
          right: 24,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (_currentLatLng != null) ...[
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.08),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.blue.withOpacity(0.1),
                        ),
                        child: const Icon(Icons.my_location, color: Colors.blue, size: 20),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Your Location',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: Colors.grey,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              '${_currentLatLng!.latitude.toStringAsFixed(4)}, ${_currentLatLng!.longitude.toStringAsFixed(4)}',
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Colors.black87,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
              ],
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.08),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: const Color(0xFFFCA048).withOpacity(0.1),
                      ),
                      child: const Icon(Icons.location_on, color: Color(0xFFFCA048), size: 20),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _clientName != null ? '$_clientName\'s Location' : 'Client Location',
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: Colors.grey,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            _bookingAddress ?? 'Fetching address...',
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Colors.black87,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
