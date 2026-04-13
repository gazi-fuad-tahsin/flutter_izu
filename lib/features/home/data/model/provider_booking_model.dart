class ProviderBooking {
  final String id;
  final String clientName;
  final String clientImage;
  final String location;
  final String date;
  final String time;
  final String service;
  final String amount;
  final String status; // live, next, completed, cancelled
  final String? duration; // For live bookings
  final String? paymentStatus; // pending, accepted
  final bool isCancelled;

  ProviderBooking({
    required this.id,
    required this.clientName,
    required this.clientImage,
    required this.location,
    required this.date,
    required this.time,
    required this.service,
    required this.amount,
    required this.status,
    this.duration,
    this.paymentStatus,
    this.isCancelled = false,
  });
}
