import 'auth_response_model.dart';

class RegisterResponseModel {
  final String accessToken;
  final String refreshToken;
  final String role;
  final String id;
  final User user;

  RegisterResponseModel({
    required this.accessToken,
    required this.refreshToken,
    required this.role,
    required this.id,
    required this.user,
  });

  factory RegisterResponseModel.fromJson(Map<String, dynamic> json) {
    return RegisterResponseModel(
      accessToken: json["accessToken"] ?? "",
      refreshToken: json["refreshToken"] ?? "",
      role: json["role"] ?? "",
      id: json["_id"] ?? "",
      user: User.fromJson(json["user"] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "accessToken": accessToken,
      "refreshToken": refreshToken,
      "role": role,
      "_id": id,
      "user": user.toJson(),
    };
  }
}
