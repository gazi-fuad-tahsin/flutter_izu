class ProviderProfileModel {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String? profileImage;
  final String language;
  final String overallAverageRating;
  final List<dynamic> services;
  final bool isActive;

  ProviderProfileModel({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    this.profileImage,
    required this.language,
    required this.overallAverageRating,
    required this.services,
    required this.isActive,
  });

  factory ProviderProfileModel.fromJson(Map<String, dynamic> json) {
    return ProviderProfileModel(
      id: json['_id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      email: json['email'] as String? ?? '',
      phone: json['phone'] as String? ?? '',
      profileImage: json['profileImage'] as String?,
      language: json['language'] as String? ?? 'English',
      overallAverageRating: json['overallAverageRating'] as String? ?? '0.0',
      services: json['services'] as List<dynamic>? ?? [],
      isActive: json['isActive'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'profileImage': profileImage,
      'language': language,
      'overallAverageRating': overallAverageRating,
      'services': services,
      'isActive': isActive,
    };
  }

  ProviderProfileModel copyWith({
    String? id,
    String? name,
    String? email,
    String? phone,
    String? profileImage,
    String? language,
    String? overallAverageRating,
    List<dynamic>? services,
    bool? isActive,
  }) {
    return ProviderProfileModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      profileImage: profileImage ?? this.profileImage,
      language: language ?? this.language,
      overallAverageRating: overallAverageRating ?? this.overallAverageRating,
      services: services ?? this.services,
      isActive: isActive ?? this.isActive,
    );
  }
}
