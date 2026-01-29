import 'package:get/get.dart';

import '../../../../presentation/client/reservation_steps/controllers/reservation_steps.controller.dart';

class ClientReservationStepsControllerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ReservationStepsController>(
      () => ReservationStepsController(),
    );
  }
}
