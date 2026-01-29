import 'package:djulah/infrastructure/theme/client_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../generated/assets.dart';
import '../controllers/reservation_steps.controller.dart';

class Step1 extends GetView<ReservationStepsController> {
  const Step1({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20.r),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Property info row
          Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12.r),
                child: Image.asset(
                  Assets.clientImagesSplash1,
                  height: 64.r,
                  width: 64.r,
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(width: 17.r),
              Expanded(
                child: Text(
                  "Appartement à louer - Bonamoussadi Douala",
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
            ],
          ),
          SizedBox(height: 18.h),
          Divider(color: Color(0xFFE8E8E8), thickness: 1.r),
          SizedBox(height: 18.h),
          
          // Date section
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Date",
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w500,
                      letterSpacing: -0.8.r,
                      height: 20.sp / 16.sp,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 4.r),
                  Text(
                    "16-21 déc. 2025",
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w400,
                      letterSpacing: -0.42.r,
                      height: 20.sp / 14.sp,
                      color: ClientTheme.textTertiaryColor,
                    ),
                  ),
                ],
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
                  //todo
                },
                child: Text(
                  "Modifier",
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                    letterSpacing: -0.7.r,
                    height: 20.sp / 14.sp,
                    color: Colors.black,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 18.h),
          Divider(color: Color(0xFFE8E8E8), thickness: 1.r),
          SizedBox(height: 18.h),
          
          // Price section
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Prix total",
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w500,
                      letterSpacing: -0.8.r,
                      height: 20.sp / 16.sp,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 4.r),
                  Text(
                    "50 000 XAF",
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                      letterSpacing: -0.42.r,
                      height: 20.sp / 14.sp,
                      color: ClientTheme.textTertiaryColor,
                    ),
                  ),
                ],
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
                  //todo
                },
                child: Text(
                  "Details",
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                    letterSpacing: -0.7.r,
                    height: 20.sp / 14.sp,
                    color: Colors.black,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 18.h),
          Divider(color: Color(0xFFE8E8E8), thickness: 1.r),
          SizedBox(height: 18.h),
          
          // Cancellation policy
          Text(
            "Si vous annulez avant l'arrivée prévue le 16 décembre, vous aurez droit a un remboursement partiel",
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
              letterSpacing: -0.42.r,
              height: 20.sp / 14.sp,
              color: Color(0xFF4B4B4B),
            ),
          ),
          SizedBox(height: 4.h),
          GestureDetector(
            onTap: () {
              //Todo
            },
            child: Text(
              "Consulter les conditions complètes",
              style: TextStyle(
                fontSize: 14.sp,
                decoration: TextDecoration.underline,
                fontWeight: FontWeight.w500,
                letterSpacing: -0.7.r,
                height: 20.sp / 14.sp,
                color: Colors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
