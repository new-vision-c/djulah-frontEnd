import 'package:djulah/infrastructure/theme/client_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class BottomNavigation extends StatelessWidget {
  final RxInt currentIndex;
  final ValueChanged<int> onChanged;
  
  BottomNavigation({
    super.key,
    required this.currentIndex,
    required this.onChanged,
  });
  
  final List<String> listOfPath = [
    "assets/images/client/BottomNavImages/search.svg",
    "assets/images/client/BottomNavImages/house-plus.svg",
    "assets/images/client/BottomNavImages/heart.svg",
    "assets/images/client/BottomNavImages/messages-square.svg",
    "assets/images/client/BottomNavImages/users.svg",
  ];
  
  final List<String> listOflabel = [
    "Explorer",
    "Reservations",
    "Favoris",
    "Messages",
    "Profil",
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: true,
      top: false,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: 8.r),
        decoration: const BoxDecoration(
          border: Border(
            top: BorderSide(color: Color(0xFFE8E8E8), style: BorderStyle.solid),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: List.generate(listOfPath.length, (index) {
            return Obx(() {
              bool isSelected = currentIndex.value == index;
              return InkWell(
                onTap: () {
                  onChanged(index);
                },
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                child: Container(
                  height: 70.h,
                  width: 80.4.w,
                  padding: EdgeInsets.all(6.r),
                  alignment: Alignment.center,
                  child: Column(
                    spacing: 4.r,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SvgPicture.asset(
                        listOfPath[index],
                        height: 20.r,
                        width: 20.r,
                        colorFilter: ColorFilter.mode(
                          isSelected
                              ? ClientTheme.primaryColor
                              : const Color(0xFF5E5E5E),
                          BlendMode.srcIn,
                        ),
                      ),
                      Text(
                        listOflabel[index],
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: isSelected
                              ? ClientTheme.primaryColor
                              : const Color(0xFF5E5E5E),
                          fontSize: 12.sp,
                          fontStyle: FontStyle.normal,
                          fontWeight: FontWeight.w500,
                          letterSpacing: -0.6.r,
                          height: 16.sp / 12.sp,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            });
          }),
        ),
      ),
    );
  }
}

class OptionMenu extends StatelessWidget {
  final String iconPath;
  final String label;
  final Color color;
  
  const OptionMenu({
    super.key,
    required this.iconPath,
    required this.label,
    required this.color,
  });
  
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(8.r),
      child: Column(
        spacing: 4.r,
        children: [
          SvgPicture.asset(
            iconPath,
            height: 20.r,
            width: 20.r,
            colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
          ),
          Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: color,
              fontSize: 12.sp,
              fontStyle: FontStyle.normal,
              fontWeight: FontWeight.w500,
              letterSpacing: -0.6.r,
              height: 16.sp / 12.sp,
            ),
          ),
        ],
      ),
    );
  }
}
