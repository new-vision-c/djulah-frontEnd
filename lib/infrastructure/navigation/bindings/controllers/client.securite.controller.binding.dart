import 'package:get/get.dart';

import '../../../../presentation/client/securite/controllers/securite.controller.dart';

class ClientSecuriteControllerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SecuriteController>(
      () => SecuriteController(),
    );
  }
}
