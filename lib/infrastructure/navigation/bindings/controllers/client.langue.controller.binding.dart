import 'package:get/get.dart';

import '../../../../presentation/client/langue/controllers/langue.controller.dart';

class ClientLangueControllerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LangueController>(
      () => LangueController(),
    );
  }
}
