import 'package:get/get.dart';

import '../../../../presentation/client/termes_utilisation/controllers/termes_utilisation.controller.dart';

class ClientTermesUtilisationControllerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TermesUtilisationController>(
      () => TermesUtilisationController(),
    );
  }
}
