import 'package:djulah/generated/assets.dart';
import 'package:djulah/infrastructure/navigation/route_names.dart';
import 'package:djulah/presentation/client/components/option.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';

import '../components/app_bar.dart';
import 'controllers/parametres.controller.dart';

class ParametresScreen extends GetView<ParametresController> {
  const ParametresScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            AppBarCustom(title: 'settings.title'.tr),
            Expanded(
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 20.r, horizontal: 16.r),
                color: const Color(0xFFF3F3F3),
                child: Column(
                  spacing: 8.r,
                  children: [
                    Option(
                      imagePath:
                          "assets/images/client/profil_icons/languagesIcon.png",
                      title: 'settings.language'.tr,
                      background: Colors.white,
                      onTap: () {
                        Get.toNamed(RouteNames.clientLangue);
                      },
                    ),
                    Option(
                      imagePath:
                          "assets/images/client/profil_icons/security-safe.png",
                      title: 'settings.security'.tr,
                      background: Colors.white,
                      onTap: () {
                        Get.toNamed(RouteNames.clientSecurite);
                      },
                    ),
                  ],
                ),

              ),
            ),
          ],
        ),
      ),
    );
  }
}
