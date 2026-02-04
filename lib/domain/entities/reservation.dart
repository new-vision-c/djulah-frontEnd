import 'package:djulah/domain/entities/logement.dart';
import 'package:djulah/domain/enums/status_reservation.dart';

class ReservationModel {
  final String id;
  final String title;
  final String date;
  final String dateRange;
  final String price;
  final String imagePath;
  final String status;
  final ReservationStatus statusEnum;
  final bool isCurrent;
  final bool isConfirmed;
  final String? hostName;
  final String? address;
  /// Propriété associée à la réservation (pour naviguer vers les détails)
  final Propriete? propriete;
  /// ID de la propriété (si propriete est null)
  final String? proprieteId;

  ReservationModel({
    required this.id,
    required this.title,
    required this.date,
    this.dateRange = '',
    required this.price,
    required this.imagePath,
    required this.status,
    this.statusEnum = ReservationStatus.en_attente,
    required this.isCurrent,
    this.isConfirmed = true,
    this.hostName,
    this.address,
    this.propriete,
    this.proprieteId,
  });

  /// Vérifie si la réservation permet de réserver (non annulée, non rejetée)
  bool get canBook => statusEnum == ReservationStatus.confirmer || 
                       statusEnum == ReservationStatus.en_attente;
  
  /// Vérifie si la réservation est rejetée
  bool get isRejected => statusEnum == ReservationStatus.rejeter;
}