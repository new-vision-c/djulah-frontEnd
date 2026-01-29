import 'package:djulah/datas/local_storage/favorites_storage_service.dart';
import 'package:djulah/datas/local_storage/recently_viewed_storage_service.dart';
import 'package:djulah/domain/entities/logement.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';

class DetailsLogementController extends GetxController {
  final count = 0.obs;
  final isFavorite = false.obs;
  final isLoadingFavorite = false.obs;
  
  /// Service de stockage des favoris
  FavoritesStorageService get _favoritesService => Get.find<FavoritesStorageService>();
  
  /// Service de stockage des vus récemment
  RecentlyViewedStorageService get _recentlyViewedService => Get.find<RecentlyViewedStorageService>();
  
  // Récupérer la propriété passée en argument depuis la navigation
  Propriete? get propriete => Get.arguments as Propriete?;
  
  /// Alias pour rétrocompatibilité
  @Deprecated('Utiliser propriete à la place')
  Propriete? get logement => propriete;
  
  /// Toggle l'état favori avec persistence locale
  Future<void> toggleFavorite() async {
    if (propriete == null || isLoadingFavorite.value) return;
    
    isLoadingFavorite.value = true;
    
    try {
      final newState = await _favoritesService.toggleFavorite(propriete!);
      isFavorite.value = newState;
    } finally {
      isLoadingFavorite.value = false;
    }
  }
  
  Future<void> shareLogement() async {
    if (propriete == null) return;
    
    final String proprieteId = propriete!.id;
    const String baseUrl = 'https://djulah.com/propriete';
    final String shareLink = '$baseUrl/$proprieteId';
    
    await Share.share(
      'Découvrez cette superbe propriété sur Djulah!\n\n${propriete!.title}\n${propriete!.priceText}\n\n$shareLink',
      subject: propriete!.title,
    );
  }
  
  @override
  void onInit() {
    super.onInit();
    _loadFavoriteState();
    _trackRecentlyViewed();
    
    // Écouter les changements dans les favoris pour synchroniser l'état du coeur
    ever(_favoritesService.favoriteIds, (_) => _syncFavoriteState());
  }
  
  /// Synchronise l'état favori quand les favoris changent ailleurs
  void _syncFavoriteState() {
    if (propriete != null) {
      isFavorite.value = _favoritesService.isFavorite(propriete!.id);
    }
  }
  
  /// Charge l'état favori depuis le stockage local
  void _loadFavoriteState() {
    if (propriete != null) {
      isFavorite.value = _favoritesService.isFavorite(propriete!.id);
    }
  }
  
  /// Ajoute la propriété aux vus récemment
  void _trackRecentlyViewed() {
    if (propriete != null) {
      _recentlyViewedService.addToRecentlyViewed(propriete!.id);
    }
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  void increment() => count.value++;
}
