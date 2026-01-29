import 'package:djulah/infrastructure/theme/client_theme.dart';
import 'package:djulah/presentation/components/buttons/primary_button.widget.dart';
import 'package:djulah/presentation/components/buttons/secondary_button.widget.dart';
import 'package:djulah/presentation/components/buttons/text_link_button.widget.dart';
import 'package:djulah/presentation/components/carousel_fade/carousel_fade.widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'controllers/splash_screen_custom.controller.dart';

class SplashScreenCustomScreen extends GetView<SplashScreenCustomController> {
  const SplashScreenCustomScreen({super.key});
  @override
  Widget build(BuildContext context) {
    double h=MediaQuery.of(context).size.height;
    double w=MediaQuery.of(context).size.width;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.startEntrance();
    });
    return Scaffold(
      body: Center(
        child:SafeArea(
            minimum:  EdgeInsets.only(
              top:48.r,
              left: 0.05*w,
              right: 0.05*w,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                 SizedBox(
                  height: h/2,
                  width: double.infinity,
                  child: Stack(
                    alignment: Alignment.topCenter,
                    children: [
                      Obx(
                        () => AnimatedOpacity(
                          duration: const Duration(milliseconds: 350),
                          curve: Curves.easeInOut,
                          opacity: controller.othersOpacity.value,
                          child: Container(
                            width: double.infinity,
                            height: 0.45*h,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20.r),
                              boxShadow: [
                                BoxShadow(
                                  color: ClientTheme.shadowColor,
                                  offset: Offset(0, 4.h),
                                  blurRadius: 4.r,
                                  spreadRadius: 0,
                                ),
                              ],
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(20.r),
                              child: CarouselFadeWidget(
                                width: double.infinity,
                                height: 428.h,
                                displayDuration: const Duration(seconds: 4),
                                fadeDuration: const Duration(milliseconds: 1000),
                                children: [
                                  Image.asset(
                                    'assets/images/client/imagesSplash/1.jpg',
                                    fit: BoxFit.cover,
                                  ),
                                  Image.asset(
                                    'assets/images/client/imagesSplash/2.jpg',
                                    fit: BoxFit.cover,
                                  ),
                                  Image.asset(
                                    'assets/images/client/imagesSplash/3.jpg',
                                    fit: BoxFit.cover,
                                  ),
                                  Image.asset(
                                    'assets/images/client/imagesSplash/4.jpg',
                                    fit: BoxFit.cover,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      Obx(
                        () => AnimatedPositioned(
                          duration: controller.othersOpacity.value == 0.0
                              ? Duration.zero
                              : const Duration(milliseconds: 600),
                          curve: Curves.easeInOut,
                          bottom: controller.logoAtBottomCenter.value
                              ? 0
                              : 0.1*h,
                          child: AnimatedScale(
                            duration: const Duration(milliseconds: 400),
                            curve: Curves.easeInOutBack,
                            scale: controller.logoScale.value,
                            child: Hero(
                              tag: "logo",
                              child: Image(
                                image: AssetImage(
                                  "assets/images/client/logo djulah.png",
                                ),
                                width: 96.r,
                                height: 96.r,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Obx(
                  () => AnimatedOpacity(
                    duration: const Duration(milliseconds: 600),
                    curve: Curves.easeInOut,
                    opacity: controller.othersOpacity.value,
                    child: Column(
                      children: [
                        SizedBox(height: 32.r),
                        Text(
                          'splash.title'.tr,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: ClientTheme.textPrimaryColor,
                            letterSpacing: -1.2,
                            fontSize: 24.sp,
                            height: 32.sp / 24.sp,
                            fontFamily: "Geist",
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(height: 31.r),
                        Column(
                          children: [
                            PrimaryButton(
                              text: 'splash.createAccount'.tr,
                              onPressed: () {
                                controller.goToInscriptionPage();                              },
                            ),
                            SizedBox(height: 8.r),
                            SecondaryButton(
                              text: 'splash.signIn'.tr,
                              onPressed: () {
                                controller.goToConnectPage();
                              },
                            ),
                            SizedBox(height: 12.r),
                            TextLinkButton(
                              text: 'splash.continueWithoutAccount'.tr,
                              onPressed: () {
                                controller.othersOpacity.value=0.0;
                                controller.goToHomePage();
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
  }
}
