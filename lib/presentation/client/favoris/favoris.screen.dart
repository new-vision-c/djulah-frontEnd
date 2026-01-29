import 'package:djulah/presentation/client/favoris/widgets/Vue_recemment_details.dart';
import 'package:djulah/presentation/client/favoris/widgets/enregistrement_details.dart';
import 'package:djulah/presentation/components/shimmer_box.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';

import 'controllers/favoris.controller.dart';

class FavorisScreen extends GetView<FavorisController> {
  const FavorisScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: false,
        elevation: 0,
        shape: const Border(
          bottom: BorderSide(
            color: Color(0xFFE8E8E8),
          )
        ),
        title: Text("Favoris",
          style: TextStyle(
            fontSize: 20.sp,
            fontWeight: FontWeight.w600,
            letterSpacing: -1.r,
            height: 24.sp/20.sp,
            color: Colors.black
          ),
        ),
        toolbarHeight: 68.r,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return GridView.builder(
            padding: EdgeInsets.symmetric(horizontal: 16.r, vertical: 32.r),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16.r,
                mainAxisSpacing: 24.r,
                mainAxisExtent: 240.r,
            ),
            itemCount: 4,
            itemBuilder: (context, index) => _buildShimmerItem(),
          );
        }

        return GridView(
            padding: EdgeInsets.symmetric(horizontal: 16.r, vertical: 32.r),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16.r,
                mainAxisSpacing: 24.r,
                mainAxisExtent: 240.r,
            ),
          children: [
            GestureDetector(
              onTap: (){
                Get.to(VueRecementDetails());
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8.r),
                    child: SizedBox(
                      width: 176.r,
                      height: 176.r,
                        child: GridView.builder(
                            physics: const NeverScrollableScrollPhysics(), // Désactive le scroll interne
                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisSpacing: 4.r,
                              mainAxisSpacing: 4.r,
                                crossAxisCount: 2
                            ),
                            itemCount: 4,
                            itemBuilder: (context,index){
                             return Image.asset(controller.listCustomCard[index], fit: BoxFit.cover,);
                            }
                        )
                    ),
                  ),
                  SizedBox(height: 12.r),
                  Text(
                    "Vu récemment",
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w500,
                      letterSpacing: -0.9.r,
                      height: 24.sp/18.sp,
                      color: Colors.black
                    )
                  ),
                  Text(
                    "Hier",
                    style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w400,
                        letterSpacing: -0.42.r,
                        height: 20.sp/14.sp,
                        color: const Color(0xFF5E5E5E)
                    )
                  )
                ],
              ),
            ),
            GestureDetector(
              onTap: (){
                Get.to(EnregistrementDetails());
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Hero(
                    tag: "enregistrement",
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8.r),
                      child: SizedBox(
                          width: 176.r,
                          height: 176.r,
                          child: controller.enregistrements.isNotEmpty
                              ? Image.asset(
                                  controller.enregistrements.first.images.first,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Image.asset(
                                      "assets/images/client/imagesSplash/3.jpg",
                                      fit: BoxFit.cover,
                                    );
                                  },
                                )
                              : Image.asset(
                                  "assets/images/client/imagesSplash/3.jpg",
                                  fit: BoxFit.cover,
                                )
                      ),
                    ),
                  ),
                  SizedBox(height: 12.r),
                  Text(
                      "Enregistrements",
                      style: TextStyle(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w500,
                          letterSpacing: -0.9.r,
                          height: 24.sp/18.sp,
                          color: Colors.black
                      )
                  ),
                  Text(
                      "${controller.favoritesCount} favoris enregistrés",
                      style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w400,
                          letterSpacing: -0.42.r,
                          height: 20.sp/14.sp,
                          color: const Color(0xFF5E5E5E)
                      )
                  )
                ],
              ),
            )
          ],
        );
      }),
    );
  }

  Widget _buildShimmerItem() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ShimmerBox(width: 176.r, height: 176.r, borderRadius: 8.r),
        SizedBox(height: 12.r),
        ShimmerBox(width: 120.r, height: 18.sp, borderRadius: 4.r),
        SizedBox(height: 4.r),
        ShimmerBox(width: 80.r, height: 14.sp, borderRadius: 4.r),
      ],
    );
  }
}
