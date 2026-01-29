import 'package:get/get.dart';

import '../../../../presentation/client/profil/controllers/profil.controller.dart';

class ClientProfilControllerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ProfilController>(
      () => ProfilController(),
    );
  }
}
