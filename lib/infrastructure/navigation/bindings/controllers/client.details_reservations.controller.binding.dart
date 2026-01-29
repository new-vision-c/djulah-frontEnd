import 'package:get/get.dart';

import '../../../../presentation/client/details_reservations/controllers/details_reservations.controller.dart';

class ClientDetailsReservationsControllerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DetailsReservationsController>(
      () => DetailsReservationsController(),
    );
  }
}
