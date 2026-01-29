import 'package:get/get.dart';

import '../../../../presentation/shared/successPage/controllers/success_page.controller.dart';

class SuccessPageControllerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SuccessPageController>(
      () => SuccessPageController(),
    );
  }
}
