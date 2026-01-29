import 'package:get/get.dart';

import '../../../../presentation/client/Utilisation_donnees/controllers/Utilisation_donnees.controller.dart';

class ClientUtilisationDonneesControllerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<UtilisationDonneesController>(
      () => UtilisationDonneesController(),
    );
  }
}
