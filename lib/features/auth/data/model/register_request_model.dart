class RegisterRequestModel {
  final String email;
  final String password;
  final String confirmPassword;
  final String role;

  RegisterRequestModel({
    required this.email,
    required this.password,
    required this.confirmPassword,
    required this.role,
  });

  Map<String, dynamic> toJson() {
    return {
      "email": email,
      "password": password,
      "confirmPassword": confirmPassword,
      "role": role,
    };
  }
}
