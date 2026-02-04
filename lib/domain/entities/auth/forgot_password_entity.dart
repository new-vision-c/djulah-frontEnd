class ForgotPasswordEntity {
  final String message;

  ForgotPasswordEntity({
    required this.message,
  });

  factory ForgotPasswordEntity.fromJson(Map<String, dynamic> json) {
    return ForgotPasswordEntity(
      message: json['message'] ?? '',
    );
  }
}
