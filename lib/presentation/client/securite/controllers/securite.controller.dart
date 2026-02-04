import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../app/config/app_config.dart';
import '../../../../domain/enums/auth_status.dart';
import '../../../../infrastructure/services/auth_service.dart';
import '../../../../infrastructure/shared/app_enums.dart';
import '../../../../infrastructure/ui/app_flushbar.dart';
import '../../../components/password_field.widget.dart';

class SecuriteController extends GetxController {
  final currentPasswordController = TextEditingController();
  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final currentPassword = "".obs;
  final newPassword = "".obs;
  final confirmPassword = "".obs;
  RxBool isCurrentPasswordVisible = true.obs;
  RxBool isNewPasswordVisible = true.obs;
  RxBool isConfirmPasswordVisible = true.obs;
  
  final isUpdating = false.obs;
  
  late final AuthService _authService;

  @override
  void onInit() {
    super.onInit();
    _authService = Get.find<AuthService>();
  }

  bool get isFormValid =>
      currentPassword.value.isNotEmpty &&
      PasswordField.validatePassword(newPassword.value) == null &&
      newPassword.value == confirmPassword.value;

  @override
  void onReady() {
    super.onReady();
  }

  Future<void> enregistrer() async {
    if (!isFormValid) return;
    
    isUpdating.value = true;
    AppConfig.isLoadingApp.value = true;
    
    try {
      final result = await _authService.updatePassword(
        currentPassword: currentPassword.value,
        newPassword: newPassword.value,
      );
      
      if (result.status == UpdatePasswordStatus.SUCCESS) {
        // Réinitialiser les champs
        currentPasswordController.clear();
        newPasswordController.clear();
        confirmPasswordController.clear();
        currentPassword.value = "";
        newPassword.value = "";
        confirmPassword.value = "";
        
        Get.back();
        final context = Get.context;
        if (context != null) {
          AppFlushBar.show(
            context,
            message: 'security.password_updated'.tr,
            type: MessageType.success,
          );
        }
      } else {
        _showErrorForStatus(result.status);
      }
    } catch (e) {
      print("Erreur lors de la mise à jour du mot de passe: $e");
      final context = Get.context;
      if (context != null) {
        AppFlushBar.show(
          context,
          message: 'common.error_occurred'.tr,
          type: MessageType.error,
        );
      }
    } finally {
      isUpdating.value = false;
      AppConfig.isLoadingApp.value = false;
    }
  }
  
  void _showErrorForStatus(UpdatePasswordStatus status) {
    String message;
    switch (status) {
      case UpdatePasswordStatus.INVALID_CURRENT_PASSWORD:
        message = 'security.invalid_current_password'.tr;
        break;
      case UpdatePasswordStatus.WEAK_PASSWORD:
        message = 'security.weak_password'.tr;
        break;
      case UpdatePasswordStatus.UNAUTHORIZED:
        message = 'common.session_expired'.tr;
        break;
      case UpdatePasswordStatus.NETWORK_ERROR:
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

  @override
  void onClose() {
    currentPasswordController.dispose();
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }
}
