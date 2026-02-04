import 'package:djulah/domain/entities/auth/user_data.dart';
import 'package:djulah/domain/enums/auth_status.dart';
import 'package:djulah/infrastructure/services/auth_service.dart';
import 'package:get/get.dart';

/// Service de gestion du profil utilisateur avec cache
/// Permet de partager les données utilisateur entre différentes pages
/// sans refaire de requêtes inutiles au backend
class ProfileCacheService extends GetxService {
  final Rxn<UserData> _cachedUser = Rxn<UserData>();
  final RxBool _isLoading = false.obs;
  final RxBool _hasError = false.obs;
  
  /// Timestamp du dernier refresh
  DateTime? _lastRefresh;
  
  /// Durée de validité du cache (5 minutes)
  static const Duration _cacheValidity = Duration(minutes: 5);
  
  late final AuthService _authService;
  
  @override
  void onInit() {
    super.onInit();
    _authService = Get.find<AuthService>();
  }
  
  /// Données utilisateur en cache (null si pas encore chargé)
  UserData? get user => _cachedUser.value;
  
  /// Observable des données utilisateur
  Rxn<UserData> get userRx => _cachedUser;
  
  /// Indique si le chargement est en cours
  bool get isLoading => _isLoading.value;
  
  /// Observable du chargement
  RxBool get isLoadingRx => _isLoading;
  
  /// Indique si une erreur s'est produite
  bool get hasError => _hasError.value;
  
  /// Observable de l'erreur
  RxBool get hasErrorRx => _hasError;
  
  /// Vérifie si le cache est valide
  bool get _isCacheValid {
    if (_cachedUser.value == null || _lastRefresh == null) return false;
    return DateTime.now().difference(_lastRefresh!) < _cacheValidity;
  }
  
  /// Récupère les données utilisateur (depuis le cache si valide, sinon du backend)
  Future<UserData?> getUser({bool forceRefresh = false}) async {
    // Retourner le cache s'il est valide et pas de refresh forcé
    if (_isCacheValid && !forceRefresh) {
      return _cachedUser.value;
    }
    
    // Éviter les requêtes parallèles
    if (_isLoading.value) {
      // Attendre que le chargement en cours soit terminé
      await Future.doWhile(() async {
        await Future.delayed(const Duration(milliseconds: 50));
        return _isLoading.value;
      });
      return _cachedUser.value;
    }
    
    _isLoading.value = true;
    _hasError.value = false;
    
    try {
      final result = await _authService.getMe();
      
      if (result.status == ApiStatus.SUCCESS && result.entity != null) {
        _cachedUser.value = result.entity!.user;
        _lastRefresh = DateTime.now();
        return _cachedUser.value;
      } else {
        _hasError.value = true;
        return null;
      }
    } catch (e) {
      print("ProfileCacheService: Erreur lors du chargement: $e");
      _hasError.value = true;
      return null;
    } finally {
      _isLoading.value = false;
    }
  }
  
  /// Met à jour le cache avec de nouvelles données utilisateur
  /// Appelé après une mise à jour réussie (profil, avatar, etc.)
  void updateCache(UserData updatedUser) {
    _cachedUser.value = updatedUser;
    _lastRefresh = DateTime.now();
  }
  
  /// Invalide le cache (force un refresh au prochain appel)
  void invalidateCache() {
    _lastRefresh = null;
  }
  
  /// Vide complètement le cache (à appeler lors de la déconnexion)
  void clearCache() {
    _cachedUser.value = null;
    _lastRefresh = null;
  }
}
