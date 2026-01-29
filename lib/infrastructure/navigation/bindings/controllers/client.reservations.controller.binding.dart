import 'package:get/get.dart';

import '../../../../presentation/client/reservations/controllers/reservations.controller.dart';

class ClientReservationsControllerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ReservationsController>(
      () => ReservationsController(),
    );
  }
}
