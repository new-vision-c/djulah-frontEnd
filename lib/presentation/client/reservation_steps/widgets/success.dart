import 'package:djulah/presentation/client/dashboard/controllers/dashboard.controller.dart';
import 'package:djulah/presentation/components/buttons/secondary_button.widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

import '../../../../infrastructure/navigation/route_names.dart';
import '../../../../infrastructure/theme/client_theme.dart';
import '../../../components/buttons/primary_button.widget.dart';
import '../../../shared/successPage/controllers/success_page.controller.dart';

class SuccessReservation extends StatelessWidget{
  final controller= Get.put(SuccessPageController());

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SafeArea(
        minimum: EdgeInsets.only(
            left: 16.r, right: 16.r),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Transform.translate(
              offset: Offset(-0.6*width, 0),
              child: SizedBox(
                width: double.infinity,
                height: 468.36.h,
                child: Lottie.asset(
                  controller: controller.lottieController,
                  'assets/animation/success.json',
                  fit: BoxFit.cover,
                  onLoaded: controller.playShort,
                  repeat: false,
                ),
              ),
            ),
            SizedBox(height: 40.h),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              spacing: 8.r,
              children: [
                Text(
                  "C'est tout bon !" ,
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontSize: 24.sp,
                    fontStyle: FontStyle.normal,
                    fontWeight: FontWeight.w600,
                    letterSpacing: -1.2.r,
                    height: 32.sp / 24.sp,
                    color: Colors.black,
                  ),
                ),
                Text(
                  "La réservation à été faite avec succès, vous allez recevoir un message de votre hôte ",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontStyle: FontStyle.normal,
                    fontWeight: FontWeight.w400,
                    letterSpacing: -0.48.r,
                    height: 20.sp / 16.sp,
                    color: ClientTheme.textSecondaryColor,
                  ),
                ),
              ],
            ),
            Flexible(
                fit: FlexFit.loose,
                child: SizedBox(height: 122.h,)
            ),
            PrimaryButton(
              text: "Retourner l'accueil",
              onPressed: () {
                Get.back();
                Get.back();
              } ,
            ),
            SecondaryButton(
              text: "Voir mes réservations",
              onPressed: () {

              },
            ),
          ],
        ),
      ),
    );
  }
}