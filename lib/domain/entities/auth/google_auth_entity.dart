import 'user_data.dart';

class GoogleAuthEntity {
  final String message;
  final String? accessToken;
  final String? refreshToken;
  final UserData? user;
  final bool isNewUser;
  final bool requiresOtp;
  final String? otpCode;

  GoogleAuthEntity({
    required this.message,
    this.accessToken,
    this.refreshToken,
    this.user,
    this.isNewUser = false,
    this.requiresOtp = false,
    this.otpCode,
  });

  factory GoogleAuthEntity.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>?;
    
    final token = (data?['token'] is String) 
        ? data!['token'] as String 
        : (data?['accessToken'] is String) 
            ? data!['accessToken'] as String 
            : null;
    
    return GoogleAuthEntity(
      message: json['message']?.toString() ?? '',
      accessToken: token,
      refreshToken: (data?['refreshToken'] is String) 
          ? data!['refreshToken'] as String 
          : null,
      user: data?['user'] != null 
          ? UserData.fromJson(data!['user'] as Map<String, dynamic>) 
          : null,
      isNewUser: data?['isNewUser'] as bool? ?? false,
      requiresOtp: data?['requiresOtp'] as bool? ?? false,
      otpCode: data?['otpCode']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'accessToken': accessToken,
      'refreshToken': refreshToken,
      'user': user?.toJson(),
      'isNewUser': isNewUser,
      'requiresOtp': requiresOtp,
      'otpCode': otpCode,
    };
  }
}
