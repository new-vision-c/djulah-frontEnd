import 'package:djulah/generated/assets.dart';
import 'package:djulah/infrastructure/navigation/route_names.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../domain/entities/logement.dart';
import '../../../infrastructure/theme/client_theme.dart';
import 'animated_heart_button.dart';

class AppCard extends StatelessWidget {
  final Propriete item;

  const AppCard({
    super.key,
    required this.item,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.toNamed(RouteNames.clientDetailsLogement, arguments: item);
      },
      child: Container(
        width: 177.w,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ConstrainedBox(
              constraints: BoxConstraints(
                maxHeight: 177.r,
                maxWidth: 177.r,
              ),
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12.r),
                    child: Image.asset(
                      item.imagePath,
                      width: 177.r,
                      height: 177.r,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Positioned(
                    top: 12.r,
                    right: 12.r,
                    child: AnimatedHeartButton(
                      propertyId: item.id,
                      logement: item,
                      size: 24,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 10.r),
            Text(
              item.title,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w500,
                letterSpacing: -0.8.r,
                height: 20.sp / 16.sp,
                color: ClientTheme.textPrimaryColor,
              ),
            ),
            SizedBox(height: 8.r),
            Row(
              children: [
                Icon(
                  Icons.monetization_on_outlined,
                  size: 12.r,
                  color: ClientTheme.primaryColor,
                ),
                SizedBox(width: 4.r),
                Expanded(
                  child: Text(
                    item.priceText,
                    style: TextStyle(
                      overflow: TextOverflow.ellipsis,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                    ),
                  ),
                ),
                Icon(
                  Icons.star_border,
                  color: const Color(0xFFF6BC2F),
                  size: 12.r,
                ),
                Text(
                  item.rating.toStringAsFixed(1),
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
