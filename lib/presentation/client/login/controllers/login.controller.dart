import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../../../app/config/app_config.dart';
import '../../../../infrastructure/navigation/route_names.dart';

class LoginController extends GetxController {
  final ScrollController scrollController = ScrollController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  RxBool isPasswordVisible = false.obs;
  RxBool isEmailValid = true.obs;
  RxString email = ''.obs;
  RxInt limitCharPassword = 8.obs;
  RxString password = ''.obs;
  final RxBool startAnimation = false.obs;

  @override
  void onInit() {
    super.onInit();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      FocusManager.instance.primaryFocus?.unfocus();
    });
  }
  @override
  void onReady() {
    super.onReady();
    startAnimation.value = true;
  }




  bool get isFormValid => GetUtils.isEmail(email.value) &&
      password.value.length >= limitCharPassword.value;

  Future<void> goToHome() async {
    AppConfig.isLoadingApp.value = true;

    await Future.delayed(Duration(seconds: 2));
    Get.toNamed(
      RouteNames.clientHome,
      arguments: {
        "email": email.value,
      },
    );
    AppConfig.isLoadingApp.value = false;
  }
  Future<void> goToForgetPasswor() async {
    AppConfig.isLoadingApp.value = true;

    await Future.delayed(Duration(seconds: 2));
    Get.toNamed(
      RouteNames.clientForgetPassword,
    );
    AppConfig.isLoadingApp.value = false;
  }



  @override
  void onClose() {
    scrollController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
