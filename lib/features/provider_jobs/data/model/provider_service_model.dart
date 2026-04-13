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
  });

  factory ProviderServiceModel.fromJson(Map<String, dynamic> json) {
    return ProviderServiceModel(
      id: json['id'] as String? ?? '1',
      title: json['title'] as String? ?? '',
      category: json['category'] as String? ?? '',
      image: json['image'] as String? ?? '',
      providerName: json['providerName'] as String? ?? '',
      providerHandle: json['providerHandle'] as String? ?? '',
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
      distance: (json['distance'] as num?)?.toDouble() ?? 0.0,
      pricePerHour: (json['pricePerHour'] as num?)?.toDouble() ?? 0.0,
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
    );
  }
}
