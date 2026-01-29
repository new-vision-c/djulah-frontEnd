/// Entité représentant les informations de localisation d'un logement
class LocationInfo {
  final double latitude;
  final double longitude;
  final String city;
  final String country;
  final String? neighborhood; // Quartier
  final String? fullAddress;
  final String? postalCode;

  const LocationInfo({
    required this.latitude,
    required this.longitude,
    required this.city,
    required this.country,
    this.neighborhood,
    this.fullAddress,
    this.postalCode,
  });

  /// Adresse formatée pour affichage
  String get displayAddress {
    if (fullAddress != null && fullAddress!.isNotEmpty) {
      return fullAddress!;
    }
    
    final parts = <String>[];
    if (neighborhood != null && neighborhood!.isNotEmpty) {
      parts.add(neighborhood!);
    }
    parts.add(city);
    parts.add(country);
    
    return parts.join(', ');
  }

  /// Adresse courte (ville, pays)
  String get shortAddress => '$city, $country';

  /// Copie avec modifications
  LocationInfo copyWith({
    double? latitude,
    double? longitude,
    String? city,
    String? country,
    String? neighborhood,
    String? fullAddress,
    String? postalCode,
  }) {
    return LocationInfo(
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      city: city ?? this.city,
      country: country ?? this.country,
      neighborhood: neighborhood ?? this.neighborhood,
      fullAddress: fullAddress ?? this.fullAddress,
      postalCode: postalCode ?? this.postalCode,
    );
  }

  /// Conversion en Map JSON
  Map<String, dynamic> toJson() => {
    'latitude': latitude,
    'longitude': longitude,
    'city': city,
    'country': country,
    'neighborhood': neighborhood,
    'fullAddress': fullAddress,
    'postalCode': postalCode,
  };

  /// Création depuis Map JSON
  factory LocationInfo.fromJson(Map<String, dynamic> json) => LocationInfo(
    latitude: (json['latitude'] as num).toDouble(),
    longitude: (json['longitude'] as num).toDouble(),
    city: json['city'] as String,
    country: json['country'] as String,
    neighborhood: json['neighborhood'] as String?,
    fullAddress: json['fullAddress'] as String?,
    postalCode: json['postalCode'] as String?,
  );

  /// Localisation par défaut (Douala, Cameroun)
  static const LocationInfo defaultLocation = LocationInfo(
    latitude: 4.0511,
    longitude: 9.7679,
    city: 'Douala',
    country: 'Cameroun',
  );
}
