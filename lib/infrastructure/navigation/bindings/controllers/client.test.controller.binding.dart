import 'package:get/get.dart';

import '../../../../presentation/client/test/controllers/test.controller.dart';

class ClientTestControllerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TestController>(
      () => TestController(),
    );
  }
}
