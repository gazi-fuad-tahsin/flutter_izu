class SignupResponseModel {
  final String userId;
  final String email;
  final String phone;

  SignupResponseModel({
    required this.userId,
    required this.email,
    required this.phone,
  });

  factory SignupResponseModel.fromJson(Map<String, dynamic> json) {
    return SignupResponseModel(
      userId: json["userId"] ?? "",
      email: json["email"] ?? "",
      phone: json["phone"] ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "userId": userId,
      "email": email,
      "phone": phone,
    };
  }
}
