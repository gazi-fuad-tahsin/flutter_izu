class LocationData {
  final String address;
  final double latitude;
  final double longitude;
  final String? clientName;
  final String? serviceType;

  LocationData({
    required this.address,
    required this.latitude,
    required this.longitude,
    this.clientName,
    this.serviceType,
  });
}
