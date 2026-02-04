import '../auth/user_data.dart';

/// Entity pour la réponse de mise à jour du profil (nom)
class UpdateProfileEntity {
  final UserData user;
  final String message;

  UpdateProfileEntity({
    required this.user,
    required this.message,
  });

  factory UpdateProfileEntity.fromJson(Map<String, dynamic> json) {
    return UpdateProfileEntity(
      user: UserData.fromJson(json['data']?['user'] ?? {}),
      message: json['message'] ?? 'Profil mis à jour',
    );
  }
}
