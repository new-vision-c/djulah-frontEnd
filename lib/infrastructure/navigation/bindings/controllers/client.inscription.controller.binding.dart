import 'package:get/get.dart';

import '../../../../presentation/client/inscription/controllers/inscription.controller.dart';

class ClientInscriptionControllerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<InscriptionController>(
      () => InscriptionController(),
    );
  }
}
