import 'package:djulah/infrastructure/theme/client_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../generated/assets.dart';
import '../controllers/reservation_steps.controller.dart';

class Step2 extends GetView<ReservationStepsController> {
  const Step2({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.r, vertical: 8.r),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Credit/Debit Card option
          Obx(() => _buildPaymentOption(
            index: 0,
            isSelected: controller.selectedPaymentMethod.value == 0,
            leading: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(
                  Assets.clientVisa,
                  height: 24.r,
                  width: 36.r,
                  fit: BoxFit.contain,
                ),
                SizedBox(width: 8.r),
                Image.asset(
                  Assets.clientMasterCard,
                  height: 24.r,
                  width: 36.r,
                  fit: BoxFit.contain,
                ),
              ],
            ),
            title: "Carte de crédit ou de débit",
            onTap: () => controller.selectPaymentMethod(0),
          )),
          
          Divider(color: Color(0xFFE8E8E8), thickness: 1.r),
          
          // Mobile payment option
          Obx(() => _buildPaymentOption(
            index: 1,
            isSelected: controller.selectedPaymentMethod.value == 1,
            leading: Image.asset(
              Assets.clientSmartphone,
              height: 24.r,
              width: 24.r,
              fit: BoxFit.contain,
            ),
            title: "Payement mobile",
            onTap: () => controller.selectPaymentMethod(1),
          )),
        ],
      ),
    );
  }

  Widget _buildPaymentOption({
    required int index,
    required bool isSelected,
    required Widget leading,
    required String title,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 16.h),
        child: Row(
          children: [
            leading,
            SizedBox(width: 12.r),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w500,
                  letterSpacing: -0.8.r,
                  height: 20.sp / 14.sp,
                  color: Colors.black,
                ),
              ),
            ),
            Container(
              width: 24.r,
              height: 24.r,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected ? ClientTheme.primaryColor : Color(0xFF5E5E5E),
                  width: 2.r,
                ),
                color: isSelected ? ClientTheme.primaryColor : Colors.transparent,
              ),
              child: isSelected
                  ? Icon(
                      Icons.check,
                      size: 16.r,
                      color: Colors.white,
                    )
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}
