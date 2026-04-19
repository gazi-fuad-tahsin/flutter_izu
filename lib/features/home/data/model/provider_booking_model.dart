import 'package:intl/intl.dart';

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
  final String? bookingType;
  final int? estimatedHours;
  final String? extraNote;

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
    this.bookingType,
    this.estimatedHours,
    this.extraNote,
  });

  /// Factory to parse from API response
  factory ProviderBooking.fromJson(Map<String, dynamic> json) {
    final bookingTime = json['bookingTime'] != null
        ? DateTime.parse(json['bookingTime'] as String)
        : DateTime.now();

    final date = DateFormat('d MMM yyyy').format(bookingTime);
    final time = DateFormat('hh:mm a').format(bookingTime);

    final clientName = json['userId']?['name'] ?? 'Unknown Client';
    final clientImage = json['userId']?['profileImage'] ?? 'assets/images/profile_avatar.png';
    final location = json['location']?['address'] ?? 'Unknown Location';
    
    final serviceTitle = json['serviceId']?['serviceDetails']?['title'] ?? 'Service';
    final totalPrice = json['totalPrice'] ?? 0;
    final status = json['status'] ?? 'pending';
    final bookingType = json['bookingType'] ?? 'hourly';
    final estimatedHours = json['estimatedHours'] as int? ?? 0;
    final extraNote = json['extraNote'] as String?;

    return ProviderBooking(
      id: json['_id'] as String? ?? '',
      clientName: clientName,
      clientImage: clientImage,
      location: location,
      date: date,
      time: time,
      service: serviceTitle,
      amount: '\$${totalPrice}',
      status: status,
      isCancelled: status == 'cancelled',
      bookingType: bookingType,
      estimatedHours: estimatedHours,
      extraNote: extraNote,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'clientName': clientName,
      'clientImage': clientImage,
      'location': location,
      'date': date,
      'time': time,
      'service': service,
      'amount': amount,
      'status': status,
      'duration': duration,
      'paymentStatus': paymentStatus,
      'isCancelled': isCancelled,
      'bookingType': bookingType,
      'estimatedHours': estimatedHours,
      'extraNote': extraNote,
    };
  }
}
