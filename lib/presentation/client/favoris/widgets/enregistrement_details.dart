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
            AppBarCustom(title: "Enregistrements"),
            Expanded(
              child: Obx(() {
                // Utiliser NotFoundFavoris si la liste est vide
                if (controller.enregistrements.isEmpty) {
                  return const Center(child: NotFoundFavoris());
                }
                
                return ListView.separated(
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
                      child: AppCard2(item: item, isFavoris: true),
                    );
                  },
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
        title: const Text('Retirer des favoris'),
        content: const Text('Voulez-vous vraiment retirer ce logement de vos favoris ?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Annuler'),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text('Retirer', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    ) ?? false;
  }
}
