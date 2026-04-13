class ResetPasswordResponseModel {
  final String email;

  const ResetPasswordResponseModel({required this.email});

  factory ResetPasswordResponseModel.fromJson(Map<String, dynamic> json) {
    return ResetPasswordResponseModel(
      email: json['email'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'email': email,
    };
  }
}
