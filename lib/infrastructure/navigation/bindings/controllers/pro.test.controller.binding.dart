import 'package:get/get.dart';

import '../../../../presentation/pro/test/controllers/test.controller.dart';

class ProTestControllerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TestController>(
      () => TestController(),
    );
  }
}
