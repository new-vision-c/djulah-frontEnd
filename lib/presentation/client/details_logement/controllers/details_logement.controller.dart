import 'package:djulah/datas/local_storage/favorites_storage_service.dart';
import 'package:djulah/datas/local_storage/recently_viewed_storage_service.dart';
import 'package:djulah/domain/entities/logement.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';

class DetailsLogementController extends GetxController {
  final count = 0.obs;
  final isFavorite = false.obs;
  final isLoadingFavorite = false.obs;
  
  FavoritesStorageService get _favoritesService => Get.find<FavoritesStorageService>();
  
  RecentlyViewedStorageService get _recentlyViewedService => Get.find<RecentlyViewedStorageService>();
  
  Propriete? get propriete => Get.arguments as Propriete?;
  
  @Deprecated('Utiliser propriete à la place')
  Propriete? get logement => propriete;
  
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
    
    ever(_favoritesService.favoriteIds, (_) => _syncFavoriteState());
  }
  
  void _syncFavoriteState() {
    if (propriete != null) {
      isFavorite.value = _favoritesService.isFavorite(propriete!.id);
    }
  }
  
  void _loadFavoriteState() {
    if (propriete != null) {
      isFavorite.value = _favoritesService.isFavorite(propriete!.id);
    }
  }
  
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
