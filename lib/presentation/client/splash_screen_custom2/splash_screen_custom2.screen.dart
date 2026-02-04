import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';

import 'controllers/splash_screen_custom2.controller.dart';

class SplashScreenCustom2Screen extends GetView<SplashScreenCustom2Controller> {
  const SplashScreenCustom2Screen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
          child: Obx(() {
            return AnimatedScale(
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
            );
          })
      ),
    );
  }
}
