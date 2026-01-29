/// Entité représentant un équipement/commodité d'un logement
class Amenity {
  final String id;
  final String name;
  final String iconPath;
  final AmenityCategory category;

  const Amenity({
    required this.id,
    required this.name,
    required this.iconPath,
    this.category = AmenityCategory.general,
  });

  /// Copie avec modifications
  Amenity copyWith({
    String? id,
    String? name,
    String? iconPath,
    AmenityCategory? category,
  }) {
    return Amenity(
      id: id ?? this.id,
      name: name ?? this.name,
      iconPath: iconPath ?? this.iconPath,
      category: category ?? this.category,
    );
  }

  /// Conversion en Map JSON
  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'iconPath': iconPath,
    'category': category.name,
  };

  /// Création depuis Map JSON
  factory Amenity.fromJson(Map<String, dynamic> json) => Amenity(
    id: json['id'] as String,
    name: json['name'] as String,
    iconPath: json['iconPath'] as String,
    category: AmenityCategory.values.firstWhere(
      (e) => e.name == json['category'],
      orElse: () => AmenityCategory.general,
    ),
  );
}

/// Catégories d'équipements
enum AmenityCategory {
  general,      // Équipements généraux
  kitchen,      // Cuisine
  bathroom,     // Salle de bain
  bedroom,      // Chambre
  outdoor,      // Extérieur
  entertainment,// Divertissement
  security,     // Sécurité
  accessibility,// Accessibilité
}

/// Équipements prédéfinis couramment utilisés
class PredefinedAmenities {
  static const Amenity wifi = Amenity(
    id: 'wifi',
    name: 'Wifi',
    iconPath: 'assets/images/client/proposition_logement/wifi.png',
    category: AmenityCategory.general,
  );

  static const Amenity kitchen = Amenity(
    id: 'kitchen',
    name: 'Cuisine',
    iconPath: 'assets/images/client/proposition_logement/cooking.png',
    category: AmenityCategory.kitchen,
  );

  static const Amenity tv = Amenity(
    id: 'tv',
    name: 'Télévision',
    iconPath: 'assets/images/client/proposition_logement/tv-minimal.png',
    category: AmenityCategory.entertainment,
  );

  static const Amenity parking = Amenity(
    id: 'parking',
    name: 'Parking gratuit sur place',
    iconPath: 'assets/images/client/proposition_logement/car-front.png',
    category: AmenityCategory.outdoor,
  );

  static const Amenity airConditioning = Amenity(
    id: 'ac',
    name: 'Climatisation',
    iconPath: 'assets/images/client/proposition_logement/snowflake.png',
    category: AmenityCategory.general,
  );

  static const Amenity washer = Amenity(
    id: 'washer',
    name: 'Machine à laver',
    iconPath: 'assets/images/client/proposition_logement/washer.png',
    category: AmenityCategory.general,
  );

  static const Amenity pool = Amenity(
    id: 'pool',
    name: 'Piscine',
    iconPath: 'assets/images/client/proposition_logement/pool.png',
    category: AmenityCategory.outdoor,
  );

  static const Amenity security = Amenity(
    id: 'security',
    name: 'Agent de sécurité',
    iconPath: 'assets/images/client/proposition_logement/shield.png',
    category: AmenityCategory.security,
  );

  static const Amenity generator = Amenity(
    id: 'generator',
    name: 'Groupe électrogène',
    iconPath: 'assets/images/client/proposition_logement/zap.png',
    category: AmenityCategory.general,
  );

  static const Amenity hotWater = Amenity(
    id: 'hot_water',
    name: 'Eau chaude',
    iconPath: 'assets/images/client/proposition_logement/droplets.png',
    category: AmenityCategory.bathroom,
  );

  /// Liste de tous les équipements prédéfinis
  static const List<Amenity> all = [
    wifi,
    kitchen,
    tv,
    parking,
    airConditioning,
    washer,
    pool,
    security,
    generator,
    hotWater,
  ];

  /// Obtenir un équipement par son ID
  static Amenity? getById(String id) {
    try {
      return all.firstWhere((a) => a.id == id);
    } catch (_) {
      return null;
    }
  }
}
