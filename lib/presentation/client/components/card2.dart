import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../domain/entities/logement.dart';
import '../../../infrastructure/navigation/route_names.dart';
import '../../../infrastructure/theme/client_theme.dart';
import '../../components/carousel_fade/carousel_fade.widget.dart';
import '../favoris/controllers/favoris.controller.dart';
import 'animated_heart_button.dart';

class AppCard2 extends StatelessWidget {
  final EnregistrementModel item;
  
  const AppCard2({super.key, required this.item});
  
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        final propriete = MockupLogements.logements.firstWhereOrNull(
          (p) => p.id == item.id
        );
        if (propriete != null) {
          Get.toNamed(RouteNames.clientDetailsLogement, arguments: propriete);
        }
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12.r),
                child: CarouselFadeWidget(
                  width: double.infinity,
                  height: 362.h,
                  showIndicator: true,
                  children: item.images.map((path) => Image.asset(
                    path,
                    fit: BoxFit.cover,
                  )).toList(),
                ),
              ),
              Positioned(
                top: 12.r,
                right: 12.r,
                child: AnimatedHeartButton(
                  propertyId: item.id,
                  size: 24,
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  spacing: 4.r,
                  children: [
                    Text(
                      item.title,
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                        height: 20.sp / 16.sp,
                        letterSpacing: -0.8.r,
                      ),
                    ),
                    Text(
                      item.ownerName,
                      style: TextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w400,
                        color: const Color(0XFF5E5E5E),
                        height: 16.sp / 12.sp,
                        letterSpacing: -0.36.r,
                      ),
                    ),
                    Text(
                      item.details,
                      style: TextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w400,
                        color: const Color(0XFF5E5E5E),
                        height: 16.sp / 12.sp,
                        letterSpacing: -0.36.r,
                      ),
                    ),
                    Text(
                      item.ownerName,
                      style: TextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w400,
                        color: const Color(0XFF5E5E5E),
                        height: 16.sp / 12.sp,
                        letterSpacing: -0.36.r,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.star_border,
                size: 12.r,
                color: const Color(0xFFF6BC2F),
                fontWeight: FontWeight.w600,
              ),
              SizedBox(width: 4.w),
              Text(
                item.rating.toString(),
                style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w400,
                  color: const Color(0XFF5E5E5E),
                  height: 20.sp / 16.sp,
                  letterSpacing: -0.36.r,
                ),
              ),
            ],
          ),
          SizedBox(height: 8.h),
          Row(
            spacing: 4.r,
            children: [
              Icon(
                Icons.monetization_on_outlined,
                size: 16.r,
                color: ClientTheme.primaryColor,
              ),
              Text(
                item.price,
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                  height: 20.sp / 16.sp,
                  letterSpacing: -0.8.r,
                ),
              )
            ],
          )
        ],
      ),
    );
  }

}