import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../../generated/assets.dart';
import '../../../infrastructure/theme/client_theme.dart';

class AppBarCustom extends StatelessWidget{
  String title;
  Widget? action;
  bool withLeading;
  VoidCallback? onLeadingPressed;
  AppBarCustom({super.key, required this.title,this.action,this.withLeading=true, this.onLeadingPressed});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.r),
      height: 68.sp,
      width: double.infinity,
      decoration: BoxDecoration(
          color: Colors.white,
          border: Border(
            bottom: BorderSide(
                color: Color(0xFFE8E8E8),width: 1.r,style: BorderStyle.solid,)
        )
      ),
      child: Row(
        spacing: 8.r,
        children: [
          if(withLeading)
            IconButton(
              onPressed: onLeadingPressed ?? () {
            Get.back();
          }, icon: Container(
            height: 20.r,
            width: 20.r,
            padding: EdgeInsets.all(2.r),
            child: Image.asset(
              Assets.imagesArrow,
              color: ClientTheme.primaryColor,
              fit: BoxFit.cover,
            ),
          )
          ),
          Expanded(
            child: Text(
                title,
                style: TextStyle(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w600,
                    letterSpacing: -1.r,
                    height: 24.sp/20.sp,
                    color: Colors.black
                )
            ),
          ),
          if(action!=null)
            action!
        ],
      )
    );
  }

}