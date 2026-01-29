import 'package:djulah/presentation/client/components/app_bar.dart';
import 'package:djulah/presentation/client/components/card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../controllers/favoris.controller.dart';

class VueRecementDetails extends GetView<FavorisController> {
  const VueRecementDetails({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            AppBarCustom(title: "Vu récemment"),
            Expanded(
              child: Obx(() => GridView.builder(
                padding: EdgeInsets.all(16.r),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16.r,
                  mainAxisSpacing: 16.r,
                  childAspectRatio: 177 / 250,
                ),
                itemCount: controller.vuRecemment.length,
                itemBuilder: (context, index) {
                  return AppCard(
                    item: controller.vuRecemment[index],
                    isFavoris: true,
                  );
                },
              )),
            )
          ],
        ),
      ),
    );
  }
}
