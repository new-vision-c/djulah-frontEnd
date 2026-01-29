import 'package:djulah/domain/entities/amenity.dart';
import 'package:djulah/domain/entities/host.dart';
import 'package:djulah/domain/entities/location_info.dart';
import 'package:djulah/domain/entities/review.dart';
import 'package:djulah/domain/enums/mockupFilter.dart';

import '../../presentation/client/home/controllers/home.controller.dart';
import '../enums/type_logement.dart';

/// Alias pour rétrocompatibilité - Utiliser Propriete à la place
@Deprecated('Utiliser Propriete à la place')
typedef Logement = Propriete;

/// Entité principale représentant une propriété immobilière
/// Contient toutes les informations nécessaires pour l'affichage détaillé
class Propriete {
  // === Identifiants ===
  final String id;
  
  // === Informations de base ===
  final String title;
  final String imagePath; // Image principale (pour les listes)
  final List<String> images; // Toutes les images de la propriété
  final String priceText;
  final double pricePerNight; // Prix numérique pour calculs
  final double rating;
  final int reviewCount; // Nombre de commentaires
  final double distanceKm;
  final String description;
  
  // === Catégorisation ===
  final String category;
  final TypeLogement typeLogement;
  final Mockupfilter filter;
  
  // === Caractéristiques de la propriété ===
  final int bedrooms; // Nombre de chambres
  final int beds; // Nombre de lits
  final int bathrooms; // Nombre de salles de bain
  final int maxGuests; // Nombre max de voyageurs
  
  // === Relations ===
  final Host host; // Hôte/propriétaire
  final List<Amenity> amenities; // Équipements
  final List<Review> reviews; // Commentaires
  final LocationInfo location; // Localisation
  
  // === Métadonnées ===
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final bool isAvailable;
  final bool isPromoted; // Mis en avant

  const Propriete({
    required this.id,
    required this.title,
    required this.imagePath,
    this.images = const [],
    required this.priceText,
    this.pricePerNight = 0,
    required this.rating,
    this.reviewCount = 0,
    required this.distanceKm,
    this.description = '',
    required this.category,
    required this.typeLogement,
    required this.filter,
    this.bedrooms = 1,
    this.beds = 1,
    this.bathrooms = 1,
    this.maxGuests = 2,
    this.host = Host.defaultHost,
    this.amenities = const [],
    this.reviews = const [],
    this.location = LocationInfo.defaultLocation,
    this.createdAt,
    this.updatedAt,
    this.isAvailable = true,
    this.isPromoted = false,
  });

  /// Liste complète des images (inclut imagePath si images est vide)
  List<String> get allImages {
    if (images.isEmpty) return [imagePath];
    return images;
  }

  /// Texte des caractéristiques (ex: "2 chambres · 3 lits · 1 salle de bain")
  String get featuresText {
    final parts = <String>[];
    if (bedrooms > 0) {
      parts.add('$bedrooms chambre${bedrooms > 1 ? 's' : ''}');
    }
    if (beds > 0) {
      parts.add('$beds lit${beds > 1 ? 's' : ''}');
    }
    if (bathrooms > 0) {
      parts.add('$bathrooms salle${bathrooms > 1 ? 's' : ''} de bain');
    }
    return parts.join(' · ');
  }

  /// Texte de notation (ex: "4.5 · 23 commentaires")
  String get ratingText => '$rating · $reviewCount commentaires';

  /// Description courte (extrait)
  String get shortDescription {
    if (description.length <= 150) return description;
    return '${description.substring(0, 150)}...';
  }

