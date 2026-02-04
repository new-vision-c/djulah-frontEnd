import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../app/config/app_config.dart';
import '../../../../app/services/profile_cache_service.dart';
import '../../../../datas/local_storage/app_storage.dart';
import '../../../../domain/enums/auth_status.dart';
import '../../../../infrastructure/navigation/route_names.dart';
import '../../../../infrastructure/services/auth_service.dart';
import '../../../../infrastructure/shared/app_enums.dart';
import '../../../../infrastructure/ui/app_flushbar.dart';

class PolitiqueConfidentialiteController extends GetxController {
  final passwordController = TextEditingController();
  final isPasswordVisible = false.obs;
  
  late final AuthService _authService;

  @override
  void onInit() {
    super.onInit();
    _authService = Get.find<AuthService>();
  }

  @override
  void onClose() {
    passwordController.dispose();
    super.onClose();
  }

  void showDeleteAccountDialog() {
    passwordController.clear();
    isPasswordVisible.value = false;
    
    Get.dialog(
      AlertDialog(
        title: const Text(
          'Supprimer mon compte',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.red,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Cette action est irréversible. Toutes vos données seront supprimées définitivement.',
              style: TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 16),
            const Text(
              'Entrez votre mot de passe pour confirmer:',
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 8),
            Obx(() => TextField(
              controller: passwordController,
              obscureText: !isPasswordVisible.value,
              decoration: InputDecoration(
                hintText: 'Mot de passe',
                border: const OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: Icon(
                    isPasswordVisible.value 
                        ? Icons.visibility_off 
                        : Icons.visibility,
                  ),
                  onPressed: () => isPasswordVisible.toggle(),
                ),
              ),
            )),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Annuler'),
          ),
          ElevatedButton(
            onPressed: () => _deleteAccount(),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Supprimer'),
          ),
        ],
      ),
      barrierDismissible: false,
    );
  }

  Future<void> _deleteAccount() async {
    final password = passwordController.text.trim();
    
    if (password.isEmpty) {
      final context = Get.context;
      if (context != null) {
        AppFlushBar.show(
          context,
          message: 'security.enter_password'.tr,
          type: MessageType.error,
        );
      }
      return;
    }
    
    Get.back();
    AppConfig.showLoading(message: 'Suppression en cours...');
    
    try {
      final result = await _authService.deleteAccount(password: password);
      
      if (result.status == DeleteAccountStatus.SUCCESS) {
        final storage = Get.find<AppStorage>();
        await storage.clearAuth();
        Get.find<ProfileCacheService>().clearCache();
        
        AppConfig.hideLoading();
        
        final context = Get.context;
        if (context != null) {
          AppFlushBar.show(
            context,
            message: 'account.deleted_success'.tr,
            type: MessageType.success,
          );
        }
        
        Get.offAllNamed(RouteNames.clientLogin);
      } else {
        AppConfig.hideLoading();
        _showErrorForStatus(result.status);
      }
    } catch (e) {
      print("Erreur lors de la suppression du compte: $e");
      AppConfig.hideLoading();
      final context = Get.context;
      if (context != null) {
        AppFlushBar.show(
          context,
          message: 'common.error_occurred'.tr,
          type: MessageType.error,
        );
      }
    }
  }
  
  void _showErrorForStatus(DeleteAccountStatus status) {
    String message;
    switch (status) {
      case DeleteAccountStatus.INVALID_PASSWORD:
        message = 'account.invalid_password'.tr;
        break;
      case DeleteAccountStatus.UNAUTHORIZED:
        message = 'common.session_expired'.tr;
        break;
      case DeleteAccountStatus.NETWORK_ERROR:
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
