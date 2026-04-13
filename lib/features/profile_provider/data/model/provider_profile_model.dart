class ProviderProfileModel {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String? profileImage;
  final double rating;
  final int completedServices;
  final double earnings;
  final String handle;

  ProviderProfileModel({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    this.profileImage,
    required this.rating,
    required this.completedServices,
    required this.earnings,
    required this.handle,
  });

  factory ProviderProfileModel.fromJson(Map<String, dynamic> json) {
    return ProviderProfileModel(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      email: json['email'] as String? ?? '',
      phone: json['phone'] as String? ?? '',
      profileImage: json['profileImage'] as String?,
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
      completedServices: json['completedServices'] as int? ?? 0,
      earnings: (json['earnings'] as num?)?.toDouble() ?? 0.0,
      handle: json['handle'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'profileImage': profileImage,
      'rating': rating,
      'completedServices': completedServices,
      'earnings': earnings,
      'handle': handle,
    };
  }

  ProviderProfileModel copyWith({
    String? id,
    String? name,
    String? email,
    String? phone,
    String? profileImage,
    double? rating,
    int? completedServices,
    double? earnings,
    String? handle,
  }) {
    return ProviderProfileModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      profileImage: profileImage ?? this.profileImage,
      rating: rating ?? this.rating,
      completedServices: completedServices ?? this.completedServices,
      earnings: earnings ?? this.earnings,
      handle: handle ?? this.handle,
    );
  }
}
