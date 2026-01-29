import 'package:get/get.dart';

import '../../../../presentation/client/update_password/controllers/update_password.controller.dart';

class ClientUpdatePasswordControllerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<UpdatePasswordController>(
      () => UpdatePasswordController(),
    );
  }
}
