import 'package:get/get.dart';
import '../../../../domain/entities/reservation.dart';
import '../../../../domain/enums/status_reservation.dart';

class ReservationsController extends GetxController {
  final isLoading = true.obs;
  final selectedFilter = 0.obs;
  final reservations = <ReservationModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchReservations();
  }

  Future<void> fetchReservations() async {
    isLoading.value = true;
    await Future.delayed(const Duration(seconds: 2));
    reservations.value = [
      ReservationModel(
        id: 'res_r001',
        title: "Appartement à louer - Bonamoussadi, Douala",
        date: "17/11/2025",
        price: "50 000 XAF",
        imagePath: "assets/images/client/imagesSplash/1.jpg",
        status: "Confirmé",
        isCurrent: true,
      ),
      ReservationModel(
        id: 'res_r002',
        title: "Studio meublé - Akwa, Douala",
        date: "10/10/2024",
        price: "35 000 XAF",
        imagePath: "assets/images/client/imagesSplash/2.jpg",
        status: "Confirmé",
        isCurrent: false,
      ),
      ReservationModel(
        id: 'res_r003',
        title: "Villa de luxe - Bastos, Yaoundé",
        date: "20/12/2025",
        price: "150 000 XAF",
        imagePath: "assets/images/client/imagesSplash/4.jpg",
        status: "En attente",
        isCurrent: true,
      ),
      ReservationModel(
        id: 'res_r004',
        title: "Chambre moderne - Makepe, Douala",
        date: "05/01/2026",
        price: "25 000 XAF",
        imagePath: "assets/images/client/imagesSplash/2.jpg",
        status: "Confirmé",
        isCurrent: true,
      ),
      ReservationModel(
        id: 'res_r005',
        title: "Résidence meublée - Bonapriso, Douala",
        date: "14/02/2026",
        price: "80 000 XAF",
        imagePath: "assets/images/client/imagesSplash/4.jpg",
        status: "Confirmé",
        isCurrent: true,
      ),
      ReservationModel(
        id: 'res_r006',
        title: "Maison familiale - Nkolbisson, Yaoundé",
        date: "03/08/2025",
        price: "60 000 XAF",
        imagePath: "assets/images/client/imagesSplash/1.jpg",
        status: "Confirmé",
        isCurrent: false,
      ),
      ReservationModel(
        id: 'res_r007',
        title: "Appartement haut standing - Santa Barbara, Yaoundé",
        date: "11/11/2025",
        price: "120 000 XAF",
        imagePath: "assets/images/client/imagesSplash/3.jpg",
        status: "En attente",
        isCurrent: true,
      ),
      ReservationModel(
        id: 'res_r008',
        title: "Chambre étudiante - Ngoa Ekellé",
        date: "01/06/2024",
        price: "15 000 XAF",
        imagePath: "assets/images/client/imagesSplash/2.jpg",
        status: "Confirmé",
        isCurrent: false,
      ),
      ReservationModel(
        id: 'res_r009',
        title: "Chambre étudiante - Ngoa Ekellé",
        date: "01/06/2024",
        price: "15 000 XAF",
        imagePath: "assets/images/client/imagesSplash/2.jpg",
        status: "Confirmé",
        isCurrent: false,
      ),
      ReservationModel(
        id: 'res_r010',
        title: "Chambre étudiante - Ngoa Ekellé",
        date: "01/06/2024",
        price: "15 000 XAF",
        imagePath: "assets/images/client/imagesSplash/2.jpg",
        status: "Confirmé",
        statusEnum: ReservationStatus.confirmer,
        isCurrent: false,
      ),
      ReservationModel(
        id: 'res_r011',
        title: "Duplex moderne - Biyem-Assi, Yaoundé",
        date: "15/01/2026",
        price: "95 000 XAF",
        imagePath: "assets/images/client/imagesSplash/3.jpg",
        status: "Rejeté",
        statusEnum: ReservationStatus.rejeter,
        isCurrent: false,
      ),
      ReservationModel(
        id: 'res_r012',
        title: "Appartement standing - Deido, Douala",
        date: "20/01/2026",
        price: "70 000 XAF",
        imagePath: "assets/images/client/imagesSplash/1.jpg",
        status: "Annulé",
        statusEnum: ReservationStatus.annuler,
        isCurrent: false,
      ),
    ];
    isLoading.value = false;
  }

  List<ReservationModel> get filteredReservations {
    switch (selectedFilter.value) {
      case 0:
        return reservations.where((r) => r.status == "Confirmé").toList();
      case 1:
        return reservations.where((r) => r.status == "Annulé").toList();
      case 2:
        return reservations.where((r) => r.status == "En attente").toList();
      case 3:
        return reservations.where((r) => r.status == "Rejeté").toList();
      default:
        return reservations.toList();
    }
  }

  void setFilter(int index) async {
    if (selectedFilter.value == index) return;
    isLoading.value = true;
    selectedFilter.value = index;
    await Future.delayed(const Duration(milliseconds: 500));
    isLoading.value = false;
  }
  
  /// Méthode de rafraîchissement pour le pull-to-refresh
  Future<void> onRefresh() async {
    await fetchReservations();
  }
}
