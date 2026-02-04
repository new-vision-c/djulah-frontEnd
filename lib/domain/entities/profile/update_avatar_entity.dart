import '../auth/user_data.dart';

/// Entity pour la réponse de mise à jour de l'avatar
class UpdateAvatarEntity {
  final UserData user;
  final String avatarUrl;
  final String message;

  UpdateAvatarEntity({
    required this.user,
    required this.avatarUrl,
    required this.message,
  });

  factory UpdateAvatarEntity.fromJson(Map<String, dynamic> json) {
    return UpdateAvatarEntity(
      user: UserData.fromJson(json['data']?['user'] ?? {}),
      avatarUrl: json['data']?['avatarUrl'] ?? '',
      message: json['message'] ?? 'Avatar mis à jour',
    );
  }
}
