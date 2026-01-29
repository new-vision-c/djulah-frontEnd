import 'package:djulah/presentation/client/securite/widgets/modifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import 'package:get/get.dart';

import '../../../infrastructure/theme/client_theme.dart';
import '../../components/buttons/secondary_button.widget.dart';
import '../components/app_bar.dart';
import 'controllers/securite.controller.dart';

class SecuriteScreen extends GetView<SecuriteController> {
  const SecuriteScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
            children: [
              AppBarCustom(title: "Securite"),
              Expanded(
                  child: Container(
                    padding: EdgeInsets.only(top: 20.h, right: 16.r, left: 16.r),
                    color: Color(0xFFF3F3F3),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          width: double.infinity,
                          padding: EdgeInsets.symmetric(
                              horizontal: 20.r, vertical: 28.r),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16.r),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [

                              Text(
                                "Mot de passe",
                                style: TextStyle(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: -0.8.r,
                                  height: 20.sp / 16.sp,
                                  color: Colors.black,
                                ),

                              ),
                              SizedBox(height: 4.h),
                              IntrinsicHeight(
                                child: Obx(() {
                                  return Row(
                                    crossAxisAlignment: CrossAxisAlignment
                                        .center,
                                    mainAxisAlignment: MainAxisAlignment
                                        .spaceBetween,
                                    children: [
                                      Text(
                                        controller.isCurrentPasswordVisible.value
                                            ? "*************"
                                            : "Montrer",
                                        style: TextStyle(
                                          fontSize: 16.sp,
                                          fontWeight: FontWeight.w500,
                                          letterSpacing: -0.48.r,
                                          height: 20.sp / 16.sp,
                                          color: Color(0xFF5E5E5E),
                                        ),

                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          controller.isCurrentPasswordVisible.value =
                                          !controller.isCurrentPasswordVisible.value;
                                        },
                                        child: Container(
                                          child: SvgPicture.asset(
                                            "assets/images/client/eye.svg",
                                            fit: BoxFit.cover,
                                            color: controller.isCurrentPasswordVisible
                                                .value
                                                ? ClientTheme.primaryColor
                                                : Colors.black,
                                            alignment: AlignmentGeometry.center,

                                          ),
                                        ),
                                      )
                                    ],
                                  );
                                }),
                              ),
                            ],
                          ),
                        ),
                        SecondaryButton(
                          onPressed: () {
                            Get.to(ModifierScreen());
                            },
                          text: "Modifier",
                          textColor: Colors.black,
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ],
                    ),
                  )
              )
            ]
        ),
      ),
    );
  }
}
