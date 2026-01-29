import 'package:djulah/datas/local_storage/favorites_storage_service.dart';
import 'package:djulah/datas/local_storage/recently_viewed_storage_service.dart';
import 'package:djulah/datas/models/favorite_property.model.dart';
import 'package:djulah/domain/entities/logement.dart';
import 'package:get/get.dart';

/// Modèle pour l'affichage visuel des favoris (utilisé par AppCard2)
class EnregistrementModel {
  final String id; // ID de la propriété pour les actions
  final String title;
  final String ownerName;
  final String details;
  final String price;
  final double rating;
  final List<String> images;

  EnregistrementModel({
    required this.id,
    required this.title,
    required this.ownerName,
    required this.details,
    required this.price,
    required this.rating,
    required this.images,
  });
  
  /// Crée un EnregistrementModel depuis un FavoriteProperty
  factory EnregistrementModel.fromFavorite(FavoriteProperty favorite) {
    return EnregistrementModel(
      id: favorite.propertyId,
      title: favorite.title,
      ownerName: 'Propriétaire', // TODO: Ajouter au modèle FavoriteProperty si besoin
      details: favorite.category,
      price: favorite.priceText,
      rating: favorite.rating,
      images: [favorite.imagePath], // Une seule image stockée
    );
  }
}

class FavorisController extends GetxController {
  final isLoading = true.obs;
  
  /// Liste des favoris pour l'affichage (EnregistrementModel pour AppCard2)
  final enregistrements = <EnregistrementModel>[].obs;
  
  /// Liste des propriétés vues récemment
  final vuRecemment = <Propriete>[].obs;
  
  /// Service de stockage des favoris
  FavoritesStorageService get _favoritesService => Get.find<FavoritesStorageService>();
  
  /// Service de stockage des vus récemment
  RecentlyViewedStorageService get _recentlyViewedService => Get.find<RecentlyViewedStorageService>();

  /// Récupère les 4 premières images pour la grille "Vu récemment"
  List<String> get listCustomCard {
    return _recentlyViewedService.getRecentImages(count: 4);
  }

  @override
  void onInit() {
    super.onInit();
    _loadData();
    
    // Écouter les changements dans les favoris
    ever(_favoritesService.favorites, (_) => _refreshFavorites());
    
    // Écouter les changements dans les vus récemment
    ever(_recentlyViewedService.recentlyViewedItems, (_) => _refreshRecentlyViewed());
  }

  Future<void> _loadData() async {
    isLoading.value = true;
    await Future.delayed(const Duration(milliseconds: 500));
    
    _refreshFavorites();
    _refreshRecentlyViewed();
    
    isLoading.value = false;
  }
  
  /// Rafraîchit la liste des favoris depuis le stockage local
  void _refreshFavorites() {
    // Convertir FavoriteProperty en EnregistrementModel pour l'affichage
    enregistrements.assignAll(
      _favoritesService.favorites
          .map((f) => EnregistrementModel.fromFavorite(f))
          .toList()
    );
  }
  
  /// Rafraîchit la liste des vus récemment
  void _refreshRecentlyViewed() {
    vuRecemment.assignAll(_recentlyViewedService.getRecentLogements(limit: 7));
  }
  
  /// Supprime un favori par son ID
  Future<void> removeFavorite(String propertyId) async {
    await _favoritesService.removeFavorite(propertyId);
  }
  
  /// Nombre total de favoris
  int get favoritesCount => enregistrements.length;
  
  /// Vérifie si la liste des favoris est vide
  bool get hasFavorites => enregistrements.isNotEmpty;
  
  /// Vérifie si la liste des vus récemment est vide
  bool get hasRecentlyViewed => vuRecemment.isNotEmpty;
}
