import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../datas/models/favorite_property.model.dart';
import '../../../../infrastructure/navigation/route_names.dart';
import '../../../../infrastructure/theme/client_theme.dart';
import '../controllers/favoris.controller.dart';

class FavoritePropertyCard extends StatelessWidget {
  final FavoriteProperty favorite;
  final VoidCallback? onRemove;
  final VoidCallback? onTap;

  const FavoritePropertyCard({
    super.key,
    required this.favorite,
    this.onRemove,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap ?? () => Get.toNamed(RouteNames.clientDetailsLogement),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12.r),
                child: SizedBox(
                  width: double.infinity,
                  height: 200.h,
                  child: Image.asset(
                    favorite.imagePath,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: Colors.grey[200],
                        child: Icon(
                          Icons.image_not_supported_outlined,
                          size: 48.r,
                          color: Colors.grey,
                        ),
                      );
                    },
                  ),
                ),
              ),
              // Badge de synchronisation
              if (!favorite.isSyncedWithBackend)
                Positioned(
                  top: 12.r,
                  left: 12.r,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 8.r, vertical: 4.r),
                    decoration: BoxDecoration(
                      color: Colors.orange,
                      borderRadius: BorderRadius.circular(4.r),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.cloud_off,
                          size: 12.r,
                          color: Colors.white,
                        ),
                        SizedBox(width: 4.w),
                        Text(
                          'Non sync',
                          style: TextStyle(
                            fontSize: 10.sp,
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              // Bouton supprimer
              Positioned(
                top: 12.r,
                right: 12.r,
                child: GestureDetector(
                  onTap: onRemove,
                  child: Container(
                    padding: EdgeInsets.all(8.r),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Icon(
                      Icons.favorite,
                      size: 20.r,
                      color: ClientTheme.primaryColor,
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      favorite.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                        height: 20.sp / 16.sp,
                        letterSpacing: -0.8.r,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      favorite.category,
                      style: TextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w400,
                        color: const Color(0XFF5E5E5E),
                        height: 16.sp / 12.sp,
                        letterSpacing: -0.36.r,
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.star,
                    size: 14.r,
                    color: const Color(0xFFF6BC2F),
                  ),
                  SizedBox(width: 4.w),
                  Text(
                    favorite.rating.toStringAsFixed(1),
                    style: TextStyle(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w500,
                      color: const Color(0XFF5E5E5E),
                      height: 20.sp / 16.sp,
                      letterSpacing: -0.36.r,
                    ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 8.h),
          Row(
            children: [
              Icon(
                Icons.monetization_on_outlined,
                size: 16.r,
                color: ClientTheme.primaryColor,
              ),
              SizedBox(width: 4.w),
              Text(
                favorite.priceText,
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                  height: 20.sp / 16.sp,
                  letterSpacing: -0.8.r,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// État vide pour les favoris
class EmptyFavoritesWidget extends StatelessWidget {
  const EmptyFavoritesWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(32.r),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.favorite_border,
              size: 80.r,
              color: Colors.grey[300],
            ),
            SizedBox(height: 24.h),
            Text(
              'Aucun favori',
              style: TextStyle(
                fontSize: 20.sp,
                fontWeight: FontWeight.w600,
                color: Colors.grey[600],
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              'Ajoutez des logements à vos favoris\npour les retrouver ici',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14.sp,
                color: Colors.grey[500],
                height: 1.4,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
