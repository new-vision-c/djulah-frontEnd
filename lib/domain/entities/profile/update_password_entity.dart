/// Entity pour la réponse de mise à jour du mot de passe
class UpdatePasswordEntity {
  final String message;

  UpdatePasswordEntity({
    required this.message,
  });

  factory UpdatePasswordEntity.fromJson(Map<String, dynamic> json) {
    return UpdatePasswordEntity(
      message: json['message'] ?? 'Mot de passe mis à jour',
    );
  }
}
