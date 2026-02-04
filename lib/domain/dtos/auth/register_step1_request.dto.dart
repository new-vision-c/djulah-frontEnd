class RegisterStep1RequestDto {
  final String email;
  final String fullname;
  final String password;

  RegisterStep1RequestDto({
    required this.email,
    required this.fullname,
    required this.password,
  });

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'fullname': fullname,
      'password': password,
    };
  }
}
