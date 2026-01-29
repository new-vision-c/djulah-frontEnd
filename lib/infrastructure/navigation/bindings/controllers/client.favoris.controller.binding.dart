import 'package:get/get.dart';

import '../../../../presentation/client/favoris/controllers/favoris.controller.dart';

class ClientFavorisControllerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<FavorisController>(
      () => FavorisController(),
    );
  }
}
