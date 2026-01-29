import 'package:get/get.dart';

import '../../../../presentation/client/historique/controllers/historique.controller.dart';

class ClientHistoriqueControllerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HistoriqueController>(
      () => HistoriqueController(),
    );
  }
}
