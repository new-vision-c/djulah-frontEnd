import 'package:get/get.dart';

import '../../../../presentation/client/informations_personnelles/controllers/informations_personnelles.controller.dart';

class ClientInformationsPersonnellesControllerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<InformationsPersonnellesController>(
      () => InformationsPersonnellesController(),
    );
  }
}
