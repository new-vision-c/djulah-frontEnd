import 'package:djulah/app/config/app_config.dart';
import 'package:djulah/infrastructure/navigation/route_names.dart';
import 'package:djulah/infrastructure/theme/client_theme.dart';
import 'package:djulah/presentation/components/buttons/secondary_button.widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';

import '../components/app_bar.dart';
import 'controllers/politique_confidentialite.controller.dart';

class PolitiqueConfidentialiteScreen
    extends GetView<PolitiqueConfidentialiteController> {
  const PolitiqueConfidentialiteScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
     body: SafeArea(
       child: Column(
         children: [
           AppBarCustom(title: "Politique de confidentialité"),
           Expanded(
             child: Container(
               padding: EdgeInsets.symmetric(vertical: 20.r, horizontal: 16.r),
               color: const Color(0xFFF3F3F3),
               child: Column(
                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
                 children: [
                   Container(
                     height: 0.65*height ,
                     alignment: Alignment.topLeft,
                     decoration: BoxDecoration(
                       color: Colors.white,
                       borderRadius: BorderRadius.circular(16.r),
                     ),
                     child: ListView(
                         padding: EdgeInsets.symmetric(
                           vertical: 28.h,
                           horizontal: 20.w,
                         ),
                         children: [
                           Text(
                             "Sorem ipsum dolor sit amet, consectetur adipiscing elit.",
                             style: TextStyle(
                               fontSize: 16.sp,
                               fontWeight: FontWeight.w500,
                               letterSpacing: -0.8.r,
                               height: 20.sp / 16.sp,
                               color: Colors.black,
                             ),
                           ),
                           SizedBox(height: 20.h,),
                           Text(
                             "Gorem ipsum dolor sit amet, consectetur adipiscing elit. Etiam eu turpis molestie, dictum est a, mattis tellus. Sed dignissim, metus nec fringilla accumsan, risus sem sollicitudin lacus, ut interdum tellus elit sed risus. Maecenas eget condimentum velit, sit amet feugiat lectus. Class aptent taciti sociosqu ad litora torquent per conubia nostra, per inceptos himenaeos. Praesent auctor purus luctus enim egestas, ac scelerisque ante pulvinar. Donec ut rhoncus ex. Suspendisse ac rhoncus nisl, eu tempor urna. Curabitur vel bibendum lorem. Morbi convallis convallis diam sit amet lacinia. Aliquam in elementum tellus. Curabitur tempor quis eros tempus lacinia. Nam bibendum pellentesque quam a convallis. Sed ut vulputate nisi. Integer in felis sed leo vestibulum venenatis. Suspendisse quis arcu sem. Aenean feugiat ex eu vestibulum vestibulum. Morbi a eleifend magna. Nam metus lacus, porttitor eu mauris a, blandit ultrices nibh. Mauris sit amet magna non ligula vestibulum eleifend. Nulla varius volutpat turpis sed lacinia. Nam eget mi in purus lobortis eleifend. Sed nec ante dictum sem condimentum ullamcorper quis venenatis nisi. Proin vitae facilisis nisi, ac posuere leo.",
                             style: TextStyle(
                               fontSize: 16.sp,
                               fontWeight: FontWeight.w500,
                               letterSpacing: -0.48.r,
                               height: 20.sp / 16.sp,
                               color: Color(0xFF5E5E5E),
                             ),
                           )

                         ]
                     ),


                   ),
                   SecondaryButton(
                       onPressed: () => controller.showDeleteAccountDialog(),
                       fontSize: 16.sp,
                       isEnabled: true,
                       icon: Image.asset("assets/images/client/profil_icons/trash-2.png", color: ClientTheme.errorColor,),
                       textColor: ClientTheme.errorColor,
                       text: "Supprimer mon compte"
                   )
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
