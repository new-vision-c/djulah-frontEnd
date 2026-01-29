import 'package:djulah/infrastructure/theme/client_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../controllers/reservation_steps.controller.dart';

class Step3Mobile extends GetView<ReservationStepsController> {
  const Step3Mobile({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20.r),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: Color(0xFFE8E8E8))
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Operator dropdown
          Text(
            "Opérateur de payement",
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w500,
              letterSpacing: -0.8.r,
              height: 20.sp / 16.sp,
              color: Colors.black,
            ),
          ),
          SizedBox(height: 8.h),
          Obx(() => Container(
            padding: EdgeInsets.symmetric(horizontal: 12.r, vertical: 2.r),
            decoration: BoxDecoration(
              color: Color(0xFFE8F7FC),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: controller.selectedOperator.value,
                isExpanded: true,
                icon: Icon(
                  Icons.keyboard_arrow_down,
                  color: Colors.black,
                  size: 24.r,
                ),
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w400,
                  letterSpacing: -0.48.r,
                  height: 20.sp / 16.sp,
                  color: ClientTheme.textTertiaryColor,
                ),
                items: controller.operators.map((String operator) {
                  return DropdownMenuItem<String>(
                    value: operator,
                    child: Text(operator),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  if (newValue != null) {
                    controller.selectedOperator.value = newValue;
                  }
                },
              ),
            ),
          )),
          SizedBox(height: 18.h),
          Divider(color: Color(0xFFE8E8E8), thickness: 1.r),
          SizedBox(height: 18.h),
          Text(
            "Numéro du payeur",
            style:  TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w500,
              letterSpacing: -0.8.r,
              height: 20.sp / 16.sp,
              color: Colors.black,
            ),
          ),
          SizedBox(height: 8.h),
          TextField(
            controller: controller.payerPhoneController,
            keyboardType: TextInputType.phone,
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
              color: Colors.black,
            ),
            decoration: InputDecoration(
              hintText: "Placeholder",
              hintStyle:TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w400,
                letterSpacing: -0.48.r,
                height: 20.sp / 16.sp,
                color: ClientTheme.textTertiaryColor,
              ),
              filled: true,
              fillColor: Color(0xFFE8F7FC),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.r),
                borderSide: BorderSide.none,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.r),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.r),
                borderSide: BorderSide(
                  color: ClientTheme.primaryColor,
                  width: 1.r,
                ),
              ),
              contentPadding: EdgeInsets.all(8.r),
            ),
          ),
        ],
      ),
    );
  }
}
