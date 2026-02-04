import 'package:djulah/app/config/app_config.dart';
import 'package:djulah/app/services/profile_cache_service.dart';
import 'package:djulah/domain/enums/auth_status.dart';
import 'package:djulah/infrastructure/shared/app_enums.dart';
import 'package:djulah/infrastructure/ui/app_flushbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class InformationsPersonnellesController extends GetxController {
  final isLoading = true.obs;
  final isUpdating = false.obs;
  final hasError = false.obs;
  
  // Données utilisateur
  final userName = ''.obs;
  final userEmail = ''.obs;
  final userAvatar = Rxn<String>();
  
  // Controller pour l'édition du nom
  final fullnameController = TextEditingController();
  final isEditMode = false.obs;
  

  late final ProfileCacheService _cacheService;

  @override
  void onInit() {
    super.onInit();
    _cacheService = Get.find<ProfileCacheService>();
    _loadFromCache();
  }
  
  @override
  void onClose() {
    fullnameController.dispose();
    super.onClose();
  }

  /// Charge les données depuis le cache ou le backend
  Future<void> _loadFromCache() async {
    isLoading.value = true;
    hasError.value = false;
    
    try {
      // Utiliser le service de cache centralisé
      final user = await _cacheService.getUser();
      
      if (user != null) {
        // _updateFromUser(user);
      } else {
        hasError.value = true;
      }
    } catch (e) {
      print("Erreur lors du chargement des informations: $e");
      hasError.value = true;
    } finally {
      isLoading.value = false;
    }
  }
  
  // void _updateFromUser(UserData user) {
  //   userName.value = user.fullname;
  //   userEmail.value = user.email;
  //   userAvatar.value = user.avatar;
  //   fullnameController.text = user.fullname;
  // }
  
  void startEditing() {
    fullnameController.text = userName.value;
    isEditMode.value = true;
  }
  
  void cancelEditing() {
    fullnameController.text = userName.value;
    isEditMode.value = false;
  }
  
  // Future<void> saveChanges() async {
  //   final newFullname = fullnameController.text.trim();
  //
  //   if (newFullname.isEmpty) {
  //     final context = Get.context;
  //     if (context != null) {
  //       AppFlushBar.show(
  //         context,
  //         message: 'profile.name_empty'.tr,
  //         type: MessageType.error,
  //       );
  //     }
  //     return;
  //   }
  //
  //   if (newFullname == userName.value) {
  //     isEditMode.value = false;
  //     return;
  //   }
  //
  //   FocusManager.instance.primaryFocus?.unfocus();
  //
  //   AppConfig.showLoading(message: 'Mise à jour en cours...');
  //
  //   try {
  //     final result = await _authService.updateProfile(fullname: newFullname);
  //
  //     if (result.status == UpdateProfileStatus.SUCCESS && result.entity != null) {
  //       // Mise à jour locale
  //       userName.value = result.entity!.user.fullname;
  //
  //       // Mise à jour du cache global
  //       _cacheService.updateCache(result.entity!.user);
  //
  //       isEditMode.value = false;
  //
  //       AppConfig.hideLoading();
  //
  //       final context = Get.context;
  //       if (context != null) {
  //         AppFlushBar.show(
  //           context,
  //           message: 'profile.update_success'.tr,
  //           type: MessageType.success,
  //         );
  //       }
  //     } else {
  //       AppConfig.hideLoading();
  //       _showErrorForStatus(result.status);
  //     }
  //   } catch (e) {
  //     print("Erreur lors de la mise à jour du profil: $e");
  //     AppConfig.hideLoading();
  //     final context = Get.context;
  //     if (context != null) {
  //       AppFlushBar.show(
  //         context,
  //         message: 'common.error_occurred'.tr,
  //         type: MessageType.error,
  //       );
  //     }
  //   }
  // }
  
  void _showErrorForStatus(UpdateProfileStatus status) {
    String message;
    switch (status) {
      case UpdateProfileStatus.UNAUTHORIZED:
        message = 'common.session_expired'.tr;
        break;
      case UpdateProfileStatus.NETWORK_ERROR:
        message = 'common.network_error'.tr;
        break;
      default:
        message = 'common.error_occurred'.tr;
    }
    
    final context = Get.context;
    if (context != null) {
      AppFlushBar.show(
        context,
        message: message,
        type: MessageType.error,
      );
    }
  }
}
