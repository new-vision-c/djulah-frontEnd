import 'package:djulah/infrastructure/navigation/bindings/controllers/client.home.controller.binding.dart';
import 'package:get/get.dart';

import '../../../../presentation/client/dashboard/controllers/dashboard.controller.dart';
import '../../../../presentation/client/favoris/controllers/favoris.controller.dart';
import '../../../../presentation/client/home/controllers/home.controller.dart';
import '../../../../presentation/client/messages/controllers/messages.controller.dart';
import '../../../../presentation/client/profil/controllers/profil.controller.dart';
import '../../../../presentation/client/reservations/controllers/reservations.controller.dart';

class ClientDashboardControllerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DashboardController>(() => DashboardController());

    Get.lazyPut<HomeController>(() => HomeController());
    Get.lazyPut<ReservationsController>(() => ReservationsController());
    Get.lazyPut<FavorisController>(() => FavorisController());
    Get.lazyPut<MessagesController>(() => MessagesController());
    Get.lazyPut<ProfilController>(() => ProfilController());
  }
}