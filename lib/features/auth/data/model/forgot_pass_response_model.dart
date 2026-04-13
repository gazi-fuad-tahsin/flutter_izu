class ForgotPassResponseModel {
  final String email;
  final int otpExpiry;

  const ForgotPassResponseModel({
    required this.email,
    required this.otpExpiry,
  });

  factory ForgotPassResponseModel.fromJson(Map<String, dynamic> json) {
    return ForgotPassResponseModel(
      email: json['email'] ?? '',
      otpExpiry: json['otpExpiry'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'otpExpiry': otpExpiry,
    };
  }
}
