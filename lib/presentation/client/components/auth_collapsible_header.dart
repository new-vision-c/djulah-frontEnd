import 'package:djulah/infrastructure/navigation/route_names.dart';
import 'package:djulah/infrastructure/theme/client_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class AuthCollapsibleHeader extends StatelessWidget {
  final String title;
  final String subtitle;
  final RxBool startAnimation;
  final VoidCallback? onLogoTap;

  const AuthCollapsibleHeader({
    super.key,
    required this.title,
    required this.subtitle,
    required this.startAnimation,
    this.onLogoTap,
  });

  @override
  Widget build(BuildContext context) {
    return SliverPersistentHeader(
      pinned: true,
      delegate: _AuthHeaderDelegate(
        title: title,
        subtitle: subtitle,
        startAnimation: startAnimation,
        onLogoTap: onLogoTap,
      ),
    );
  }
}

class _AuthHeaderDelegate extends SliverPersistentHeaderDelegate {
  final String title;
  final String subtitle;
  final RxBool startAnimation;
  final VoidCallback? onLogoTap;

  _AuthHeaderDelegate({
    required this.title,
    required this.subtitle,
    required this.startAnimation,
    this.onLogoTap,
  });

  // Constantes pour l'animation
  static final double _logoMax = 48.r;
  static final double _logoMin = 36.r;
  static final double _titleFontMax = 24.sp;
  static final double _titleFontMin = 18.sp;
  static final double _headerPaddingTop = 16.h;

  @override
  double get maxExtent => 200.h; // Hauteur augmentée

  @override
  double get minExtent => kToolbarHeight + 20.h;

  @override
  bool shouldRebuild(covariant _AuthHeaderDelegate oldDelegate) =>
      title != oldDelegate.title || subtitle != oldDelegate.subtitle;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    final topPadding = MediaQuery.of(context).padding.top;

    // Facteur de transition (0 = expanded, 1 = collapsed)
    final double t = (shrinkOffset / (maxExtent - minExtent)).clamp(0.0, 1.0);
    
    // Facteur accéléré pour le logo (scale 2.5x plus vite)
    final double tLogo = (t * 2.5).clamp(0.0, 1.0);

    // Interpolation des tailles - logo utilise tLogo pour scaler plus vite
    final double logoSize = _logoMax + (_logoMin - _logoMax) * tLogo;
    final double titleFontSize = _titleFontMax + (_titleFontMin - _titleFontMax) * t;

    // Positions du logo - utilise tLogo pour se déplacer plus vite
    final double logoExpandedX = 16.r;
    final double logoCollapsedX = 16.r;
    final double logoX = logoExpandedX + (logoCollapsedX - logoExpandedX) * tLogo;

    final double logoExpandedY = topPadding + _headerPaddingTop;
    final double logoCollapsedY = topPadding + 8.h;
    final double logoY = logoExpandedY + (logoCollapsedY - logoExpandedY) * tLogo;

    // Positions du titre
    final double titleExpandedY = logoExpandedY + _logoMax + 20.h;
    final double titleCollapsedY = topPadding + 8.h + (_logoMin - _titleFontMin) / 2;
    final double titleY = titleExpandedY + (titleCollapsedY - titleExpandedY) * t;

    final double titleCollapsedX = 16.r + _logoMin + 12.r;

    // Opacité du sous-titre (disparaît lors du scroll)
    final double subtitleOpacity = (1 - t * 2.5).clamp(0.0, 1.0);
    final double subtitleY = titleExpandedY + 36.h;

    return Obx(() {
      final isAnimated = startAnimation.value;

      return Container(
        color: Colors.white,
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Logo
            Positioned(
              left: logoX,
              top: logoY,
              child: GestureDetector(
                onTap: onLogoTap ??
                    () {
                      if (Get.key.currentState!.canPop()) {
                        startAnimation.value = false;
                        Get.back();
                      } else {
                        Get.toNamed(RouteNames.clientSplashScreenCustom);
                      }
                    },
                child: Hero(
                  tag: "logo",
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: logoSize,
                    height: logoSize,
                    child: Image(
                      image: const AssetImage(
                          "assets/images/client/logo djulah.png"),
                      height: logoSize,
                      width: logoSize,
                    ),
                  ),
                ),
              ),
            ),

            // Titre
            Positioned(
              left: titleCollapsedX * t + 16.r * (1 - t),
              right: 16.r,
              top: titleY,
              child: AnimatedOpacity(
                duration: const Duration(milliseconds: 200),
                opacity: isAnimated ? 1.0 : 0.0,
                child: Text(
                  title,
                  textAlign: t > 0.5 ? TextAlign.left : TextAlign.left,
                  style: TextStyle(
                    fontSize: titleFontSize,
                    fontStyle: FontStyle.normal,
                    fontWeight: FontWeight.w600,
                    letterSpacing: -1.2,
                    height: 32.r / 24.r,
                    color: ClientTheme.textPrimaryColor,
                  ),
                  maxLines: t > 0.3 ? 1 : 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),

            // Sous-titre (fade out lors du scroll)
            if (subtitleOpacity > 0)
              Positioned(
                left: 16.r,
                right: 16.r,
                top: subtitleY,
                child: AnimatedOpacity(
                  duration: const Duration(milliseconds: 200),
                  opacity: isAnimated ? subtitleOpacity : 0.0,
                  child: Text(
                    subtitle,
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontSize: 16.r,
                      fontStyle: FontStyle.normal,
                      fontWeight: FontWeight.w400,
                      letterSpacing: -0.48,
                      height: 20.r / 16.r,
                      color: ClientTheme.textSecondaryColor,
                    ),
                  ),
                ),
              ),
          ],
        ),
      );
    });
  }
}
