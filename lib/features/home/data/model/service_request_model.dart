class ServiceRequest {
  final String id;
  final String clientName;
  final String clientImage;
  final String date;
  final String time;
  final String service;
  final String location;

  ServiceRequest({
    required this.id,
    required this.clientName,
    required this.clientImage,
    required this.date,
    required this.time,
    required this.service,
    required this.location,
  });
}
