import 'package:djulah/app/config/app_config.dart';
import 'package:djulah/infrastructure/navigation/bindings/controllers/client.verification_identity.controller.binding.dart';
import 'package:djulah/infrastructure/navigation/route_names.dart';
import 'package:djulah/presentation/client/verification_identity/verification_identity.screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class InscriptionController extends GetxController {
  final ScrollController scrollController = ScrollController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  RxBool isPasswordVisible = false.obs;
  RxBool isEmailValid = true.obs;
  RxString selectedValue = "".obs;
  TextEditingController nameController = TextEditingController();
  RxString email = ''.obs;
  RxString name = ''.obs;
  RxString password = ''.obs;
  final RxBool startAnimation = false.obs;
  final RxBool atBottom = false.obs;

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
      name.value.isNotEmpty &&
      password.value.length >= AppConfig.limitCharPassword.value;

  Future<void> goToVerificationEmail() async {
    AppConfig.isLoadingApp.value = true;

    await Future.delayed(Duration(seconds: 2));
    Get.toNamed(
      RouteNames.clientVerificationIdentity,
      arguments: {
        "email": email.value,
      },
    );
    AppConfig.isLoadingApp.value = false;
  }



  @override
  void onClose() {
    scrollController.dispose();
    emailController.dispose();
    passwordController.dispose();
    nameController.dispose();
    super.onClose();
  }
}
