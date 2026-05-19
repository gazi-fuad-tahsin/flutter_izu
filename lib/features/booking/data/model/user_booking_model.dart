import 'package:intl/intl.dart';

class UserBookingModel {
  final String id;
  final String providerId;
  final String providerName;
  final String providerImage;
  final String providerEmail;
  final String clientName;
  final String clientEmail;
  final String location;
  final DateTime bookingTime;
  final String serviceName;
  final String categoryName;
  final double totalPrice;
  final String status;
  final String extraNote;
  final int estimatedHours;

  UserBookingModel({
    required this.id,
    required this.providerId,
    required this.providerName,
    required this.providerImage,
    required this.providerEmail,
    required this.clientName,
    required this.clientEmail,
    required this.location,
    required this.bookingTime,
    required this.serviceName,
    required this.categoryName,
    required this.totalPrice,
    required this.status,
    required this.extraNote,
    required this.estimatedHours,
  });

  /// Format date from DateTime to string
  String get formattedDate {
    return DateFormat('d MMMM yyyy').format(bookingTime);
  }

  /// Format time from DateTime to string
  String get formattedTime {
    return DateFormat('hh:mm a').format(bookingTime);
  }

  /// Factory constructor to parse API response
  factory UserBookingModel.fromJson(Map<String, dynamic> json) {
    // Extract provider info
    final Map<String, dynamic> providerIdMap = json['providerId'] ?? {};
    final String providerIdStr = providerIdMap['_id'] ?? '';
    final String providerName = providerIdMap['name'] ?? 'Provider';
    final String providerImage = providerIdMap['profileImage'] ?? '';
    final String providerEmail = providerIdMap['email'] ?? '';

    // Extract client info
    final Map<String, dynamic> userId = json['userId'] ?? {};
    final String clientName = userId['name'] ?? 'User';
    final String clientEmail = userId['email'] ?? '';

    // Extract service info
    final Map<String, dynamic> serviceId = json['serviceId'] ?? {};
    final Map<String, dynamic> serviceDetails = serviceId['serviceDetails'] ?? {};
    final Map<String, dynamic> category = serviceId['category'] ?? {};

    final String serviceName = serviceDetails['title'] ?? 'Service';
    final String categoryName = category['name'] ?? 'Category';

    // Extract location
    final Map<String, dynamic> location = json['location'] ?? {};
    final String locationAddress = location['address'] ?? 'Address not provided';

    // Parse booking time
    final DateTime bookingTime = DateTime.parse(json['bookingTime'] ?? DateTime.now().toIso8601String());

    return UserBookingModel(
      id: json['_id'] ?? '',
      providerId: providerIdStr,
      providerName: providerName,
      providerImage: providerImage,
      providerEmail: providerEmail,
      clientName: clientName,
      clientEmail: clientEmail,
      location: locationAddress,
      bookingTime: bookingTime,
      serviceName: serviceName,
      categoryName: categoryName,
      totalPrice: (json['totalPrice'] ?? 0).toDouble(),
      status: json['status'] ?? 'pending',
      extraNote: json['extraNote'] ?? '',
      estimatedHours: json['estimatedHours'] ?? 1,
    );
  }
}
