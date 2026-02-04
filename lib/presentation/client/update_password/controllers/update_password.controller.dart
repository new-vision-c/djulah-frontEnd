import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../../../app/config/app_config.dart';
import '../../../../infrastructure/navigation/route_names.dart';
import '../../../components/password_field.widget.dart';

class UpdatePasswordController extends GetxController {

  TextEditingController newPasswordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  RxBool isPasswordVisible = false.obs;
  RxInt limitCharPassword = 8.obs;
  RxString newPassword = ''.obs;
  RxString confirmPassword = ''.obs;


  @override
  void onInit() {
    super.onInit();
  }


  bool get isFormValid =>
      PasswordField.validatePassword(newPassword.value) == null &&
      PasswordField.validatePassword(confirmPassword.value) == null &&
      confirmPassword.value == newPassword.value;

  Future<void> goToSuccessPage() async{
    AppConfig.isLoadingApp.value=true;
    await Future.delayed(Duration(seconds: 2));
      Get.toNamed(
          RouteNames.sharedSuccessPage,
        arguments: {
            "description": "Votre mot de passe a été réinitialisé avec succès, retrounez à l’acceuil pour pouvoir vous connecter"
        }

      );
    AppConfig.isLoadingApp.value=false;
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

}
