import 'package:get/get.dart';

import '../../../../presentation/client/home/controllers/home.controller.dart';

class ClientHomeControllerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HomeController>(
      () => HomeController(),
    );
  }
}
