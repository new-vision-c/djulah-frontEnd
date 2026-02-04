/// Entité représentant la réponse de suppression de compte
class DeleteAccountEntity {
  final String deletedAt;
  final String message;

  DeleteAccountEntity({
    required this.deletedAt,
    required this.message,
  });

  factory DeleteAccountEntity.fromJson(Map<String, dynamic> json) {
    final data = json['data'] ?? json;
    return DeleteAccountEntity(
      deletedAt: data['deletedAt'] ?? '',
      message: data['message'] ?? 'Compte supprimé avec succès',
    );
  }
}
