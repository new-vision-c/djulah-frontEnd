import 'package:djulah/domain/entities/logement.dart';
import 'package:djulah/domain/entities/reservation.dart';
import 'package:djulah/domain/enums/status_reservation.dart';
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
      // Obtenir une propriété mockup pour les tests
      final mockPropriete = MockupLogements.logements.isNotEmpty 
          ? MockupLogements.logements.first 
          : null;
      
      // Default reservation for testing avec une propriété associée
      reservation.value = ReservationModel(
        id: 'default',
        title: mockPropriete?.title ?? "Appartement à louer - Bonamoussadi Douala",
        date: "16 déc. 2025",
        dateRange: "16-21 déc. 2025",
        price: mockPropriete?.priceText ?? "50 000 XAF",
        imagePath: mockPropriete?.imagePath ?? "assets/images/client/imagesSplash/1.jpg",
        status: "Confirmé",
        statusEnum: ReservationStatus.confirmer,
        isCurrent: true,
        isConfirmed: true,
        propriete: mockPropriete,
        proprieteId: mockPropriete?.id,
      );
    }
    isLoading.value = false;
  }

  /// Crée une propriété fallback depuis les données de réservation
  Propriete? getProprieteFallback() {
    final res = reservation.value;
    if (res == null) return null;
    
    // Si propriété disponible, la retourner
    if (res.propriete != null) return res.propriete;
    
    // Sinon, chercher par ID dans les mockups
    if (res.proprieteId != null) {
      final found = MockupLogements.logements.firstWhereOrNull(
        (p) => p.id == res.proprieteId,
      );
      if (found != null) return found;
    }
    
    // Fallback: retourner la première propriété disponible
    return MockupLogements.logements.isNotEmpty 
        ? MockupLogements.logements.first 
        : null;
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
