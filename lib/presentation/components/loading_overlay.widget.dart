import 'package:djulah/app/config/app_config.dart';
import 'package:djulah/infrastructure/theme/client_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class LoadingOverlay extends StatelessWidget {
  final Widget child;

  const LoadingOverlay({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center, // Alignement non-directionnel explicite
      children: [
        child,
        // Obx isolé pour rebuild uniquement l'overlay
        Obx(() => AppConfig.isLoadingApp.value
            ? const _LoadingOverlayContent()
            : const SizedBox.shrink()),
      ],
    );
  }
}

class _LoadingOverlayContent extends StatelessWidget {
  const _LoadingOverlayContent();

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: Colors.black54, // Plus performant que Colors.black.withOpacity(0.5)
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: Center(
          child: LoadingAnimationWidget.flickr(leftDotColor: ClientTheme.primaryColor.withOpacity(0.5), rightDotColor: ClientTheme.secondaryColor.withOpacity(0.5), size: 50.r),
        ),
      ),
    );
  }
}
