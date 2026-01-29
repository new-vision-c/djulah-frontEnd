import 'package:get/get.dart';

import '../../../../presentation/client/parametres/controllers/parametres.controller.dart';

class ClientParametresControllerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ParametresController>(
      () => ParametresController(),
    );
  }
}
