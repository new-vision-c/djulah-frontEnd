import 'package:djulah/infrastructure/navigation/route_names.dart';
import 'package:djulah/infrastructure/theme/client_theme.dart';
import 'package:djulah/presentation/client/reservations/widgets/not_found.dart';
import 'package:djulah/presentation/components/shimmer_box.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../domain/entities/reservation.dart';
import 'controllers/reservations.controller.dart';

class ReservationsScreen extends GetView<ReservationsController> {
  const ReservationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        elevation: 0,
        toolbarHeight: 100.h,
        title: SafeArea(
          top: true,
          bottom: false,
          child: Padding(
            padding:  EdgeInsets.only(top:  16.r),
            child: Text(
              'reservations.title'.tr,
              style: TextStyle(
                color: Colors.black,
                fontSize: 28.sp,
                fontWeight: FontWeight.w600,
                letterSpacing: -1.4.r,
                height: 36.sp / 28.sp,
              ),
            ),
          ),
        ),
        centerTitle: false,
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(50.h),
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.only(left: 16.r, bottom: 15.h),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(
                bottom: BorderSide(
                  color: const Color(0xFFE8E8E8),
                  width: 1.r,
                ),
              ),
            ),
            child: Wrap(
              spacing: 8.w,
              runSpacing: 8.h,
              children: [
                _buildFilterChip('reservations.confirmed'.tr, 0, const Color(0xFF4CAF50)),
                _buildFilterChip('reservations.cancelled'.tr, 1, const Color(0xFFF44336)),
                _buildFilterChip('reservations.pending'.tr, 2, const Color(0xFFFFC107)),
                _buildFilterChip('reservations.rejected'.tr, 3, const Color(0xFF9E9E9E)),
              ],
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: Obx(() {
          if (controller.isLoading.value) {
            return ListView.builder(
              itemCount: 3,
              itemBuilder: (context, index) => _buildShimmerItem(),
            );
          }
          final filteredList = controller.filteredReservations;
          if (filteredList.isEmpty) {
            return NotFound();
          }

          return RefreshIndicator(
            onRefresh: controller.onRefresh,
            child: ListView.builder(
              itemCount: filteredList.length,
              itemBuilder: (context, index) {
                final reservation = filteredList[index];
                return _buildReservationItem(reservation);
              },
            ),
          );
        }),
      ),
    );
  }
  Color _getStatusColor(String status) {
    switch (status) {
      case "Confirmé":
        return const Color(0xFF4CAF50); // Vert
      case "Annulé":
        return const Color(0xFFF44336); // Rouge
      case "En attente":
        return const Color(0xFFFFC107); // Jaune/Orange
      case "Rejeté":
        return const Color(0xFF9E9E9E); // Gris
      default:
        return Colors.grey;
    }
  }

  IconData _getStatusIcon(String status) {
    switch (status) {
      case "Confirmé":
        return Icons.check;
      case "Annulé":
        return Icons.cancel;
      case "En attente":
        return Icons.access_time;
      case "Rejeté":
        return Icons.block;
      default:
        return Icons.help_outline;
    }
  }

  Widget _buildFilterChip(String label, int index, Color activeColor) {
    return Obx(() {
      final isSelected = controller.selectedFilter.value == index;
      return GestureDetector(
        onTap: () => controller.setFilter(index),
        child: Container(
          width: 100.w,
          padding: EdgeInsets.all(10.r),
          decoration: BoxDecoration(
            color: isSelected ? activeColor : const Color(0xFFF2F2F2),
            borderRadius: BorderRadius.circular(100.r),
          ),
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                color: isSelected ? Colors.white : const Color(0xFF5E5E5E),
                fontSize: 16.sp,
                fontWeight: FontWeight.w500,
                letterSpacing: -0.8.r,
                height: 20.sp / 16.sp,
              ),
            ),
          ),
        ),
      );
    });
  }

  Widget _buildReservationItem(ReservationModel reservation) {
    return GestureDetector(
      onTap: () {
        Get.toNamed(RouteNames.clientDetailsReservations, arguments: reservation);
      },
      child: Container(
        decoration: BoxDecoration(
            border: Border.all(
                color: const Color(0xFFE8E8E8),
                style: BorderStyle.solid,
                width: 1.r),
            borderRadius: BorderRadius.circular(8.r)),
        margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        padding: EdgeInsets.all(12.r),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 64.r,
              height: 70.r,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12.r),
                image: DecorationImage(
                    fit: BoxFit.cover,
                    image: AssetImage(reservation.imagePath)),
              ),
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          reservation.title,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w600,
                            letterSpacing: -0.8.r,
                            height: 1.2,
                          ),
                        ),
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            _getStatusIcon(reservation.status),
                            size: 18.r,
                            color: _getStatusColor(reservation.status),
                          ),
                          SizedBox(width: 4.w),
                          Text(
                            reservation.status,
                            style: TextStyle(
                              fontSize: 12.sp,
                              color: _getStatusColor(reservation.status),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                  SizedBox(height: 10.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        reservation.date,
                        style: TextStyle(
                          color: const Color(0xFF5E5E5E),
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w500,
                          letterSpacing: -0.42.r,
                        ),
                      ),
                      Text(
                        reservation.price,
                        style: TextStyle(
                          color: ClientTheme.primaryColor,
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                          letterSpacing: -0.9.r,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildShimmerItem() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      padding: EdgeInsets.all(12.r),
      decoration: BoxDecoration(
          border: Border.all(color: const Color(0xFFE8E8E8)),
          borderRadius: BorderRadius.circular(8.r)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ShimmerBox(width: 64.r, height: 70.r, borderRadius: 12.r),
          SizedBox(width: 16.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: ShimmerBox(width: double.infinity, height: 16.h, borderRadius: 4.r),
                    ),
                    SizedBox(width: 8.w),
                    ShimmerBox(width: 70.w, height: 16.h, borderRadius: 4.r),
                  ],
                ),
                SizedBox(height: 10.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ShimmerBox(width: 80.w, height: 14.h, borderRadius: 4.r),
                    ShimmerBox(width: 90.w, height: 16.h, borderRadius: 4.r),
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
