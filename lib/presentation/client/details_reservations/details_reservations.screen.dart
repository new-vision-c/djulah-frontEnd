import 'package:djulah/generated/assets.dart';
import 'package:djulah/infrastructure/navigation/route_names.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';

import '../../../infrastructure/theme/client_theme.dart';
import '../../components/buttons/primary_button.widget.dart';
import '../../components/buttons/secondary_button.widget.dart';
import '../../components/shimmer_box.dart';
import '../components/app_bar.dart';
import '../historique/widgets/card.dart';
import 'controllers/details_reservations.controller.dart';

class DetailsReservationsScreen extends GetView<DetailsReservationsController> {
  const DetailsReservationsScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
            children: [
              AppBarCustom(title: 'reservations.details'.tr),
              Expanded(
                  child: Obx(() {
                    if (controller.isLoading.value || controller.reservation.value == null) {
                      return _buildLoadingState();
                    }
                    
                    final reservation = controller.reservation.value!;
                    
                    return Container(
                      color: Color(0xFFF3F3F3),
                      padding: EdgeInsets.only(top: 20.h, right: 16.r, left: 16.r),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            width: double.infinity,
                            padding: EdgeInsets.all(20.r),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16.r),
                            ),
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    spacing: 17.r,
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(12.r),
                                        child: Image.asset(reservation.imagePath, height: 64.r,width: 64.r,fit: BoxFit.cover,),
                                      ),
                                      Expanded(
                                        child: Text(
                                          reservation.title,
                                          maxLines: 2,
                                          style: TextStyle(
                                            fontSize: 16.sp,
                                            fontWeight: FontWeight.w500,
                                            letterSpacing: -0.8.r,
                                            height: 20.sp / 16.sp,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ),
                                      ElevatedButton(
                                          style: ButtonStyle(
                                            backgroundColor: WidgetStateProperty.all(Color(0xFFE8E8E8)),
                                            elevation: WidgetStateProperty.all(0),
                                            shape: WidgetStateProperty.all(RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(8.r),
                                            )),
                                          ),
                                          onPressed: () {
                                            // Naviguer avec la propriété associée si disponible
                                            if (reservation.propriete != null) {
                                              Get.toNamed(
                                                RouteNames.clientDetailsLogement,
                                                arguments: reservation.propriete,
                                              );
                                            } else {
                                              // Fallback: créer une propriété temporaire depuis les données de réservation
                                              Get.toNamed(
                                                RouteNames.clientDetailsLogement,
                                                arguments: controller.getProprieteFallback(),
                                              );
                                            }
                                          },
                                          child: Text('reservations.details'.tr,
                                            style: TextStyle(
                                              fontSize: 14.sp,
                                              fontWeight: FontWeight.w500,
                                              letterSpacing: -0.7.r,
                                              height: 20.sp / 14.sp,
                                              color: Colors.black,
                                            ),
                                          )
                                      )

                                    ],
                                  ),
                                SizedBox(height: 18.h),
                                Divider(
                                  color: Color(0xFFE8E8E8),
                                  thickness: 1.r,
                                ),
                                SizedBox(height: 18.h),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Column(
                                      spacing: 4.r,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text('reservations.date'.tr,
                                          style: TextStyle(
                                            fontSize: 16.sp,
                                            fontWeight: FontWeight.w500,
                                            letterSpacing: -0.8.r,
                                            height: 20.sp / 16.sp,
                                            color: Colors.black,

                                          ),
                                        ),
                                        Text(
                                          reservation.dateRange.isNotEmpty 
                                              ? reservation.dateRange 
                                              : reservation.date,
                                          style:  TextStyle(
                                            fontSize: 14.sp,
                                            fontWeight: FontWeight.w500,
                                            letterSpacing: -0.42.r,
                                            height: 20.sp / 16.sp,
                                            color: Color(0xFF4B4B4B),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Container(
                                      child: ElevatedButton(
                                        style: ButtonStyle(
                                          backgroundColor: WidgetStateProperty.all(Color(0xFFE8E8E8)),
                                          elevation: WidgetStateProperty.all(0),
                                          shape: WidgetStateProperty.all(RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(8.r),
                                          )),
                                        ),
                                          onPressed: (){

                                          },
                                          child: Text("Modifier",
                                            style: TextStyle(
                                              fontSize: 14.sp,
                                              fontWeight: FontWeight.w500,
                                              letterSpacing: -0.7.r,
                                              height: 20.sp / 14.sp,
                                              color: Colors.black,
                                            ),
                                          )
                                      ),
                                    )

                                  ],
                                ),
                                SizedBox(height: 18.h),
                                Divider(
                                  color: Color(0xFFE8E8E8),
                                  thickness: 1.r,
                                ),
                                SizedBox(height: 18.h),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Column(
                                      spacing: 4.r,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text('reservations.total_price'.tr,
                                          style: TextStyle(
                                            fontSize: 16.sp,
                                            fontWeight: FontWeight.w500,
                                            letterSpacing: -0.8.r,
                                            height: 20.sp / 16.sp,
                                            color: Colors.black,

                                          ),
                                        ),
                                        Text(
                                          reservation.price,
                                          style:  TextStyle(
                                            fontSize: 14.sp,
                                            fontWeight: FontWeight.w500,
                                            letterSpacing: -0.42.r,
                                            height: 20.sp / 16.sp,
                                            color: Color(0xFF4B4B4B),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Container(
                                      child: ElevatedButton(
                                          style: ButtonStyle(
                                            backgroundColor: WidgetStateProperty.all(Color(0xFFE8E8E8)),
                                            elevation: WidgetStateProperty.all(0),
                                            shape: WidgetStateProperty.all(RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(8.r),
                                            )),
                                          ),
                                          onPressed: (){

                                          },
                                          child: Text('common.modify'.tr,
                                            style: TextStyle(
                                              fontSize: 14.sp,
                                              fontWeight: FontWeight.w500,
                                              letterSpacing: -0.7.r,
                                              height: 20.sp / 14.sp,
                                              color: Colors.black,
                                            ),
                                          )
                                      ),
                                    )

                                  ],
                                ),
                                SizedBox(height: 18.h),
                                Divider(
                                  color: Color(0xFFE8E8E8),
                                  thickness: 1.r,
                                ),
                                Text(
                                  'reservations.cancel_warning'.trParams({'date': reservation.date}),
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w500,
                                    letterSpacing: -0.42.r,
                                    height: 20.sp / 14.sp,
                                    color: Color(0xFF4B4B4B),
                                  ),
                                ),
                                Text(
                                  'reservations.view_full_conditions'.tr,
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    decoration: TextDecoration.underline,
                                    fontWeight: FontWeight.w500,
                                    letterSpacing: -0.7.r,
                                    height: 20.sp / 14.sp,
                                    color: Colors.black,
                                  ),
                                ),
                              ]),
                        ),
                        Column(
                          spacing: 12.r,
                          children: [
                            PrimaryButton(
                              text: reservation.isConfirmed 
                                  ? 'reservations.cancel_reservation'.tr 
                                  : 'reservations.book_again'.tr,
                              isEnabled: true,
                              onPressed: () async {
                              },
                            ),
                            SecondaryButton(
                              onPressed: () {
                              },
                              text: 'reservations.report_issue'.tr,
                              textColor: Colors.black,
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                  })
              )
            ]
        ),
      )
    );
  }

  Widget _buildLoadingState() {
    return Container(
      color: Color(0xFFF3F3F3),
      padding: EdgeInsets.only(top: 20.h, right: 16.r, left: 16.r),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(20.r),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16.r),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    ShimmerBox(width: 64.r, height: 64.r, borderRadius: 12.r),
                    SizedBox(width: 17.r),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ShimmerBox(width: double.infinity, height: 16.sp, borderRadius: 4.r),
                          SizedBox(height: 8.h),
                          ShimmerBox(width: 150.w, height: 16.sp, borderRadius: 4.r),
                        ],
                      ),
                    ),
                    SizedBox(width: 17.r),
                    ShimmerBox(width: 70.w, height: 36.h, borderRadius: 8.r),
                  ],
                ),
                SizedBox(height: 18.h),
                Divider(color: Color(0xFFE8E8E8), thickness: 1.r),
                SizedBox(height: 18.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ShimmerBox(width: 50.w, height: 16.sp, borderRadius: 4.r),
                        SizedBox(height: 4.h),
                        ShimmerBox(width: 120.w, height: 14.sp, borderRadius: 4.r),
                      ],
                    ),
                    ShimmerBox(width: 70.w, height: 36.h, borderRadius: 8.r),
                  ],
                ),
                SizedBox(height: 18.h),
                Divider(color: Color(0xFFE8E8E8), thickness: 1.r),
                SizedBox(height: 18.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ShimmerBox(width: 70.w, height: 16.sp, borderRadius: 4.r),
                        SizedBox(height: 4.h),
                        ShimmerBox(width: 100.w, height: 14.sp, borderRadius: 4.r),
                      ],
                    ),
                    ShimmerBox(width: 70.w, height: 36.h, borderRadius: 8.r),
                  ],
                ),
                SizedBox(height: 18.h),
                Divider(color: Color(0xFFE8E8E8), thickness: 1.r),
                SizedBox(height: 8.h),
                ShimmerBox(width: double.infinity, height: 14.sp, borderRadius: 4.r),
                SizedBox(height: 4.h),
                ShimmerBox(width: 200.w, height: 14.sp, borderRadius: 4.r),
                SizedBox(height: 8.h),
                ShimmerBox(width: 180.w, height: 14.sp, borderRadius: 4.r),
              ],
            ),
          ),
          Column(
            spacing: 12.r,
            children: [
              ShimmerBox(width: double.infinity, height: 52.h, borderRadius: 12.r),
              ShimmerBox(width: double.infinity, height: 52.h, borderRadius: 12.r),
            ],
          ),
        ],
      ),
    );
  }
}
