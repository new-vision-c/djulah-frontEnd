import 'package:get/get.dart';

import '../../../../presentation/client/forget_password/controllers/forget_password.controller.dart';

class ClientForgetPasswordControllerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ForgetPasswordController>(
      () => ForgetPasswordController(),
    );
  }
}
