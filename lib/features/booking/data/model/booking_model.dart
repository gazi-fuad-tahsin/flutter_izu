class UserBooking {
  final String id;
  final String providerName;
  final String providerImage;
  final String location;
  final String date;
  final String time;
  final String service;
  final String amount;
  final String status; // live, upcoming, completed, cancelled
  final String? duration; // For live bookings
  final String? paymentStatus; // pending, completed
  final bool isCancelled;
  final String? rating; // For completed bookings
  final String? review; // For completed bookings
  final String? cancelReason; // For cancelled bookings

  UserBooking({
    required this.id,
    required this.providerName,
    required this.providerImage,
    required this.location,
    required this.date,
    required this.time,
    required this.service,
    required this.amount,
    required this.status,
    this.duration,
    this.paymentStatus,
    this.isCancelled = false,
    this.rating,
    this.review,
    this.cancelReason,
  });
}
