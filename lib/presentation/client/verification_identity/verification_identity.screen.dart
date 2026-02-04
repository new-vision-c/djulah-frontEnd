import 'package:djulah/infrastructure/theme/client_theme.dart';
import 'package:djulah/presentation/components/buttons/secondary_button.widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';

import '../../components/CounterDown.dart';
import '../../components/buttons/primary_button.widget.dart';
import 'Widgets/pinput.dart';
import 'controllers/verification_identity.controller.dart';

class VerificationIdentityScreen
    extends GetView<VerificationIdentityController> {
  const VerificationIdentityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: Colors.white,
      body: SafeArea(
        minimum: EdgeInsets.only(
            left: 16.r, right: 16.r, top: 64.r,),
        child: Column(

          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    GestureDetector(
                      onTap: (){
                        FocusScope.of(context).unfocus();
                        Get.back();
                      },
                      child: Icon(
                        Icons.arrow_back,
                        color: Colors.black,
                        size: 30.r,
                      ),
                    )
                  ],
                ),
                SizedBox(height: 16.r,),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'verification.title'.tr,
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
                    SizedBox(height: 8.r,),
                    Obx(() {
                      return Padding(
                        padding: EdgeInsets.only(right: 30.r),
                        child: RichText(
                            text: TextSpan(
                                style: TextStyle(
                                  fontSize: 16.sp,
                                  fontFamily: "Geist",
                                  fontStyle: FontStyle.normal,
                                  fontWeight: FontWeight.w400,
                                  letterSpacing: -0.48.r,
                                  height: 20.sp / 16.sp,
                                  color: ClientTheme.textSecondaryColor,
                                ),
                                children: [
                                  TextSpan(
                                      text: "${'verification.subtitle'.tr} "
                                  ),
                                  TextSpan(
                                      text: "${controller.email.value} ",
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.w500,
                                        letterSpacing: -0.8.r,
                                      )
                                  ),
                                  TextSpan(
                                      text: 'verification.subtitleSecure'.tr
                                  ),
                                ]
                            )
                        ),
                      );
                    }),
                    SizedBox(height: 40.r,),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  spacing: 10.r,
                  children: [
                    Text(
                      'verification.codeLabel'.tr,
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontStyle: FontStyle.normal,
                        fontWeight: FontWeight.w600,
                        letterSpacing: -0.9.r,
                        height: 24.sp / 18.sp,
                        color: Colors.black,
                      ),
                    ),
                    PinInputWidget(),
                    Row(
                      children: [
                        Text(
                          "${'verification.resendIn'.tr} ",
                          style: TextStyle(
                            fontSize: 12.sp,
                            fontStyle: FontStyle.normal,
                            fontWeight: FontWeight.w400,
                            letterSpacing: -0.36.r,
                            height: 16.sp / 12.sp,
                              color: ClientTheme.textTertiaryColor
                          ),
                        ),
                        CountdownTimer(
                          tag: controller.timerTag,
                          minutes: 5,
                          onTick: (timeString) {
                            print('Temps restant: $timeString');
                          },
                          onComplete: controller.onTimerComplete,
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
            Column(
              spacing: 8.r,
              mainAxisSize: MainAxisSize.min,
              children: [
                Obx(() => PrimaryButton(
                  text: 'common.next'.tr,
                  isEnabled: controller.isPinComplete.value && !controller.canResend.value,
                  disabledColor: ClientTheme.buttonDisabledColor,
                  onPressed: () async {
                    FocusScope.of(context).unfocus();
                    await controller.goToSuccessPage();
                  },
                )),
                Obx(() => SecondaryButton(
                  text: 'common.resend'.tr,
                  isEnabled: controller.canResend.value,
                  activeColor: ClientTheme.primaryColor,
                  disabledColor: ClientTheme.textDisabledColor,
                  onPressed: controller.resendCode,
                ))
              ],
            ),
          ],
        ),
      ),
    );
  }
}
