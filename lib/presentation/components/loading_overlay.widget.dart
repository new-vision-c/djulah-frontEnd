import 'package:djulah/app/config/app_config.dart';
import 'package:djulah/infrastructure/theme/client_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../../infrastructure/shared/app_enums.dart';

/// Overlay global qui gère le loading de l'application (via AppConfig.isLoadingApp)
class LoadingOverlay extends StatelessWidget {
  final Widget child;

  const LoadingOverlay({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        child,
        // Loading overlay standard
        Obx(() => AppConfig.isLoadingApp.value
            ? const _LoadingContent()
            : const SizedBox.shrink()),
      ],
    );
  }
}

// ==================== LOADING CONTENT ====================

class _LoadingContent extends StatelessWidget {
  const _LoadingContent();

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: Colors.black54,
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: Obx(() {
          final position = AppConfig.loadingPosition.value;
          final isBottom = position == LoadingPosition.bottom;
          
          return Align(
            alignment: isBottom ? Alignment.bottomCenter : Alignment.center,
            child: Padding(
              padding: isBottom ? EdgeInsets.only(bottom: 80.r) : EdgeInsets.zero,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  LoadingAnimationWidget.flickr(
                    leftDotColor: ClientTheme.primaryColor,
                    rightDotColor: ClientTheme.secondaryColor,
                    size: 50.r,
                  ),
                  _buildMessage(),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
  
  Widget _buildMessage() {
    return Obx(() {
      final message = AppConfig.loadingMessage.value;
      if (message.isEmpty) return const SizedBox.shrink();
      
      return Padding(
        padding: EdgeInsets.only(top: 24.r),
        child: Text(
          message,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white,
            fontSize: 16.sp,
            fontWeight: FontWeight.w500,
          ),
        ),
      );
    });
  }
}
