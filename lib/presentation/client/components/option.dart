import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../infrastructure/theme/client_theme.dart';

class Option extends StatelessWidget {
  final String imagePath;
  final String title;
  final VoidCallback onTap;
  final bool isLogouted;
  Color background;

   Option(
      {super.key,
        required this.imagePath,
        required this.title,
        required this.onTap,
        this.isLogouted = false,
        this.background = const Color(0XFFF3F3F3)
      });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        height: 52.r,
        padding: EdgeInsets.symmetric(horizontal: 12.r, vertical: 16.r),
        decoration: BoxDecoration(
          color: background,
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: Row(children: [
          Image.asset(imagePath),
          SizedBox(
            width: 8.w,
          ),
          Expanded(
            child: Text(title,
                style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                    letterSpacing: -0.7.r,
                    height: 20.sp / 14.sp,
                    color: isLogouted ? ClientTheme.errorColor : Colors.black)),
          ),
          if (isLogouted == false)
            Icon(Icons.arrow_forward_ios, size: 16.r, color: const Color(0xFF5E5E5E))
        ]),
      ),
    );
  }
}