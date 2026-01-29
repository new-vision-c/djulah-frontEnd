import 'package:hive/hive.dart';

part 'favorite_property.model.g.dart';

/// Modèle pour stocker les propriétés favorites localement
/// Contient les informations essentielles pour afficher le favori offline
@HiveType(typeId: 0)
class FavoriteProperty extends HiveObject {
  @HiveField(0)
  final String propertyId;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final String imagePath;

  @HiveField(3)
  final String priceText;

  @HiveField(4)
  final double rating;

  @HiveField(5)
  final String category;

  @HiveField(6)
  final DateTime addedAt;

  @HiveField(7)
  final bool isSyncedWithBackend;

  @HiveField(8)
  final String? userId;

  FavoriteProperty({
    required this.propertyId,
    required this.title,
    required this.imagePath,
    required this.priceText,
    required this.rating,
    required this.category,
    required this.addedAt,
    this.isSyncedWithBackend = false,
    this.userId,
  });

  /// Crée une copie avec des valeurs mises à jour
  FavoriteProperty copyWith({
    String? propertyId,
    String? title,
    String? imagePath,
    String? priceText,
    double? rating,
    String? category,
    DateTime? addedAt,
    bool? isSyncedWithBackend,
    String? userId,
  }) {
    return FavoriteProperty(
      propertyId: propertyId ?? this.propertyId,
      title: title ?? this.title,
      imagePath: imagePath ?? this.imagePath,
      priceText: priceText ?? this.priceText,
      rating: rating ?? this.rating,
      category: category ?? this.category,
      addedAt: addedAt ?? this.addedAt,
      isSyncedWithBackend: isSyncedWithBackend ?? this.isSyncedWithBackend,
      userId: userId ?? this.userId,
    );
  }

  /// Convertit en Map pour JSON/API
  Map<String, dynamic> toJson() {
    return {
      'propertyId': propertyId,
      'title': title,
      'imagePath': imagePath,
      'priceText': priceText,
      'rating': rating,
      'category': category,
      'addedAt': addedAt.toIso8601String(),
      'isSyncedWithBackend': isSyncedWithBackend,
      'userId': userId,
    };
  }

  /// Crée à partir d'un Map JSON
  factory FavoriteProperty.fromJson(Map<String, dynamic> json) {
    return FavoriteProperty(
      propertyId: json['propertyId'] as String,
      title: json['title'] as String,
      imagePath: json['imagePath'] as String,
      priceText: json['priceText'] as String,
      rating: (json['rating'] as num).toDouble(),
      category: json['category'] as String,
      addedAt: DateTime.parse(json['addedAt'] as String),
      isSyncedWithBackend: json['isSyncedWithBackend'] as bool? ?? false,
      userId: json['userId'] as String?,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FavoriteProperty &&
          runtimeType == other.runtimeType &&
          propertyId == other.propertyId;

  @override
  int get hashCode => propertyId.hashCode;
}

/// Extension pour faciliter la conversion FavoriteProperty <-> Logement
extension FavoritePropertyLogementExtension on FavoriteProperty {
  /// Recherche le Logement complet correspondant dans une liste
  /// Retourne null si non trouvé
  T? findLogement<T>(List<T> logements, String Function(T) getId) {
    try {
      return logements.firstWhere((l) => getId(l) == propertyId);
    } catch (_) {
      return null;
    }
  }
}
