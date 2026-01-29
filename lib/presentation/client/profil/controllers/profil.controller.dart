import 'package:djulah/app/services/profile_image_service.dart';
import 'package:get/get.dart';

class ProfilController extends GetxController {
  final isLoading = true.obs;
  
  // Données du profil (simulées)
  final userName = ''.obs;
  final memberSince = ''.obs;
  
  // Service d'image de profil
  ProfileImageService get profileImageService => Get.find<ProfileImageService>();

  @override
  void onInit() {
    super.onInit();
    _loadData();
  }

  Future<void> _loadData() async {
    isLoading.value = true;
    await Future.delayed(const Duration(seconds: 2));
    
    // Simuler le chargement des données
    userName.value = 'Simo Kamto';
    memberSince.value = 'Membre depuis 2 ans';
    
    isLoading.value = false;
  }
  
  /// Ouvre la caméra par défaut, avec option galerie
  Future<void> pickProfileImage() async {
    await profileImageService.pickImageFromCamera();
  }
}
