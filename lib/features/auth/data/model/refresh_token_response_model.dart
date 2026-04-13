import 'auth_response_model.dart';

class RefreshTokenResponseModel {
  final String accessToken;
  final String refreshToken;
  final String role;
  final User? user;

  RefreshTokenResponseModel({
    required this.accessToken,
    required this.refreshToken,
    required this.role,
    this.user,
  });

  factory RefreshTokenResponseModel.fromJson(Map<String, dynamic> json) {
    return RefreshTokenResponseModel(
      accessToken: json['accessToken'] ?? '',
      refreshToken: json['refreshToken'] ?? '',
      role: json['role'] ?? '',
      user: json['user'] != null ? User.fromJson(json['user']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'accessToken': accessToken,
      'refreshToken': refreshToken,
      'role': role,
      'user': user?.toJson(),
    };
  }
}
