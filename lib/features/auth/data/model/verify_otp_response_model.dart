class VerifyMailOtpResponseModel {
  final String email;

  const VerifyMailOtpResponseModel({required this.email});

  factory VerifyMailOtpResponseModel.fromJson(Map<String, dynamic> json) {
    return VerifyMailOtpResponseModel(
      email: json['email'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'email': email,
    };
  }
}
