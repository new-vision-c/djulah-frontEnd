import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';

import '../components/app_bar.dart';
import 'controllers/langue.controller.dart';

class LangueScreen extends GetView<LangueController> {
  const LangueScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            AppBarCustom(title: 'language.title'.tr),
            Divider(color: Color(0xFFE8E8E8), height: 1.r, thickness: 1.r),
            Expanded(
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 20.r, horizontal: 16.r),
                child: Obx(() {
                  return Column(
                    spacing: 8.r,
                    children: [
                      RadioListTile<String>(
                        title: Text(
                          'language.french'.tr,
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w600,
                            letterSpacing: -0.8.r,
                            height: 20.sp / 16.sp,
                            color: Colors.black,
                          ),
                        ),
                        value: "Fr",
                        groupValue: controller.selected.value,
                        controlAffinity: ListTileControlAffinity.trailing,
                        onChanged: (value) {
                          if (value != null) {
                            controller.changeLanguage(value);
                          }
                        },
                      ),
                      RadioListTile<String>(
                        title: Text(
                          'language.english'.tr,
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w600,
                            letterSpacing: -0.8.r,
                            height: 20.sp / 16.sp,
                            color: Colors.black,
                          ),
                        ),
                        value: "En",
                        groupValue: controller.selected.value,
                        controlAffinity: ListTileControlAffinity.trailing,
                        onChanged: (value) {
                          if (value != null) {
                            controller.changeLanguage(value);
                          }
                        },
                      ),
                    ],
                  );
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
