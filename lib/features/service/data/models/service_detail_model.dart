class ServiceDetailModel {
  final String id;
  final CategoryDetailInfo category;
  final ServiceDetailInfo serviceDetails;
  final ProviderDetailInfo providerId;
  final double averageRating;
  final List<dynamic> reviews;

  ServiceDetailModel({
    required this.id,
    required this.category,
    required this.serviceDetails,
    required this.providerId,
    required this.averageRating,
    required this.reviews,
  });

  factory ServiceDetailModel.fromJson(Map<String, dynamic> json) {
    return ServiceDetailModel(
      id: json['_id'] as String? ?? '',
      category: CategoryDetailInfo.fromJson(json['category'] as Map<String, dynamic>? ?? {}),
      serviceDetails: ServiceDetailInfo.fromJson(json['serviceDetails'] as Map<String, dynamic>? ?? {}),
      providerId: ProviderDetailInfo.fromJson(json['providerId'] as Map<String, dynamic>? ?? {}),
      averageRating: (json['averageRating'] as num?)?.toDouble() ?? 0.0,
      reviews: json['reviews'] as List<dynamic>? ?? [],
    );
  }
}

class CategoryDetailInfo {
  final String id;
  final String name;
  final String catImage;

  CategoryDetailInfo({
    required this.id,
    required this.name,
    required this.catImage,
  });

  factory CategoryDetailInfo.fromJson(Map<String, dynamic> json) {
    return CategoryDetailInfo(
      id: json['_id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      catImage: json['catImage'] as String? ?? '',
    );
  }
}

class ServiceDetailInfo {
  final String title;
  final int perSessionPrice;
  final int hourlyPrice;
  final String details;
  final bool isActive;
  final String address;
  final List<dynamic> serviceThumbnails;
  final String serviceType;

  ServiceDetailInfo({
    required this.title,
    required this.perSessionPrice,
    required this.hourlyPrice,
    required this.details,
    required this.isActive,
    required this.address,
    required this.serviceThumbnails,
    required this.serviceType,
  });

  factory ServiceDetailInfo.fromJson(Map<String, dynamic> json) {
    return ServiceDetailInfo(
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

class ProviderDetailInfo {
  final String id;
  final String name;
  final String email;
  final String profileImage;

  ProviderDetailInfo({
    required this.id,
    required this.name,
    required this.email,
    required this.profileImage,
  });

  factory ProviderDetailInfo.fromJson(Map<String, dynamic> json) {
    return ProviderDetailInfo(
      id: json['_id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      email: json['email'] as String? ?? '',
      profileImage: json['profileImage'] as String? ?? '',
    );
  }
}
