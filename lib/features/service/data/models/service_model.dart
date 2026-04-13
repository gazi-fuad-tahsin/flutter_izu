class ServiceModel {
  final String id;
  final CategoryInfo category;
  final ServiceDetails serviceDetails;
  final double averageRating;
  final List<dynamic> reviews;
  final ProviderInfo provider;

  ServiceModel({
    required this.id,
    required this.category,
    required this.serviceDetails,
    required this.averageRating,
    required this.reviews,
    required this.provider,
  });

  factory ServiceModel.fromJson(Map<String, dynamic> json) {
    return ServiceModel(
      id: json['_id'] as String? ?? '',
      category: CategoryInfo.fromJson(json['category'] as Map<String, dynamic>? ?? {}),
      serviceDetails: ServiceDetails.fromJson(json['serviceDetails'] as Map<String, dynamic>? ?? {}),
      averageRating: (json['averageRating'] as num?)?.toDouble() ?? 0.0,
      reviews: json['reviews'] as List<dynamic>? ?? [],
      provider: ProviderInfo.fromJson(json['provider'] as Map<String, dynamic>? ?? {}),
    );
  }
}

class CategoryInfo {
  final String id;
  final String name;
  final String catImage;

  CategoryInfo({
    required this.id,
    required this.name,
    required this.catImage,
  });

  factory CategoryInfo.fromJson(Map<String, dynamic> json) {
    return CategoryInfo(
      id: json['_id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      catImage: json['catImage'] as String? ?? '',
    );
  }
}

class ServiceDetails {
  final String title;
  final int perSessionPrice;
  final int hourlyPrice;
  final String details;
  final bool isActive;
  final String address;
  final List<dynamic> serviceThumbnails;
  final String serviceType;

  ServiceDetails({
    required this.title,
    required this.perSessionPrice,
    required this.hourlyPrice,
    required this.details,
    required this.isActive,
    required this.address,
    required this.serviceThumbnails,
    required this.serviceType,
  });

  factory ServiceDetails.fromJson(Map<String, dynamic> json) {
    return ServiceDetails(
      title: json['title'] as String? ?? '',
      perSessionPrice: json['perSessionPrice'] as int? ?? 0,
      hourlyPrice: json['hourlyPrice'] as int? ?? 0,
      details: json['details'] as String? ?? '',
      isActive: json['isActive'] as bool? ?? false,
      address: json['address'] as String? ?? '',
      serviceThumbnails: json['serviceThumbnails'] as List<dynamic>? ?? [],
      serviceType: json['serviceType'] as String? ?? '',
    );
  }
}

class ProviderInfo {
  final String id;
  final String name;
  final String email;
  final String profileImage;
  final String language;

  ProviderInfo({
    required this.id,
    required this.name,
    required this.email,
    required this.profileImage,
    required this.language,
  });

  factory ProviderInfo.fromJson(Map<String, dynamic> json) {
    return ProviderInfo(
      id: json['_id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      email: json['email'] as String? ?? '',
      profileImage: json['profileImage'] as String? ?? '',
      language: json['language'] as String? ?? '',
    );
  }
}
