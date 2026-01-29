import 'package:get/get.dart';

import '../../../../presentation/client/details_logement/controllers/details_logement.controller.dart';

class ClientDetailsLogementControllerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DetailsLogementController>(
      () => DetailsLogementController(),
    );
  }
}
