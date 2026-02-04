import 'package:djulah/infrastructure/navigation/route_names.dart';
import 'package:djulah/infrastructure/theme/client_theme.dart';
import 'package:djulah/presentation/client/historique/widgets/card.dart';
import 'package:djulah/presentation/components/shimmer_box.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';

import '../components/app_bar.dart';
import 'controllers/historique.controller.dart';

class HistoriqueScreen extends GetView<HistoriqueController> {
  const HistoriqueScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
             AppBarCustom(title: 'profil_screen.history'.tr),
            Expanded(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16.r),
                color: const Color(0xFFF3F3F3),
                child: Obx(() {
                  if (controller.isLoading.value) {
                    return ListView.builder(
                      padding: EdgeInsets.symmetric(vertical: 20.r),
                      itemCount: 4,
                      itemBuilder: (context, index) => _buildShimmerItem(),
                    );
                  }

                  return RefreshIndicator(
                    onRefresh: controller.onRefresh,
                    child: ListView.builder(
                      padding: EdgeInsets.symmetric(vertical: 20.r),
                      physics: const BouncingScrollPhysics(),
                      itemCount: controller.historiqueItems.length,
                      itemBuilder: (context, index) {
                      final item = controller.historiqueItems[index];
                      
                      bool showHeader = index == 0 ||
                                       controller.historiqueItems[index - 1].dateHeader != item.dateHeader;

                      return Column(
                        children: [
                          if (showHeader) ...[
                            if (index > 0) SizedBox(height: 16.h),
                            Text(
                              item.dateHeader,
                              style: TextStyle(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w400,
                                letterSpacing: -0.42.r,
                                height: 20.sp / 14.sp,
                                color: const Color(0xFF4B4B4B),
                              )
                            ),
                            SizedBox(height: 16.h),
                          ],
                          CardCustom(
                            imagesPath: item.imagePath,
                            title: item.title,
                            Status: Row(
                              children: [
                                Icon(
                                  item.isConfirmed ? Icons.check : Icons.close,
                                  color: item.isConfirmed ? const Color(0xFF4CAF50) : ClientTheme.errorColor,
                                  size: 18.r,
                                ),
                                SizedBox(width: 4.w),
                                Text(
                                  item.isConfirmed ? 'reservations.confirmed'.tr : 'reservations.cancelled'.tr,
                                  style: TextStyle(
                                    fontSize: 12.sp,
                                    color: item.isConfirmed ? const Color(0xFF4CAF50) : ClientTheme.errorColor,
                                    fontWeight: FontWeight.w500,
                                    letterSpacing: -0.8.r,
                                    height: 20.sp / 16.sp,
                                  ),
                                ),
                              ],
                            ),
                            date: item.dateRange,
                            price: item.price,
                            onTap: () {
                              Get.toNamed(
                                RouteNames.clientDetailsReservations,
                                arguments: item.reservation,
                              );
                            },
                          ),
                          SizedBox(height: 8.h),
                        ],
                      );
                    },
                    ),
                  );
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildShimmerItem() {
    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      padding: EdgeInsets.all(12.r),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ShimmerBox(width: 80.r, height: 80.r, borderRadius: 8.r),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ShimmerBox(width: 150.w, height: 16.sp, borderRadius: 4.r),
                SizedBox(height: 8.h),
                ShimmerBox(width: 100.w, height: 12.sp, borderRadius: 4.r),
                SizedBox(height: 12.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ShimmerBox(width: 60.w, height: 14.sp, borderRadius: 4.r),
                    ShimmerBox(width: 70.w, height: 16.sp, borderRadius: 4.r),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
