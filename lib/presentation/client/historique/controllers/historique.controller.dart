import 'package:djulah/domain/entities/reservation.dart';
import 'package:get/get.dart';

class HistoriqueModel {
  final String dateHeader;
  final ReservationModel reservation;

  HistoriqueModel({
    required this.dateHeader,
    required this.reservation,
  });
  
  // Convenience getters
  String get title => reservation.title;
  String get dateRange => reservation.dateRange;
  String get price => reservation.price;
  String get imagePath => reservation.imagePath;
  bool get isConfirmed => reservation.isConfirmed;
}

class HistoriqueController extends GetxController {
  final historiqueItems = <HistoriqueModel>[].obs;
  final isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    _loadHistorique();
  }

  Future<void> _loadHistorique() async {
    isLoading.value = true;
    // Simulation du délai de chargement
    await Future.delayed(const Duration(seconds: 2));
    
    historiqueItems.assignAll([
      HistoriqueModel(
        dateHeader: "Aujourd'hui",
        reservation: ReservationModel(
          id: 'res_001',
          title: "Appartement à louer - Bonamoussadi Douala",
          date: "16 déc. 2025",
          dateRange: "16-21 déc. 2025",
          price: "50 000 XAF",
          imagePath: "assets/images/client/imagesSplash/1.jpg",
          status: "Confirmé",
          isCurrent: true,
          isConfirmed: true,
          hostName: "Chris Kody",
          address: "Bonamoussadi, Douala",
        ),
      ),
      HistoriqueModel(
        dateHeader: "Aujourd'hui",
        reservation: ReservationModel(
          id: 'res_002',
          title: "Studio Meublé - Akwa",
          date: "10 déc. 2025",
          dateRange: "10-15 déc. 2025",
          price: "35 000 XAF",
          imagePath: "assets/images/client/imagesSplash/2.jpg",
          status: "Confirmé",
          isCurrent: false,
          isConfirmed: true,
          hostName: "Marie L.",
          address: "Akwa, Douala",
        ),
      ),
      HistoriqueModel(
        dateHeader: "21 déc. 2025",
        reservation: ReservationModel(
          id: 'res_003',
          title: "Villa de luxe - Bastos",
          date: "01 déc. 2025",
          dateRange: "01-05 déc. 2025",
          price: "150 000 XAF",
          imagePath: "assets/images/client/imagesSplash/3.jpg",
          status: "Annulée",
          isCurrent: false,
          isConfirmed: false,
          hostName: "Jean P.",
          address: "Bastos, Yaoundé",
        ),
      ),
      HistoriqueModel(
        dateHeader: "15 déc. 2025",
        reservation: ReservationModel(
          id: 'res_004',
          title: "Chambre d'hôte - Logpom",
          date: "20 nov. 2025",
          dateRange: "20-25 nov. 2025",
          price: "20 000 XAF",
          imagePath: "assets/images/client/imagesSplash/4.jpg",
          status: "Confirmé",
          isCurrent: false,
          isConfirmed: true,
          hostName: "Sophie M.",
          address: "Logpom, Douala",
        ),
      ),
    ]);
    
    isLoading.value = false;
  }
}
