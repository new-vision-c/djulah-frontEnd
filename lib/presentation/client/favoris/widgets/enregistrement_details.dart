import 'package:djulah/presentation/client/components/app_bar.dart';
import 'package:djulah/presentation/client/components/card2.dart';
import 'package:djulah/presentation/client/favoris/widgets/not_found_favoris.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../controllers/favoris.controller.dart';

class EnregistrementDetails extends GetView<FavorisController> {
  const EnregistrementDetails({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            AppBarCustom(title: 'favorites.saved'.tr),
            Expanded(
              child: Obx(() {
                // Utiliser NotFoundFavoris si la liste est vide
                if (controller.enregistrements.isEmpty) {
                  return const Center(child: NotFoundFavoris());
                }
                
                return RefreshIndicator(
                  onRefresh: controller.onRefresh,
                  child: ListView.separated(
                  padding: EdgeInsets.symmetric(horizontal: 16.r, vertical: 40.r),
                  itemCount: controller.enregistrements.length,
                  separatorBuilder: (context, index) => SizedBox(height: 40.h),
                  itemBuilder: (context, index) {
                    final item = controller.enregistrements[index];
                    return Dismissible(
                      key: Key(item.id),
                      direction: DismissDirection.endToStart,
                      background: Container(
                        alignment: Alignment.centerRight,
                        padding: EdgeInsets.only(right: 20.r),
                        color: Colors.red,
                        child: const Icon(Icons.delete, color: Colors.white),
                      ),
                      confirmDismiss: (direction) async {
                        return await _confirmRemove(context, item.id);
                      },
                      onDismissed: (direction) {
                        controller.removeFavorite(item.id);
                      },
                      child: AppCard2(item: item),
                    );
                  },
                  ),
                );
              }),
            )
          ],
        ),
      ),
    );
  }
  
  Future<bool> _confirmRemove(BuildContext context, String propertyId) async {
    return await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('favorites.remove_title'.tr),
        content: Text('favorites.remove_confirm'.tr),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: Text('common.cancel'.tr),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: Text('favorites.remove_button'.tr, style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    ) ?? false;
  }
}
