import 'package:djulah/presentation/client/components/profil_avatar.dart';
import 'package:djulah/presentation/components/buttons/secondary_button.widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';

import '../../../generated/assets.dart';
import '../../../infrastructure/theme/client_theme.dart';
import '../components/app_bar.dart';
import 'controllers/informations_personnelles.controller.dart';

class InformationsPersonnellesScreen
    extends GetView<InformationsPersonnellesController> {
  const InformationsPersonnellesScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:  SafeArea(
        child: Column(
          children: [
            AppBarCustom(title: "Information personnelles"),
            Expanded(
                child:Container(
                  padding: EdgeInsets.only(top: 20.h,right: 16.r,left: 16.r),
                  color: Color(0xFFF3F3F3),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(horizontal: 20.r,vertical: 28.r),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16.r),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Center(child: ProfilAvatar()),
                            SizedBox(height: 18.h),
                            Text(
                              "Nom d'utilisateur",
                              style: TextStyle(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w600,
                                letterSpacing: -0.8.r,
                                height: 20.sp / 16.sp,
                                color: Colors.black,
                              ),

                            ),
                            SizedBox(height: 4.h),
                            Text(
                              "Simo Kamto",
                              style: TextStyle(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w500,
                                letterSpacing: -0.48.r,
                                height: 20.sp / 16.sp,
                                color: Color(0xFF5E5E5E),
                              ),

                            ),
                            SizedBox(height: 20.h),
                            Text(
                              "Email",
                              style: TextStyle(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w600,
                                letterSpacing: -0.8.r,
                                height: 20.sp / 16.sp,
                                color: Colors.black,
                              ),
                            ),
                            SizedBox(height: 4.h),
                            Text(
                              "kamtolionel@gmail.com",
                              style: TextStyle(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w500,
                                letterSpacing: -0.48.r,
                                height: 20.sp / 16.sp,
                                color: Color(0xFF5E5E5E),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SecondaryButton(
                          onPressed: () {
                            //Todo
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
