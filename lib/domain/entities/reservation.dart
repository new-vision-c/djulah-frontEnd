class ReservationModel {
  final String id;
  final String title;
  final String date;
  final String dateRange;
  final String price;
  final String imagePath;
  final String status;
  final bool isCurrent;
  final bool isConfirmed;
  final String? hostName;
  final String? address;

  ReservationModel({
    required this.id,
    required this.title,
    required this.date,
    this.dateRange = '',
    required this.price,
    required this.imagePath,
    required this.status,
    required this.isCurrent,
    this.isConfirmed = true,
    this.hostName,
    this.address,
  });
}