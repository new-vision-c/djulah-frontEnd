import 'package:get/get.dart';

import '../../../../presentation/client/splash_screen_custom/controllers/splash_screen_custom.controller.dart';

class ClientSplashScreenCustomControllerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SplashScreenCustomController>(
      () => SplashScreenCustomController(),
    );
  }
}
