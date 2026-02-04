/// Entité représentant un hôte/propriétaire de logement
class Host {
  final String id;
  final String name;
  final String avatarPath;
  final String language;
  final int yearsAsHost;
  final int totalReviews;
  final double globalRating;
  final int responseRate; // Pourcentage de réponse (0-100)
  final String responseTime; // Ex: "dans l'heure", "en quelques heures"
  final String? bio;
  final bool isVerified;
  final bool isSuperhost;

  const Host({
    required this.id,
    required this.name,
    required this.avatarPath,
    this.language = 'Français',
    this.yearsAsHost = 1,
    this.totalReviews = 0,
    this.globalRating = 0.0,
    this.responseRate = 0,
    this.responseTime = 'en quelques heures',
    this.bio,
    this.isVerified = false,
    this.isSuperhost = false,
  });

  /// Copie avec modifications
  Host copyWith({
    String? id,
    String? name,
    String? avatarPath,
    String? language,
    int? yearsAsHost,
    int? totalReviews,
    double? globalRating,
    int? responseRate,
    String? responseTime,
    String? bio,
    bool? isVerified,
    bool? isSuperhost,
  }) {
    return Host(
      id: id ?? this.id,
      name: name ?? this.name,
      avatarPath: avatarPath ?? this.avatarPath,
      language: language ?? this.language,
      yearsAsHost: yearsAsHost ?? this.yearsAsHost,
      totalReviews: totalReviews ?? this.totalReviews,
      globalRating: globalRating ?? this.globalRating,
      responseRate: responseRate ?? this.responseRate,
      responseTime: responseTime ?? this.responseTime,
      bio: bio ?? this.bio,
      isVerified: isVerified ?? this.isVerified,
      isSuperhost: isSuperhost ?? this.isSuperhost,
    );
  }

  /// Conversion en Map JSON
  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'avatarPath': avatarPath,
    'language': language,
    'yearsAsHost': yearsAsHost,
    'totalReviews': totalReviews,
    'globalRating': globalRating,
    'responseRate': responseRate,
    'responseTime': responseTime,
    'bio': bio,
    'isVerified': isVerified,
    'isSuperhost': isSuperhost,
  };

  /// Création depuis Map JSON
  factory Host.fromJson(Map<String, dynamic> json) => Host(
    id: json['id'] as String,
    name: json['name'] as String,
    avatarPath: json['avatarPath'] as String,
    language: json['language'] as String? ?? 'Français',
    yearsAsHost: json['yearsAsHost'] as int? ?? 1,
    totalReviews: json['totalReviews'] as int? ?? 0,
    globalRating: (json['globalRating'] as num?)?.toDouble() ?? 0.0,
    responseRate: json['responseRate'] as int? ?? 0,
    responseTime: json['responseTime'] as String? ?? 'en quelques heures',
    bio: json['bio'] as String?,
    isVerified: json['isVerified'] as bool? ?? false,
    isSuperhost: json['isSuperhost'] as bool? ?? false,
  );

  /// Hôte par défaut pour les cas où les données sont manquantes
  static const Host defaultHost = Host(
    id: 'default',
    name: 'Hôte Djulah',
    avatarPath: 'assets/images/client/avatar/avatar_profil.png',
    language: 'Français',
    yearsAsHost: 1,
    totalReviews: 0,
    globalRating: 0.0,
    responseRate: 0,
    responseTime: 'en quelques heures',
  );
}








