import 'package:djulah/app/services/profile_cache_service.dart';
import 'package:djulah/app/services/profile_image_service.dart';
import 'package:djulah/domain/entities/auth/user_data.dart';
import 'package:get/get.dart';

class ProfilController extends GetxController {
  final isLoading = true.obs;
  final hasError = false.obs;
  
  // Données du profil avec valeurs par défaut
  final userName = 'Inconnu'.obs;
  final userEmail = ''.obs;
  final userAvatar = Rxn<String>();
  final memberSince = 'Non membre'.obs;
  
  // Service d'image de profil
  ProfileImageService get profileImageService => Get.find<ProfileImageService>();
  
  // Service de cache du profil
  late final ProfileCacheService _cacheService;

  @override
  void onInit() {
    super.onInit();
    _cacheService = Get.find<ProfileCacheService>();
    _loadUserData();
  }

  /// Charge les données utilisateur depuis le cache ou le backend
  Future<void> _loadUserData() async {
    isLoading.value = true;
    hasError.value = false;
    
    try {
      final user = await _cacheService.getUser();
      
      if (user != null) {
        _updateUserFromEntity(user);
      } else {
        hasError.value = true;
      }
    } catch (e) {
      print("Erreur lors du chargement du profil: $e");
      hasError.value = true;
    } finally {
      isLoading.value = false;
    }
  }
  
  /// Met à jour les observables depuis les données utilisateur
  void _updateUserFromEntity(UserData user) {
    // Mettre à jour uniquement si les valeurs ne sont pas vides
    if (user.fullname.isNotEmpty) {
      userName.value = user.fullname;
    }
    if (user.email.isNotEmpty) {
      userEmail.value = user.email;
    }
    userAvatar.value = user.avatar;
    
    // Calculer "Membre depuis X"
    if (user.createdAt != null) {
      memberSince.value = _formatMemberSince(user.createdAt!);
    } else {
      memberSince.value = 'Membre';
    }
  }
  
  /// Formate la durée depuis l'inscription
  String _formatMemberSince(DateTime createdAt) {
    final now = DateTime.now();
    final difference = now.difference(createdAt);
    
    if (difference.inDays >= 365) {
      final years = (difference.inDays / 365).floor();
      return 'Membre depuis ${years} an${years > 1 ? 's' : ''}';
    } else if (difference.inDays >= 30) {
      final months = (difference.inDays / 30).floor();
      return 'Membre depuis ${months} mois';
    } else if (difference.inDays >= 1) {
      return 'Membre depuis ${difference.inDays} jour${difference.inDays > 1 ? 's' : ''}';
    } else {
      return 'Nouveau membre';
    }
  }
  
  /// Rafraîchit les données depuis le backend (force refresh)
  Future<void> refreshUserData() async {
    isLoading.value = true;
    hasError.value = false;
    
    try {
      final user = await _cacheService.getUser(forceRefresh: true);
      
      if (user != null) {
        _updateUserFromEntity(user);
      } else {
        hasError.value = true;
      }
    } catch (e) {
      print("Erreur lors du refresh du profil: $e");
      hasError.value = true;
    } finally {
      isLoading.value = false;
    }
  }
  
  /// Ouvre la caméra par défaut, avec option galerie
  Future<void> pickProfileImage() async {
    await profileImageService.pickImageFromCamera();
  }
}
