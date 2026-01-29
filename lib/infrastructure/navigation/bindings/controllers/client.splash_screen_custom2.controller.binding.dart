import 'package:get/get.dart';

import '../../../../presentation/client/splash_screen_custom2/controllers/splash_screen_custom2.controller.dart';

class ClientSplashScreenCustom2ControllerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SplashScreenCustom2Controller>(
      () => SplashScreenCustom2Controller(),
    );
  }
}
