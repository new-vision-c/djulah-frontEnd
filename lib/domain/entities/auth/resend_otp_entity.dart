class ResendOtpEntity {
  final String message;
  final String? email;

  ResendOtpEntity({
    required this.message,
    this.email,
  });

  factory ResendOtpEntity.fromJson(Map<String, dynamic> json) {
    return ResendOtpEntity(
      message: json['message'] ?? '',
      email: json['data']?['email'],
    );
  }
}
