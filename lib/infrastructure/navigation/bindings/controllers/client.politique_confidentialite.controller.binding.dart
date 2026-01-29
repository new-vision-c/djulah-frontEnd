import 'package:get/get.dart';

import '../../../../presentation/client/politique_confidentialite/controllers/politique_confidentialite.controller.dart';

class ClientPolitiqueConfidentialiteControllerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PolitiqueConfidentialiteController>(
      () => PolitiqueConfidentialiteController(),
    );
  }
}
