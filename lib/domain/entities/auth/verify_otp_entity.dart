import 'user_data.dart';

class VerifyOtpEntity {
  final String message;
  final String? accessToken;
  final String? refreshToken;
  final UserData? user;

  VerifyOtpEntity({
    required this.message,
    this.accessToken,
    this.refreshToken,
    this.user,
  });

  factory VerifyOtpEntity.fromJson(Map<String, dynamic> json) {
    return VerifyOtpEntity(
      message: json['message'] ?? '',
      accessToken: json['data']?['accessToken'],
      refreshToken: json['data']?['refreshToken'],
      user: json['data']?['user'] != null 
          ? UserData.fromJson(json['data']['user']) 
          : null,
    );
  }
}
