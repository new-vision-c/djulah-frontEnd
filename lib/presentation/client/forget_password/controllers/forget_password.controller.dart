import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../../../app/config/app_config.dart';
import '../../../../infrastructure/navigation/route_names.dart';

class ForgetPasswordController extends GetxController {
  RxString email = ''.obs;
  TextEditingController emailController = TextEditingController();


  bool get isFormValid => GetUtils.isEmail(email.value) ;


  @override
  void onInit() {
    super.onInit();
  }


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
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

}
