import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../../../app/config/app_config.dart';
import '../../../../infrastructure/navigation/route_names.dart';

class SecuriteController extends GetxController {
  final currentPasswordController =TextEditingController();
  final newPasswordController =TextEditingController();
  final confirmPasswordController =TextEditingController();
  final currentPassword ="".obs;
  final newPassword ="".obs;
  final confirmPassword ="".obs;
  RxBool isCurrentPasswordVisible = true.obs;
  RxBool isNewPasswordVisible = true.obs;
  RxBool isConfirmPasswordVisible = true.obs;

  @override
  void onInit() {
    super.onInit();
  }

  bool get isFormValid =>
      newPassword.value.length >= AppConfig.limitCharPassword.value &&
          newPassword.value==confirmPassword.value;

  @override
  void onReady() {
    super.onReady();
  }

  Future<void> enregistrer() async{
    AppConfig.isLoadingApp.value=true;
    await Future.delayed(Duration(seconds: 2));
    Get.back();
    AppConfig.isLoadingApp.value=false;
  }

  @override
  void onClose() {
    super.onClose();
  }
}
