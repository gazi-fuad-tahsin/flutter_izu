class ProviderServiceModel {
  final String id;
  final String title;
  final String category;
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
    // Extract service details from nested structure
    final serviceDetails = json['serviceDetails'] as Map<String, dynamic>? ?? {};
    final category = json['category'] as Map<String, dynamic>? ?? {};
    final providerId = json['providerId'] as Map<String, dynamic>? ?? {};
    
    // Get thumbnail images
    final thumbnails = (serviceDetails['serviceThumbnails'] as List<dynamic>?)
        ?.map((e) => e.toString())
        .toList() ?? [];
    
    // Use first thumbnail or category image
    final image = thumbnails.isNotEmpty
        ? thumbnails.first
        : (category['catImage'] as String? ?? '');
    
    // Generate provider handle from name
    final providerName = (providerId['name'] as String?) ?? 'Provider';
    final providerHandle = '@${providerName.replaceAll(' ', '')}';
    
    return ProviderServiceModel(
      id: json['_id'] as String? ?? '',
      title: (serviceDetails['title'] as String?) ?? '',
      category: (category['name'] as String?) ?? '',
      image: image,
      providerName: providerName,
      providerHandle: providerHandle,
      rating: (json['averageRating'] as num?)?.toDouble() ?? 0.0,
      distance: 0.0, // API doesn't provide distance
      pricePerHour: ((serviceDetails['hourlyPrice'] as num?)?.toDouble()) ?? 0.0,
      thumbnailImages: thumbnails,
      serviceDetails: (serviceDetails['details'] as String?) ?? '',
      serviceType: (serviceDetails['serviceType'] as String?) ?? 'hourly',
      perSessionPrice: ((serviceDetails['perSessionPrice'] as num?)?.toDouble()) ?? 0.0,
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