  /// Copie avec modifications
  Propriete copyWith({
    String? id,
    String? title,
    String? imagePath,
    List<String>? images,
    String? priceText,
    double? pricePerNight,
    double? rating,
    int? reviewCount,
    double? distanceKm,
    String? description,
    String? category,
    TypeLogement? typeLogement,
    Mockupfilter? filter,
    int? bedrooms,
    int? beds,
    int? bathrooms,
    int? maxGuests,
    Host? host,
    List<Amenity>? amenities,
    List<Review>? reviews,
    LocationInfo? location,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isAvailable,
    bool? isPromoted,
  }) {
    return Propriete(
      id: id ?? this.id,
      title: title ?? this.title,
      imagePath: imagePath ?? this.imagePath,
      images: images ?? this.images,
      priceText: priceText ?? this.priceText,
      pricePerNight: pricePerNight ?? this.pricePerNight,
      rating: rating ?? this.rating,
      reviewCount: reviewCount ?? this.reviewCount,
      distanceKm: distanceKm ?? this.distanceKm,
      description: description ?? this.description,
      category: category ?? this.category,
      typeLogement: typeLogement ?? this.typeLogement,
      filter: filter ?? this.filter,
      bedrooms: bedrooms ?? this.bedrooms,
      beds: beds ?? this.beds,
      bathrooms: bathrooms ?? this.bathrooms,
      maxGuests: maxGuests ?? this.maxGuests,
      host: host ?? this.host,
      amenities: amenities ?? this.amenities,
      reviews: reviews ?? this.reviews,
      location: location ?? this.location,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isAvailable: isAvailable ?? this.isAvailable,
      isPromoted: isPromoted ?? this.isPromoted,
    );
  }

  /// Conversion en Map JSON
  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'imagePath': imagePath,
    'images': images,
    'priceText': priceText,
    'pricePerNight': pricePerNight,
    'rating': rating,
    'reviewCount': reviewCount,
    'distanceKm': distanceKm,
    'description': description,
    'category': category,
    'typeLogement': typeLogement.name,
    'filter': filter.name,
    'bedrooms': bedrooms,
    'beds': beds,
    'bathrooms': bathrooms,
    'maxGuests': maxGuests,
    'host': host.toJson(),
    'amenities': amenities.map((a) => a.toJson()).toList(),
    'reviews': reviews.map((r) => r.toJson()).toList(),
    'location': location.toJson(),
    'createdAt': createdAt?.toIso8601String(),
    'updatedAt': updatedAt?.toIso8601String(),
    'isAvailable': isAvailable,
    'isPromoted': isPromoted,
  };

  /// Création depuis Map JSON
  factory Propriete.fromJson(Map<String, dynamic> json) => Propriete(
    id: json['id'] as String,
    title: json['title'] as String,
    imagePath: json['imagePath'] as String,
    images: (json['images'] as List<dynamic>?)?.cast<String>() ?? [],
    priceText: json['priceText'] as String,
    pricePerNight: (json['pricePerNight'] as num?)?.toDouble() ?? 0,
    rating: (json['rating'] as num).toDouble(),
    reviewCount: json['reviewCount'] as int? ?? 0,
    distanceKm: (json['distanceKm'] as num).toDouble(),
    description: json['description'] as String? ?? '',
    category: json['category'] as String,
    typeLogement: TypeLogement.values.firstWhere(
      (e) => e.name == json['typeLogement'],
      orElse: () => TypeLogement.meubles,
    ),
    filter: Mockupfilter.values.firstWhere(
      (e) => e.name == json['filter'],
      orElse: () => Mockupfilter.proximite,
    ),
    bedrooms: json['bedrooms'] as int? ?? 1,
    beds: json['beds'] as int? ?? 1,
    bathrooms: json['bathrooms'] as int? ?? 1,
    maxGuests: json['maxGuests'] as int? ?? 2,
    host: json['host'] != null 
        ? Host.fromJson(json['host'] as Map<String, dynamic>) 
        : Host.defaultHost,
    amenities: (json['amenities'] as List<dynamic>?)
        ?.map((a) => Amenity.fromJson(a as Map<String, dynamic>))
        .toList() ?? [],
    reviews: (json['reviews'] as List<dynamic>?)
        ?.map((r) => Review.fromJson(r as Map<String, dynamic>))
        .toList() ?? [],
    location: json['location'] != null 
        ? LocationInfo.fromJson(json['location'] as Map<String, dynamic>) 
        : LocationInfo.defaultLocation,
    createdAt: json['createdAt'] != null 
        ? DateTime.parse(json['createdAt'] as String) 
        : null,
    updatedAt: json['updatedAt'] != null 
        ? DateTime.parse(json['updatedAt'] as String) 
        : null,
    isAvailable: json['isAvailable'] as bool? ?? true,
    isPromoted: json['isPromoted'] as bool? ?? false,
  );
}


