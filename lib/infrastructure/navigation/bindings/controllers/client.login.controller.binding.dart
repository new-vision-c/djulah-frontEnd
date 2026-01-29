import 'package:get/get.dart';

import '../../../../presentation/client/login/controllers/login.controller.dart';

class ClientLoginControllerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LoginController>(
      () => LoginController(),
    );
  }
}
