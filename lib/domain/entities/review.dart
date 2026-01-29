/// Entité représentant un commentaire/avis sur un logement
class Review {
  final String id;
  final String logementId;
  final String authorId;
  final String authorName;
  final String authorAvatarPath;
  final double rating;
  final String comment;
  final DateTime createdAt;
  final String? hostResponse;
  final DateTime? hostResponseAt;

  const Review({
    required this.id,
    required this.logementId,
    required this.authorId,
    required this.authorName,
    required this.authorAvatarPath,
    required this.rating,
    required this.comment,
    required this.createdAt,
    this.hostResponse,
    this.hostResponseAt,
  });

  /// Formatage de la date relative (ex: "il y a 2 jours")
  String get relativeDate {
    final now = DateTime.now();
    final diff = now.difference(createdAt);

    if (diff.inDays == 0) {
      return "Aujourd'hui";
    } else if (diff.inDays == 1) {
      return "Hier";
    } else if (diff.inDays < 7) {
      return "Il y a ${diff.inDays} jours";
    } else if (diff.inDays < 30) {
      final weeks = (diff.inDays / 7).floor();
      return "Il y a $weeks semaine${weeks > 1 ? 's' : ''}";
    } else if (diff.inDays < 365) {
      final months = (diff.inDays / 30).floor();
      return "Il y a $months mois";
    } else {
      final years = (diff.inDays / 365).floor();
      return "Il y a $years an${years > 1 ? 's' : ''}";
    }
  }

  /// Extrait du commentaire (pour prévisualisation)
  String get excerpt {
    if (comment.length <= 100) return comment;
    return '${comment.substring(0, 100)}...';
  }

  /// Copie avec modifications
  Review copyWith({
    String? id,
    String? logementId,
    String? authorId,
    String? authorName,
    String? authorAvatarPath,
    double? rating,
    String? comment,
    DateTime? createdAt,
    String? hostResponse,
    DateTime? hostResponseAt,
  }) {
    return Review(
      id: id ?? this.id,
      logementId: logementId ?? this.logementId,
      authorId: authorId ?? this.authorId,
      authorName: authorName ?? this.authorName,
      authorAvatarPath: authorAvatarPath ?? this.authorAvatarPath,
      rating: rating ?? this.rating,
      comment: comment ?? this.comment,
      createdAt: createdAt ?? this.createdAt,
      hostResponse: hostResponse ?? this.hostResponse,
      hostResponseAt: hostResponseAt ?? this.hostResponseAt,
    );
  }

  /// Conversion en Map JSON
  Map<String, dynamic> toJson() => {
    'id': id,
    'logementId': logementId,
    'authorId': authorId,
    'authorName': authorName,
    'authorAvatarPath': authorAvatarPath,
    'rating': rating,
    'comment': comment,
    'createdAt': createdAt.toIso8601String(),
    'hostResponse': hostResponse,
    'hostResponseAt': hostResponseAt?.toIso8601String(),
  };

  /// Création depuis Map JSON
  factory Review.fromJson(Map<String, dynamic> json) => Review(
    id: json['id'] as String,
    logementId: json['logementId'] as String,
    authorId: json['authorId'] as String,
    authorName: json['authorName'] as String,
    authorAvatarPath: json['authorAvatarPath'] as String,
    rating: (json['rating'] as num).toDouble(),
    comment: json['comment'] as String,
    createdAt: DateTime.parse(json['createdAt'] as String),
    hostResponse: json['hostResponse'] as String?,
    hostResponseAt: json['hostResponseAt'] != null 
        ? DateTime.parse(json['hostResponseAt'] as String) 
        : null,
  );
}