/// Alias pour rétrocompatibilité
@Deprecated('Utiliser MockupProprietes à la place')
typedef MockupLogements = MockupProprietes;

class MockupProprietes {
  // === Hôtes mockup ===
  static const _hostChris = Host(
    id: 'host_1',
    name: 'Chris Kody',
    avatarPath: 'assets/images/client/avatar/avatar1.png',
    language: 'Français',
    yearsAsHost: 3,
    totalReviews: 268,
    globalRating: 4.8,
    responseRate: 99,
    responseTime: "dans l'heure",
    bio: "Passionné par l'accueil et le partage, je mets tout en œuvre pour que vos séjours soient inoubliables.",
    isVerified: true,
    isSuperhost: true,
  );

  static const _hostMarie = Host(
    id: 'host_2',
    name: 'Marie Dupont',
    avatarPath: 'assets/images/client/avatar/avatar2.png',
    language: 'Français, Anglais',
    yearsAsHost: 2,
    totalReviews: 89,
    globalRating: 4.5,
    responseRate: 95,
    responseTime: 'en quelques heures',
    isVerified: true,
  );

  // === Équipements communs ===
  static final _basicAmenities = [
    PredefinedAmenities.wifi,
    PredefinedAmenities.kitchen,
    PredefinedAmenities.tv,
    PredefinedAmenities.parking,
  ];

  static final _premiumAmenities = [
    PredefinedAmenities.wifi,
    PredefinedAmenities.kitchen,
    PredefinedAmenities.tv,
    PredefinedAmenities.parking,
    PredefinedAmenities.airConditioning,
    PredefinedAmenities.washer,
    PredefinedAmenities.pool,
    PredefinedAmenities.security,
    PredefinedAmenities.generator,
    PredefinedAmenities.hotWater,
  ];

  // === Commentaires mockup ===
  static final _sampleReviews1 = [
    Review(
      id: 'review_1',
      logementId: '1',
      authorId: 'user_1',
      authorName: 'Jean Pierre',
      authorAvatarPath: 'assets/images/client/avatar/Avatar3.png',
      rating: 5.0,
      comment: "Excellent séjour ! L'appartement est exactement comme sur les photos, très propre et bien situé. Chris est un hôte formidable.",
      createdAt: DateTime.now().subtract(const Duration(days: 5)),
    ),
    Review(
      id: 'review_2',
      logementId: '1',
      authorId: 'user_2',
      authorName: 'Sarah K.',
      authorAvatarPath: 'assets/images/client/avatar/Avatar4.png',
      rating: 4.5,
      comment: "Très bel appartement, bien équipé. La communication avec l'hôte était parfaite. Je recommande vivement !",
      createdAt: DateTime.now().subtract(const Duration(days: 15)),
    ),
  ];

  static final _sampleReviews2 = [
    Review(
      id: 'review_3',
      logementId: '2',
      authorId: 'user_3',
      authorName: 'Pierre M.',
      authorAvatarPath: 'assets/images/client/avatar/Avatar3.png',
      rating: 4.0,
      comment: "Bon appartement, propre et fonctionnel. L'emplacement est idéal pour découvrir la ville. Marie est très réactive.",
      createdAt: DateTime.now().subtract(const Duration(days: 3)),
    ),
    Review(
      id: 'review_4',
      logementId: '2',
      authorId: 'user_4',
      authorName: 'Aminata D.',
      authorAvatarPath: 'assets/images/client/avatar/Avatar4.png',
      rating: 4.5,
      comment: "Séjour agréable, l'appartement correspond à la description. Je reviendrai !",
      createdAt: DateTime.now().subtract(const Duration(days: 20)),
    ),
  ];

