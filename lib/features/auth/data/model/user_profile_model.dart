class UserProfileModel {
  final String id;
  final String name;
  final String email;
  final String? profileImage;
  final String accountType;
  final String? phone;
  final String? language;
  final DateTime createdAt;

  UserProfileModel({
    required this.id,
    required this.name,
    required this.email,
    this.profileImage,
    required this.accountType,
    this.phone,
    this.language,
    required this.createdAt,
  });

  factory UserProfileModel.fromJson(Map<String, dynamic> json) {
    return UserProfileModel(
      id: json['_id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      email: json['email'] as String? ?? '',
      profileImage: json['profileImage'] as String?,
      accountType: json['accountType'] as String? ?? '',
      phone: json['phone'] as String?,
      language: json['language'] as String?,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'email': email,
      'profileImage': profileImage,
      'accountType': accountType,
      'phone': phone,
      'language': language,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}
