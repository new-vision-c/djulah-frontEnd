import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../datas/local_storage/sync_service.dart';

/// Widget qui affiche l'état de connexion et de synchronisation
class ConnectionStatusBanner extends StatelessWidget {
  const ConnectionStatusBanner({super.key});

  @override
  Widget build(BuildContext context) {
    if (!Get.isRegistered<SyncService>()) {
      return const SizedBox.shrink();
    }

    final syncService = Get.find<SyncService>();

    return Obx(() {
      // Si en ligne et pas de sync en cours, ne rien afficher
      if (syncService.isOnline.value && 
          !syncService.isSyncing.value && 
          syncService.pendingCount.value == 0) {
        return const SizedBox.shrink();
      }

      return Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 16.r, vertical: 8.r),
        color: _getBackgroundColor(syncService),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildIcon(syncService),
            SizedBox(width: 8.w),
            Flexible(
              child: Text(
                _getMessage(syncService),
                style: TextStyle(
                  fontSize: 12.sp,
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            if (syncService.pendingCount.value > 0) ...[
              SizedBox(width: 8.w),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 6.r, vertical: 2.r),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: Text(
                  '${syncService.pendingCount.value}',
                  style: TextStyle(
                    fontSize: 10.sp,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ],
        ),
      );
    });
  }

  Color _getBackgroundColor(SyncService service) {
    if (!service.isOnline.value) {
      return Colors.grey[700]!;
    }
    if (service.isSyncing.value) {
      return Colors.blue;
    }
    if (service.pendingCount.value > 0) {
      return Colors.orange;
    }
    return Colors.green;
  }

  Widget _buildIcon(SyncService service) {
    if (!service.isOnline.value) {
      return Icon(
        Icons.cloud_off,
        size: 16.r,
        color: Colors.white,
      );
    }
    if (service.isSyncing.value) {
      return SizedBox(
        width: 14.r,
        height: 14.r,
        child: const CircularProgressIndicator(
          strokeWidth: 2,
          color: Colors.white,
        ),
      );
    }
    if (service.pendingCount.value > 0) {
      return Icon(
        Icons.pending_outlined,
        size: 16.r,
        color: Colors.white,
      );
    }
    return Icon(
      Icons.cloud_done,
      size: 16.r,
      color: Colors.white,
    );
  }

  String _getMessage(SyncService service) {
    if (!service.isOnline.value) {
      return 'Mode hors ligne';
    }
    if (service.isSyncing.value) {
      return 'Synchronisation en cours...';
    }
    if (service.pendingCount.value > 0) {
      return '${service.pendingCount.value} message(s) en attente';
    }
    return 'Synchronisé';
  }
}

/// Indicateur de connexion compact pour l'AppBar
class CompactConnectionIndicator extends StatelessWidget {
  const CompactConnectionIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    if (!Get.isRegistered<SyncService>()) {
      return const SizedBox.shrink();
    }

    final syncService = Get.find<SyncService>();

    return Obx(() {
      if (syncService.isOnline.value && syncService.pendingCount.value == 0) {
        return const SizedBox.shrink();
      }

      return Container(
        margin: EdgeInsets.only(right: 8.r),
        padding: EdgeInsets.all(4.r),
        decoration: BoxDecoration(
          color: syncService.isOnline.value ? Colors.orange : Colors.grey,
          shape: BoxShape.circle,
        ),
        child: syncService.isSyncing.value
            ? SizedBox(
                width: 12.r,
                height: 12.r,
                child: const CircularProgressIndicator(
                  strokeWidth: 1.5,
                  color: Colors.white,
                ),
              )
            : Icon(
                syncService.isOnline.value
                    ? Icons.pending_outlined
                    : Icons.cloud_off,
                size: 12.r,
                color: Colors.white,
              ),
      );
    });
  }
}
