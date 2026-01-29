import 'package:djulah/domain/entities/reservation.dart';
import 'package:get/get.dart';

class DetailsReservationsController extends GetxController {
  final Rx<ReservationModel?> reservation = Rx<ReservationModel?>(null);
  final isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    _loadReservation();
  }

  void _loadReservation() {
    final args = Get.arguments;
    if (args != null && args is ReservationModel) {
      reservation.value = args;
    } else {
      // Default reservation for testing
      reservation.value = ReservationModel(
        id: 'default',
        title: "Appartement à louer - Bonamoussadi Douala",
        date: "16 déc. 2025",
        dateRange: "16-21 déc. 2025",
        price: "50 000 XAF",
        imagePath: "assets/images/client/imagesSplash/1.jpg",
        status: "Confirmé",
        isCurrent: true,
        isConfirmed: true,
      );
    }
    isLoading.value = false;
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }
}
