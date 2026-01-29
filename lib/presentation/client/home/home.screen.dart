import 'package:djulah/domain/enums/type_logement.dart';
import 'package:djulah/infrastructure/theme/client_theme.dart';
import 'package:djulah/presentation/client/home/widgets/search_modal.dart';
import 'package:djulah/presentation/client/home/widgets/tab_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:get/get.dart';

import 'widgets/tab_item.dart';
import 'controllers/home.controller.dart';

class HomeScreen extends GetView<HomeController> {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.white,
          centerTitle: true,
          title: GestureDetector(
            onTap: () {
              SearchModal.show(context, initialTabIndex: controller.currentTab.value);
            },
            child: Container(
              width: 370.w,
              height: 56.h,
              alignment: Alignment.center,
              padding: EdgeInsets.symmetric(horizontal: 8.r, vertical: 16.r),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(1000.r),
                boxShadow: [
                  BoxShadow(
                    offset: Offset(0, 0),
                    blurRadius: 17.2,
                    spreadRadius: 6,
                    color: Colors.black.withOpacity(0.05),
                  ),
                  BoxShadow(
                    offset: Offset(0, 33),
                    blurRadius: 9,
                    spreadRadius: 0,
                    color: Color(0xFFC9C9C9).withOpacity(0.00),
                  ),
                  BoxShadow(
                    offset: Offset(0, 21),
                    blurRadius: 8,
                    spreadRadius: 0,
                    color: Color(0xFFC9C9C9).withOpacity(0.03),
                  ),
                  BoxShadow(
                    offset: Offset(0, 12),
                    blurRadius: 7,
                    spreadRadius: 0,
                    color: Color(0xFFC9C9C9).withOpacity(0.09),
                  ),
                  BoxShadow(
                    offset: Offset(0, 5),
                    blurRadius: 5,
                    spreadRadius: 0,
                    color: Color(0xFFC9C9C9).withOpacity(0.15),
                  ),
                  BoxShadow(
                    offset: Offset(0, 1),
                    blurRadius: 3,
                    spreadRadius: 0,
                    color: Color(0xFFC9C9C9).withOpacity(0.18),
                  ),
                ],
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                spacing: 10.r,
                children: [
                  Container(
                    padding: EdgeInsets.all(3.r),
                    child: Image.asset(
                        "assets/images/client/BottomNavImages/search.png",
                        width: 18.r, height: 18.r),
                  ),
                  Text(
                    "Commencer ma recherche",
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontStyle: FontStyle.normal,
                      fontWeight: FontWeight.w500,
                      letterSpacing: -0.9.r,
                      height: 24.sp / 18.sp,
                      color: Color(0xFF6A6A6A),
                    ),
                  )
                ],
              ),
            ),
          ),
          toolbarHeight: 140.h,
          bottom: TabBar(
            dividerHeight: 1.h,
            dividerColor: Color(0xFFE8E8E8),
            controller: controller.tabController,
            isScrollable: false,
            unselectedLabelColor: ClientTheme.textTertiaryColor,
            labelColor: ClientTheme.textPrimaryColor,
            indicatorColor: ClientTheme.primaryColor,
            labelStyle: TextStyle(
              fontSize: 16.sp,
              fontStyle: FontStyle.normal,
              fontWeight: FontWeight.w500,
              letterSpacing: -0.8.r,
              height: 20.sp / 16.sp,
              color: ClientTheme.textTertiaryColor,
            ),
            tabs: [
              TabItem(
                icon: Obx(() {
                  return SvgPicture.asset(
                    "assets/images/client/hotel.svg",
                    width: 24.r,
                    height: 24.r,
                    colorFilter: ColorFilter.mode(
                      controller.currentTab.value == 0
                          ? ClientTheme.primaryColor
                          : ClientTheme.textTertiaryColor,
                      BlendMode.srcIn,
                    ),
                  );
                }),
                label: "Meublés",

              ),
              TabItem(
                icon: Obx(() {
                  return SvgPicture.asset(
                    "assets/images/client/BottomNavImages/house.svg",
                    width: 24.r,
                    height: 24.r,
                    colorFilter: ColorFilter.mode(
                      controller.currentTab.value == 1
                          ? ClientTheme.primaryColor
                          : ClientTheme.textTertiaryColor,
                      BlendMode.srcIn,
                    ),
                  );
                }),
                label: "Non meublés",
              ),
              TabItem(
                icon: Obx(() {
                  return SvgPicture.asset(
                    "assets/images/client/hotel.svg",
                    width: 24.r,
                    height: 24.r,
                    colorFilter: ColorFilter.mode(
                      controller.currentTab.value == 2
                          ? ClientTheme.primaryColor
                          : ClientTheme.textTertiaryColor,
                      BlendMode.srcIn,
                    ),
                  );
                }),
                label: "Commercial",

              ),
            ],
          )
      ),
      body: SafeArea(
        bottom: true,
        top: false,
        child: TabBarView(
          controller: controller.tabController,
          physics: NeverScrollableScrollPhysics(),
          children: [
            TabContent(TypeLogement.meubles),
            TabContent(TypeLogement.non_meubles),
            TabContent(TypeLogement.commercial),
          ],
        ),
      ),
    );
  }
}
