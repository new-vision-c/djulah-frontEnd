import 'user_data.dart';

class MeEntity {
  final UserData user;

  MeEntity({
    required this.user,
  });

  factory MeEntity.fromJson(Map<String, dynamic> json) {
    return MeEntity(
      user: UserData.fromJson(json['data']?['user'] ?? {}),
    );
  }
}
