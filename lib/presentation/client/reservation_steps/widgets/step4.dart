import 'package:djulah/infrastructure/theme/client_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../generated/assets.dart';
import '../controllers/reservation_steps.controller.dart';

class Step4 extends GetView<ReservationStepsController> {
  const Step4({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Main reservation card
          Container(
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
                        "Appartement a louer - Bonamoussadi Douala",
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
                          "16-21 dec. 2025",
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w500,
                            letterSpacing: -0.42.r,
                            height: 20.sp / 14.sp,
                            color: Color(0xFF4B4B4B),
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
                      onPressed: () {},
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
                            color: Color(0xFF4B4B4B),
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
                      onPressed: () {},
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
                  "Si vous annulez avant l'arrivee prevue le 16 decembre, vous aurez droit a un remboursement partiel",
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
                  onTap: () {},
                  child: Text(
                    "Consulter les conditions completes",
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
          ),
          
          SizedBox(height: 16.h),
          
          // Payment method card
          Container(
            padding: EdgeInsets.all(20.r),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16.r),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Mode de payement",
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w500,
                          letterSpacing: -0.42.r,
                          height: 20.sp / 14.sp,
                          color: Color(0xFF4B4B4B),
                        ),
                      ),
                      SizedBox(height: 4.r),
                      Obx(() => _buildPaymentInfoText()),
                    ],
                  ),
                ),
                Icon(
                  Icons.chevron_right,
                  size: 24.r,
                  color: Colors.black,
                ),
              ],
            )
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentInfoText() {
    String paymentInfo = "";
    if (controller.selectedPaymentMethod.value == 1) {
      final phone = controller.payerPhoneController.text;
      final operatorName = controller.selectedOperator.value;
      paymentInfo = phone.isNotEmpty ? "$operatorName  $phone" : operatorName;
    } else {
      final cardNumber = controller.cardNumberController.text;
      if (cardNumber.isNotEmpty) {
        final cleanNumber = cardNumber.replaceAll(' ', '');
        final lastFour = cleanNumber.length > 4 
            ? cleanNumber.substring(cleanNumber.length - 4) 
            : cleanNumber;
        paymentInfo = "Carte  ****$lastFour";
      } else {
        paymentInfo = "Carte de credit";
      }
    }
    return Text(
      paymentInfo,
      style: TextStyle(
        fontSize: 14.sp,
        fontWeight: FontWeight.w500,
        letterSpacing: -0.42.r,
        height: 20.sp / 14.sp,
        color: Colors.black,
      ),
    );
  }
}