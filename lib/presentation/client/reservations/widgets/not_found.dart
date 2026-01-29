import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class NotFound extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Image.asset("assets/images/not_found/reservation.png",height: 300.r,width: 300.r,),
        SizedBox(height: 40.r),
        Text(
          "Rien ici pour le moment",
          style: TextStyle(
            fontSize: 24.sp,
            fontStyle: FontStyle.normal,
            fontWeight: FontWeight.w600,
            letterSpacing: -1.2.r,
            height: 32.sp / 24.sp,
          )
        ),
        SizedBox(height: 8.r,),
        Text(
          textAlign: TextAlign.center,
            "Retrouvez toutes vos réservations ici fois que vous en aurez fait une ... On vous attends",
            style: TextStyle(
              fontSize: 16.sp,
              fontStyle: FontStyle.normal,
              fontWeight: FontWeight.w400,
              letterSpacing: -0.48.r,
              height: 20.sp / 16.sp,
              color: Color(0xFF4B4B4B)
            )
        )
      ],
    );
  }

}