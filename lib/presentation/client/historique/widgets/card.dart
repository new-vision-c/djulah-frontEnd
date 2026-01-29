import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../generated/assets.dart';

class CardCustom extends StatelessWidget{
  final String imagesPath;
  final String title;
  final Widget Status;
  final String date;
  final String price;
  final VoidCallback? onTap;
  
  const CardCustom({
    super.key, 
    required this.imagesPath, 
    required this.title, 
    required this.Status, 
    required this.date, 
    required this.price,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(20.r),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.r),
        ),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                spacing: 17.r,
                children: [
                  ClipRRect(
                    child: Image.asset(imagesPath, height: 64.r,width: 64.r,fit: BoxFit.cover,),
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  Expanded(
                    child: Text(
                      title,
                      maxLines: 2,
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w500,
                        letterSpacing: -0.8.r,
                        height: 20.sp / 16.sp,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  Status,
                ],
              ),
              SizedBox(height: 18.h),
              Divider(
                color: Color(0xFFE8E8E8),
                thickness: 1.r,
              ),
              SizedBox(height: 18.h),
              Row(
                children: [
                  Text("Date",
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w500,
                      letterSpacing: -0.8.r,
                      height: 20.sp / 16.sp,
                      color: Colors.black,

                    ),
                  ),
                  SizedBox(width: 14.r),
                  Text(
                    date,
                    style:  TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                      letterSpacing: -0.42.r,
                      height: 20.sp / 16.sp,
                      color: Color(0xFF4B4B4B),
                    ),
                  )

                ],
              ),
              SizedBox(height: 18.h),
              Divider(
                color: Color(0xFFE8E8E8),
                thickness: 1.r,
              ),
              SizedBox(height: 18.h),
              Row(
                children: [
                  Text("Prix total",
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                      letterSpacing: -0.42.r,
                      height: 20.sp / 16.sp,
                      color: Color(0xFF4B4B4B),

                    ),
                  ),
                  SizedBox(width: 14.r),
                  Text(
                    price,
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                      letterSpacing: -0.8.r,
                      height: 20.sp / 16.sp,
                      color: Color(0xFF4CAF50),

                    ),
                  )

                ],
              )
            ]),
      ),
    );
  }

}