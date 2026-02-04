class ResetPasswordEntity {
  final String message;

  ResetPasswordEntity({
    required this.message,
  });

  factory ResetPasswordEntity.fromJson(Map<String, dynamic> json) {
    return ResetPasswordEntity(
      message: json['message'] ?? '',
    );
  }
}