  static final _sampleReviews3 = [
    Review(
      id: 'review_5',
      logementId: '3',
      authorId: 'user_5',
      authorName: 'Paul T.',
      authorAvatarPath: 'assets/images/client/avatar/Avatar3.png',
      rating: 4.0,
      comment: "Chambre confortable et bien située. Parfait pour un court séjour d'affaires.",
      createdAt: DateTime.now().subtract(const Duration(days: 7)),
    ),
  ];

  static final logements = [
    Propriete(
      id: '1',
      title: 'Studio Moderne Damas',
      imagePath: 'assets/images/client/imagesSplash/4.jpg',
      images: [
        'assets/images/client/imagesSplash/4.jpg',
        'assets/images/client/imagesSplash/1.jpg',
        'assets/images/client/imagesSplash/2.jpg',
        'assets/images/client/imagesSplash/3.jpg',
      ],
      priceText: '10.000 XAF/nuit',
      pricePerNight: 10000,
      rating: 4.5,
      reviewCount: 23,
      distanceKm: 1.2,
      description: "Charmant appartement à louer, idéalement situé au cœur de la ville. Il dispose de deux chambres lumineuses, d'une cuisine moderne entièrement équipée et d'un salon spacieux. Parfait pour un séjour en famille ou entre amis.",
      typeLogement: TypeLogement.meubles,
      category: 'Studios',
      filter: Mockupfilter.proximite,
      bedrooms: 2,
      beds: 3,
      bathrooms: 1,
      maxGuests: 4,
      host: _hostChris,
      amenities: _premiumAmenities,
      reviews: _sampleReviews1,
      location: const LocationInfo(
        latitude: 4.0435,
        longitude: 9.7043,
        city: 'Douala',
        country: 'Cameroun',
        neighborhood: 'Bonamoussadi',
      ),
    ),
    Propriete(
      id: '2',
      title: 'Appartement à louer-Douala',
      imagePath: 'assets/images/client/imagesSplash/3.jpg',
      images: [
        'assets/images/client/imagesSplash/3.jpg',
        'assets/images/client/imagesSplash/2.jpg',
        'assets/images/client/imagesSplash/4.jpg',
      ],
      priceText: '8.000 XAF/nuit',
      pricePerNight: 8000,
      rating: 4.2,
      reviewCount: 15,
      distanceKm: 3.4,
      description: "Bel appartement moderne avec vue sur la ville. Équipements complets, proche des commodités et des transports.",
      typeLogement: TypeLogement.meubles,
      category: 'Chambres',
      filter: Mockupfilter.proximite,
      bedrooms: 1,
      beds: 2,
      bathrooms: 1,
      maxGuests: 3,
      host: _hostMarie,
      amenities: _basicAmenities,
      reviews: _sampleReviews2,
      location: const LocationInfo(
        latitude: 4.0511,
        longitude: 9.7679,
        city: 'Douala',
        country: 'Cameroun',
        neighborhood: 'Akwa',
      ),
    ),
    Propriete(
      id: '3',
      title: 'Chambre cosy centre-ville',
      imagePath: 'assets/images/client/imagesSplash/2.jpg',
      images: [
        'assets/images/client/imagesSplash/2.jpg',
        'assets/images/client/imagesSplash/1.jpg',
      ],
      priceText: '8.000 XAF/nuit',
      pricePerNight: 8000,
      rating: 4.2,
      reviewCount: 8,
      distanceKm: 3.4,
      description: "Chambre confortable au cœur de la ville, idéale pour les voyageurs d'affaires ou les touristes.",
      typeLogement: TypeLogement.meubles,
      category: 'Chambres',
      filter: Mockupfilter.categories,
      bedrooms: 1,
      beds: 1,
      bathrooms: 1,
      maxGuests: 2,
      host: _hostChris,
      amenities: _basicAmenities,
      reviews: _sampleReviews3,
      location: const LocationInfo(
        latitude: 4.0483,
        longitude: 9.7043,
        city: 'Douala',
        country: 'Cameroun',
        neighborhood: 'Centre-ville',
      ),
    ),
    Propriete(
      id: '4',
      title: 'Chambre cosy centre-ville',
      imagePath: 'assets/images/client/imagesSplash/2.jpg',
      priceText: '8.000 XAF/nuit',
      rating: 4.2,
      distanceKm: 3.4,
      typeLogement: TypeLogement.meubles,
      category: 'Studio',
      filter: Mockupfilter.categories,
    ),
    Propriete(
      id: '5',
      title: 'Chambre cosy centre-ville',
      imagePath: 'assets/images/client/imagesSplash/1.jpg',
      priceText: '8.000 XAF/nuit',
      rating: 4.2,
      distanceKm: 3.4,
      typeLogement: TypeLogement.meubles,
      category: 'Appartements',
      filter: Mockupfilter.most_reserve,
    ),
    Propriete(
      id: '4',
      title: 'Chambre cosy centre-ville',
      imagePath: 'assets/images/client/imagesSplash/2.jpg',
      priceText: '8.000 XAF/nuit',
      rating: 4.2,
      distanceKm: 3.4,
      category: 'Studio',
      typeLogement: TypeLogement.meubles,
      filter: Mockupfilter.most_reserve,
    ),
    Propriete(
      id: '5',
      title: 'Chambre cosy centre-ville',
      imagePath: 'assets/images/client/imagesSplash/1.jpg',
      priceText: '8.000 XAF/nuit',
      rating: 4.2,
      distanceKm: 3.4,
      typeLogement: TypeLogement.meubles,
      category: 'Appartements',
      filter: Mockupfilter.most_reserve,
    ),
    // Non meubles
    Propriete(
      id: '6',
      title: 'Appartement vide Bonamoussadi',
      imagePath: 'assets/images/client/imagesSplash/3.jpg',
      priceText: '50.000 XAF/mois',
      rating: 4.3,
      distanceKm: 2.1,
      typeLogement: TypeLogement.non_meubles,
      category: 'Appartements',
      filter: Mockupfilter.categories,
    ),
    Propriete(
      id: '7',
      title: 'Studio sans meubles Akwa',
      imagePath: 'assets/images/client/imagesSplash/2.jpg',
      priceText: '35.000 XAF/mois',
      rating: 4.1,
      distanceKm: 1.8,
      typeLogement: TypeLogement.non_meubles,
      category: 'Studios',
      filter: Mockupfilter.categories,
    ),
    Propriete(
      id: '8',
      title: 'Chambre non meublée Bonaberi',
      imagePath: 'assets/images/client/imagesSplash/4.jpg',
      priceText: '25.000 XAF/mois',
      rating: 3.9,
      distanceKm: 4.2,
      typeLogement: TypeLogement.non_meubles,
      category: 'Chambres',
      filter: Mockupfilter.proximite,
    ),
    Propriete(
      id: '9',
      title: 'Villa non meublée Bonapriso',
      imagePath: 'assets/images/client/imagesSplash/1.jpg',
      priceText: '150.000 XAF/mois',
      rating: 4.6,
      distanceKm: 2.5,
      typeLogement: TypeLogement.non_meubles,
      category: 'Maisons',
      filter: Mockupfilter.most_reserve,
    ),
    // Commercial
    Propriete(
      id: '10',
      title: 'Bureau moderne Akwa',
      imagePath: 'assets/images/client/imagesSplash/4.jpg',
      priceText: '200.000 XAF/mois',
      rating: 4.7,
      distanceKm: 1.5,
      typeLogement: TypeLogement.commercial,
      category: 'Bureaux',
      filter: Mockupfilter.categories,
    ),
    Propriete(
      id: '11',
      title: 'Boutique centre commercial',
      imagePath: 'assets/images/client/imagesSplash/2.jpg',
      priceText: '300.000 XAF/mois',
      rating: 4.5,
      distanceKm: 3.2,
      typeLogement: TypeLogement.commercial,
      category: 'Boutiques',
      filter: Mockupfilter.categories,
    ),
    Propriete(
      id: '12',
      title: 'Entrepôt Bonaberi',
      imagePath: 'assets/images/client/imagesSplash/3.jpg',
      priceText: '250.000 XAF/mois',
      rating: 4.2,
      distanceKm: 5.8,
      typeLogement: TypeLogement.commercial,
      category: 'Entrepôts',
      filter: Mockupfilter.proximite,
    ),
    Propriete(
      id: '13',
      title: 'Local commercial Deido',
      imagePath: 'assets/images/client/imagesSplash/4.jpg',
      priceText: '180.000 XAF/mois',
      rating: 4.4,
      distanceKm: 2.3,
      typeLogement: TypeLogement.commercial,
      category: 'Locaux',
      filter: Mockupfilter.most_reserve,
    ),
    // Plus de catégories - Meubles
    Propriete(
      id: '14',
      title: 'Villa luxueuse Bonapriso',
      imagePath: 'assets/images/client/imagesSplash/5.jpg',
      priceText: '25.000 XAF/nuit',
      rating: 4.8,
      distanceKm: 2.1,
      typeLogement: TypeLogement.meubles,
      category: 'Villas',
      filter: Mockupfilter.categories,
    ),
    Propriete(
      id: '15',
      title: 'Duplex moderne Akwa',
      imagePath: 'assets/images/client/imagesSplash/3.jpg',
      priceText: '18.000 XAF/nuit',
      rating: 4.6,
      distanceKm: 1.5,
      typeLogement: TypeLogement.meubles,
      category: 'Duplex',
      filter: Mockupfilter.categories,
    ),
    Propriete(
      id: '16',
      title: 'Penthouse vue mer',
      imagePath: 'assets/images/client/imagesSplash/1.jpg',
      priceText: '30.000 XAF/nuit',
      rating: 4.9,
      distanceKm: 1.8,
      typeLogement: TypeLogement.meubles,
      category: 'Penthouses',
      filter: Mockupfilter.categories,
    ),
    Propriete(
      id: '17',
      title: 'Loft industriel Bali',
      imagePath: 'assets/images/client/imagesSplash/3.jpg',
      priceText: '15.000 XAF/nuit',
      rating: 4.4,
      distanceKm: 3.5,
      typeLogement: TypeLogement.meubles,
      category: 'Lofts',
      filter: Mockupfilter.categories,
    ),
    Propriete(
      id: '18',
      title: 'Résidence sécurisée Bonanjo',
      imagePath: 'assets/images/client/imagesSplash/2.jpg',
      priceText: '20.000 XAF/nuit',
      rating: 4.7,
      distanceKm: 2.3,
      typeLogement: TypeLogement.meubles,
      category: 'Résidences',
      filter: Mockupfilter.most_reserve,
    ),
    Propriete(
      id: '19',
      title: 'Bungalow jardin Logpom',
      imagePath: 'assets/images/client/imagesSplash/4.jpg',
      priceText: '12.000 XAF/nuit',
      rating: 4.3,
      distanceKm: 4.1,
      typeLogement: TypeLogement.meubles,
      category: 'Bungalows',
      filter: Mockupfilter.proximite,
    ),
    // Plus de catégories - Non meubles
    Propriete(
      id: '20',
      title: 'Villa à aménager Kotto',
      imagePath: 'assets/images/client/imagesSplash/5.jpg',
      priceText: '180.000 XAF/mois',
      rating: 4.5,
      distanceKm: 3.8,
      typeLogement: TypeLogement.non_meubles,
      category: 'Villas',
      filter: Mockupfilter.categories,
    ),
    Propriete(
      id: '21',
      title: 'Duplex vide Makepe',
      imagePath: 'assets/images/client/imagesSplash/4.jpg',
      priceText: '120.000 XAF/mois',
      rating: 4.2,
      distanceKm: 4.5,
      typeLogement: TypeLogement.non_meubles,
      category: 'Duplex',
      filter: Mockupfilter.categories,
    ),
    Propriete(
      id: '22',
      title: 'Loft à personnaliser',
      imagePath: 'assets/images/client/imagesSplash/1.jpg',
      priceText: '90.000 XAF/mois',
      rating: 4.0,
      distanceKm: 3.2,
      typeLogement: TypeLogement.non_meubles,
      category: 'Lofts',
      filter: Mockupfilter.categories,
    ),
    Propriete(
      id: '23',
      title: 'Penthouse brut Akwa',
      imagePath: 'assets/images/client/imagesSplash/3.jpg',
      priceText: '200.000 XAF/mois',
      rating: 4.4,
      distanceKm: 1.7,
      typeLogement: TypeLogement.non_meubles,
      category: 'Penthouses',
      filter: Mockupfilter.most_reserve,
    ),
    Propriete(
      id: '24',
      title: 'Résidence neuve Ndokoti',
      imagePath: 'assets/images/client/imagesSplash/2.jpg',
      priceText: '130.000 XAF/mois',
      rating: 4.6,
      distanceKm: 5.2,
      typeLogement: TypeLogement.non_meubles,
      category: 'Résidences',
      filter: Mockupfilter.proximite,
    ),
    // Plus de catégories - Commercial
    Propriete(
      id: '25',
      title: 'Showroom Avenue Kennedy',
      imagePath: 'assets/images/client/imagesSplash/5.jpg',
      priceText: '350.000 XAF/mois',
      rating: 4.8,
      distanceKm: 1.2,
      typeLogement: TypeLogement.commercial,
      category: 'Showrooms',
      filter: Mockupfilter.categories,
    ),
    Propriete(
      id: '26',
      title: 'Restaurant équipé Bonapriso',
      imagePath: 'assets/images/client/imagesSplash/1.jpg',
      priceText: '400.000 XAF/mois',
      rating: 4.6,
      distanceKm: 2.0,
      typeLogement: TypeLogement.commercial,
      category: 'Restaurants',
      filter: Mockupfilter.categories,
    ),
    Propriete(
      id: '27',
      title: 'Atelier artisanal Bonaberi',
      imagePath: 'assets/images/client/imagesSplash/1.jpg',
      priceText: '150.000 XAF/mois',
      rating: 4.1,
      distanceKm: 5.5,
      typeLogement: TypeLogement.commercial,
      category: 'Ateliers',
      filter: Mockupfilter.categories,
    ),
    Propriete(
      id: '28',
      title: 'Espace coworking Akwa',
      imagePath: 'assets/images/client/imagesSplash/3.jpg',
      priceText: '280.000 XAF/mois',
      rating: 4.7,
      distanceKm: 1.4,
      typeLogement: TypeLogement.commercial,
      category: 'Coworking',
      filter: Mockupfilter.most_reserve,
    ),
    Propriete(
      id: '29',
      title: 'Garage professionnel Deido',
      imagePath: 'assets/images/client/imagesSplash/4.jpg',
      priceText: '220.000 XAF/mois',
      rating: 4.3,
      distanceKm: 3.1,
      typeLogement: TypeLogement.commercial,
      category: 'Garages',
      filter: Mockupfilter.proximite,
    ),
    Propriete(
      id: '30',
      title: 'Salle événementiel Bonanjo',
      imagePath: 'assets/images/client/imagesSplash/2.jpg',
      priceText: '500.000 XAF/mois',
      rating: 4.9,
      distanceKm: 2.2,
      typeLogement: TypeLogement.commercial,
      category: 'Salles',
      filter: Mockupfilter.most_reserve,
    ),
  ];
   static List<Logement> logementsByFilter(Mockupfilter filter) {
    return logements.where((l) => l.filter == filter).toList();
  }
}
