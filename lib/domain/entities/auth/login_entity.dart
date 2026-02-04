import 'user_data.dart';

class LoginEntity {
  final String message;
  final String accessToken;
  final String refreshToken;
  final UserData user;

  LoginEntity({
    required this.message,
    required this.accessToken,
    required this.refreshToken,
    required this.user,
  });

  factory LoginEntity.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>?;
    
    final token = (data?['token'] is String) ? data!['token'] as String : '';
    
    return LoginEntity(
      message: json['message']?.toString() ?? '',
      accessToken: token,
      refreshToken: (data?['refreshToken'] is String) ? data!['refreshToken'] as String : '',
      user: UserData.fromJson(data?['user'] as Map<String, dynamic>? ?? {}),
    );
  }
}
