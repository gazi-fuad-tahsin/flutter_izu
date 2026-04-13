class SignupRequestModel {
  final String name;
  final String email;
  final String password;
  final String accountType;
  final String phone;

  SignupRequestModel({
    required this.name,
    required this.email,
    required this.password,
    required this.accountType,
    required this.phone,
  });

  Map<String, dynamic> toJson() {
    return {
      "name": name,
      "email": email,
      "password": password,
      "accountType": accountType,
      "phone": phone,
    };
  }
}
