class ProviderServiceModel {
  final String id;
  final String title;
  final String category;
  final String categoryId;
  final String image;
  final String providerName;
  final String providerHandle;
  final double rating;
  final double distance;
  final double pricePerHour;
  final List<String> thumbnailImages;
  final String serviceDetails;
  final String serviceType;
  final double perSessionPrice;

  ProviderServiceModel({
    required this.id,
    required this.title,
    required this.category,
    this.categoryId = '',
    required this.image,
    required this.providerName,
    required this.providerHandle,
    required this.rating,
    required this.distance,
    required this.pricePerHour,
    this.thumbnailImages = const [],
    this.serviceDetails = '',
    this.serviceType = 'hourly',
    this.perSessionPrice = 0.0,
  });

  factory ProviderServiceModel.fromJson(Map<String, dynamic> json) {
    // Handle serviceDetails as either a Map or a List
    final serviceDetailsRaw = json['serviceDetails'];
    final Map<String, dynamic> serviceDetail;
    if (serviceDetailsRaw is List && serviceDetailsRaw.isNotEmpty) {
      serviceDetail = serviceDetailsRaw.first as Map<String, dynamic>? ?? {};
    } else if (serviceDetailsRaw is Map<String, dynamic>) {
      serviceDetail = serviceDetailsRaw;
    } else {
      serviceDetail = {};
    }

    // Handle category as either a populated Map or a plain ID string
    final categoryRaw = json['category'];
    final String categoryName;
    final String categoryIdValue;
    if (categoryRaw is Map<String, dynamic>) {
      categoryName = categoryRaw['name'] as String? ?? '';
      categoryIdValue = categoryRaw['_id'] as String? ?? '';
    } else {
      categoryName = '';
      categoryIdValue = categoryRaw?.toString() ?? '';
    }

    final providerId = json['providerId'] as Map<String, dynamic>? ?? {};

    // Get thumbnail images
    final thumbnails = (serviceDetail['serviceThumbnails'] as List<dynamic>?)
        ?.map((e) => e.toString())
        .toList() ?? [];

    // Use first thumbnail or category image
    final image = thumbnails.isNotEmpty
        ? thumbnails.first
        : ((categoryRaw is Map ? categoryRaw['catImage'] : null) as String? ?? '');

    final providerName = (providerId['name'] as String?) ?? 'Provider';
    final providerHandle = '@${providerName.replaceAll(' ', '')}';

    return ProviderServiceModel(
      id: json['_id'] as String? ?? '',
      title: (serviceDetail['title'] as String?) ?? '',
      category: categoryName,
      categoryId: categoryIdValue,
      image: image,
      providerName: providerName,
      providerHandle: providerHandle,
      rating: (json['averageRating'] as num?)?.toDouble() ?? 0.0,
      distance: 0.0,
      pricePerHour: ((serviceDetail['hourlyPrice'] as num?)?.toDouble()) ?? 0.0,
      thumbnailImages: thumbnails,
      serviceDetails: (serviceDetail['details'] as String?) ?? '',
      serviceType: (serviceDetail['serviceType'] as String?) ?? 'hourly',
      perSessionPrice: ((serviceDetail['perSessionPrice'] as num?)?.toDouble()) ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'category': category,
      'image': image,
      'providerName': providerName,
      'providerHandle': providerHandle,
      'rating': rating,
      'distance': distance,
      'pricePerHour': pricePerHour,
      'thumbnailImages': thumbnailImages,
      'serviceDetails': serviceDetails,
      'serviceType': serviceType,
      'perSessionPrice': perSessionPrice,
    };
  }

  ProviderServiceModel copyWith({
    String? id,
    String? title,
    String? category,
    String? categoryId,
    String? image,
    String? providerName,
    String? providerHandle,
    double? rating,
    double? distance,
    double? pricePerHour,
    List<String>? thumbnailImages,
    String? serviceDetails,
    String? serviceType,
    double? perSessionPrice,
  }) {
    return ProviderServiceModel(
      id: id ?? this.id,
      title: title ?? this.title,
      category: category ?? this.category,
      categoryId: categoryId ?? this.categoryId,
      image: image ?? this.image,
      providerName: providerName ?? this.providerName,
      providerHandle: providerHandle ?? this.providerHandle,
      rating: rating ?? this.rating,
      distance: distance ?? this.distance,
      pricePerHour: pricePerHour ?? this.pricePerHour,
      thumbnailImages: thumbnailImages ?? this.thumbnailImages,
      serviceDetails: serviceDetails ?? this.serviceDetails,
      serviceType: serviceType ?? this.serviceType,
      perSessionPrice: perSessionPrice ?? this.perSessionPrice,
    );
  }
}
