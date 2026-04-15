class PendingRequest {
  final String id;
  final UserInfo userId;
  final ServiceInfo serviceId;
  final String title;
  final String bookingTime;
  final LocationInfo location;
  final double totalPrice;
  final UserInfo providerId;
  final String? extraNote;
  final double providerAmount;
  final String status;
  final String bookingType;
  final int estimatedHours;

  PendingRequest({
    required this.id,
    required this.userId,
    required this.serviceId,
    required this.title,
    required this.bookingTime,
    required this.location,
    required this.totalPrice,
    required this.providerId,
    this.extraNote,
    required this.providerAmount,
    required this.status,
    required this.bookingType,
    required this.estimatedHours,
  });

  factory PendingRequest.fromJson(Map<String, dynamic> json) {
    return PendingRequest(
      id: json['_id'] ?? '',
      userId: UserInfo.fromJson(json['userId'] ?? {}),
      serviceId: ServiceInfo.fromJson(json['serviceId'] ?? {}),
      title: json['title'] ?? '',
      bookingTime: json['bookingTime'] ?? '',
      location: LocationInfo.fromJson(json['location'] ?? {}),
      totalPrice: (json['totalPrice'] ?? 0).toDouble(),
      providerId: UserInfo.fromJson(json['providerId'] ?? {}),
      extraNote: json['extraNote'],
      providerAmount: (json['providerAmount'] ?? 0).toDouble(),
      status: json['status'] ?? '',
      bookingType: json['bookingType'] ?? '',
      estimatedHours: json['estimatedHours'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'userId': userId.toJson(),
      'serviceId': serviceId.toJson(),
      'title': title,
      'bookingTime': bookingTime,
      'location': location.toJson(),
      'totalPrice': totalPrice,
      'providerId': providerId.toJson(),
      'extraNote': extraNote,
      'providerAmount': providerAmount,
      'status': status,
      'bookingType': bookingType,
      'estimatedHours': estimatedHours,
    };
  }
}

class UserInfo {
  final String id;
  final String name;
  final String email;
  final String profileImage;

  UserInfo({
    required this.id,
    required this.name,
    required this.email,
    required this.profileImage,
  });

  factory UserInfo.fromJson(Map<String, dynamic> json) {
    return UserInfo(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      profileImage: json['profileImage'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'email': email,
      'profileImage': profileImage,
    };
  }
}

class ServiceInfo {
  final String id;
  final CategoryInfo? category;
  final ServiceDetails? serviceDetails;
  final UserInfo? providerId;

  ServiceInfo({
    required this.id,
    this.category,
    this.serviceDetails,
    this.providerId,
  });

  factory ServiceInfo.fromJson(Map<String, dynamic> json) {
    return ServiceInfo(
      id: json['_id'] ?? '',
      category: json['category'] != null ? CategoryInfo.fromJson(json['category']) : null,
      serviceDetails: json['serviceDetails'] != null ? ServiceDetails.fromJson(json['serviceDetails']) : null,
      providerId: json['providerId'] != null ? UserInfo.fromJson(json['providerId']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'category': category?.toJson(),
      'serviceDetails': serviceDetails?.toJson(),
      'providerId': providerId?.toJson(),
    };
  }
}

class CategoryInfo {
  final String id;
  final String name;

  CategoryInfo({
    required this.id,
    required this.name,
  });

  factory CategoryInfo.fromJson(Map<String, dynamic> json) {
    return CategoryInfo(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
    };
  }
}

class ServiceDetails {
  final String title;
  final double perSessionPrice;
  final double hourlyPrice;
  final String details;
  final bool isActive;
  final String address;
  final String serviceType;

  ServiceDetails({
    required this.title,
    required this.perSessionPrice,
    required this.hourlyPrice,
    required this.details,
    required this.isActive,
    required this.address,
    required this.serviceType,
  });

  factory ServiceDetails.fromJson(Map<String, dynamic> json) {
    return ServiceDetails(
      title: json['title'] ?? '',
      perSessionPrice: (json['perSessionPrice'] ?? 0).toDouble(),
      hourlyPrice: (json['hourlyPrice'] ?? 0).toDouble(),
      details: json['details'] ?? '',
      isActive: json['isActive'] ?? false,
      address: json['address'] ?? '',
      serviceType: json['serviceType'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'perSessionPrice': perSessionPrice,
      'hourlyPrice': hourlyPrice,
      'details': details,
      'isActive': isActive,
      'address': address,
      'serviceType': serviceType,
    };
  }
}

class LocationInfo {
  final String type;
  final List<double> coordinates;
  final String address;

  LocationInfo({
    required this.type,
    required this.coordinates,
    required this.address,
  });

  factory LocationInfo.fromJson(Map<String, dynamic> json) {
    final coords = (json['coordinates'] as List?)?.map((e) => (e as num).toDouble()).toList() ?? [0.0, 0.0];
    return LocationInfo(
      type: json['type'] ?? 'Point',
      coordinates: coords,
      address: json['address'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'coordinates': coordinates,
      'address': address,
    };
  }
}
