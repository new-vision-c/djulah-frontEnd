import 'dart:io';

import 'package:djulah/app/config/app_config.dart';
import 'package:djulah/app/services/profile_image_service.dart';
import 'package:djulah/generated/assets.dart';
import 'package:djulah/infrastructure/navigation/route_names.dart';
import 'package:djulah/presentation/client/components/option.dart';
import 'package:djulah/presentation/components/shimmer_box.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';

import '../../../infrastructure/theme/client_theme.dart';
import 'controllers/profil.controller.dart';

class ProfilScreen extends GetView<ProfilController> {
  const ProfilScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          SliverPersistentHeader(
            pinned: true,
            delegate: _ProfilHeaderDelegate(controller: controller),
          ),
          SliverPadding(
            padding: EdgeInsets.symmetric(horizontal: 16.r),
            sliver: SliverToBoxAdapter(child: _buildOptionsList()),
          ),
        ],
      ),
    );
  }

  Widget _buildOptionsList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 16.h),
        _sectionTitle("Customisé"),
        SizedBox(height: 16.h),
        Option(
          title: "Informations personnelles",
          imagePath: Assets.profilIconsUser,
          onTap: () => Get.toNamed(RouteNames.clientInformationsPersonnelles),
        ),
        SizedBox(height: 16.h),
        Option(
          title: "Historique",
          imagePath: Assets.profilIconsListRestart,
          onTap: () => Get.toNamed(RouteNames.clientHistorique),
        ),
        SizedBox(height: 28.h),
        _sectionTitle("Accessibilité"),
        SizedBox(height: 16.h),
        Option(
          title: "Parametres",
          imagePath: Assets.profilIconsUser,
          onTap: () => Get.toNamed(RouteNames.clientParametres),
        ),
        SizedBox(height: 28.h),
        _sectionTitle("Confidentialité"),
        SizedBox(height: 16.h),
        Option(
          title: "Termes d'utilisation",
          imagePath: Assets.profilIconsBookText,
          onTap: () => Get.toNamed(RouteNames.clientTermesUtilisation),
        ),
        SizedBox(height: 16.h),
        Option(
          title: "Politique de confidentialité",
          imagePath: Assets.profilIconsShieldAlert,
          onTap: () => Get.toNamed(RouteNames.clientPolitiqueConfidentialite),
        ),
        SizedBox(height: 16.h),
        Option(
          title: "Utilisation des données",
          imagePath: Assets.profilIconsDatabase,
          onTap: () => Get.toNamed(RouteNames.clientUtilisationDonnees),
        ),
        SizedBox(height: 28.h),
        Option(
          title: "Se déconnecter",
          isLogouted: true,
          imagePath: Assets.profilIconsLogOut,
          onTap: () {
            AppConfig.isLoadingApp.value = true;
            Future.delayed(const Duration(seconds: 2)).then((_) {
              Get.offAllNamed(RouteNames.clientLogin);
              AppConfig.isLoadingApp.value = false;
            });
          },
        ),
        SizedBox(height: 32.h),
      ],
    );
  }

  Widget _sectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 16.sp,
        fontWeight: FontWeight.w500,
        letterSpacing: -0.8.r,
        height: 20.sp / 16.sp,
        color: const Color(0xFF5E5E5E),
      ),
    );
  }
}

class _ProfilHeaderDelegate extends SliverPersistentHeaderDelegate {
  final ProfilController controller;

  _ProfilHeaderDelegate({required this.controller});

  // Constantes
  static final double _avatarMax = 96.r;
  static final double _avatarMin = 40.r;
  static final double _fontMax = 24.sp;
  static final double _fontMin = 18.sp;
  static final double _headerPadding = 60.h;

  @override
  double get maxExtent => 260.h;

  @override
  double get minExtent => kToolbarHeight + 60.h;

  @override
  bool shouldRebuild(covariant _ProfilHeaderDelegate oldDelegate) => false;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    final topPadding = MediaQuery.of(context).padding.top;
    final screenWidth = MediaQuery.of(context).size.width;

    final double t = (shrinkOffset / (maxExtent - minExtent)).clamp(0.0, 1.0);
    
    final double tAvatar = (t * 1.3).clamp(0.0, 1.0);

    final double avatarSize = _avatarMax + (_avatarMin - _avatarMax) * tAvatar;
    final double fontSize = _fontMax + (_fontMin - _fontMax) * t;

    final double avatarExpandedX = (screenWidth - _avatarMax) / 2;
    final double avatarCollapsedX = 16.r;
    final double avatarX = avatarExpandedX + (avatarCollapsedX - avatarExpandedX) * tAvatar;

    final double avatarExpandedY = topPadding + _headerPadding;
    final double avatarCollapsedY = topPadding + 15.h;
    final double avatarY = avatarExpandedY + (avatarCollapsedY - avatarExpandedY) * tAvatar;

    final double nameExpandedY = avatarExpandedY + _avatarMax + 12.h;
    final double nameCollapsedY = topPadding + 15.h + (_avatarMin - _fontMin) / 2;
    final double nameY = nameExpandedY + (nameCollapsedY - nameExpandedY) * t;

    final double nameCollapsedX = 16.r + _avatarMin + 12.r;

    // Membre depuis
    final double memberY = nameExpandedY + 32.h;
    final double memberOpacity = (1 - t * 2.5).clamp(0.0, 1.0);

    return Obx(() {
      final isLoading = controller.isLoading.value;
      final userName = controller.userName.value;
      final memberSince = controller.memberSince.value;

      return Container(
        color: Colors.white,
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Avatar
            Positioned(
              left: avatarX,
              top: avatarY,
              child: SizedBox(
                width: avatarSize,
                height: avatarSize,
                child: isLoading
                    ? ShimmerBox(
                        width: avatarSize,
                        height: avatarSize,
                        shape: BoxShape.circle,
                      )
                    : _buildAvatar(avatarSize, t),
              ),
            ),

            Positioned(
              left: nameCollapsedX * t,
              right: 16.r * t,
              top: nameY,
              child: isLoading
                  ? Align(
                      alignment: Alignment.lerp(
                        Alignment.center,
                        Alignment.centerLeft,
                        t,
                      )!,
                      child: ShimmerBox(
                        width: 150.w - (30.w * t),
                        height: fontSize * 1.3,
                        borderRadius: 6.r,
                      ),
                    )
                  : Align(
                      alignment: Alignment.lerp(
                        Alignment.center,
                        Alignment.centerLeft,
                        t,
                      )!,
                      child: Text(
                        userName,
                        style: TextStyle(
                          fontSize: fontSize,
                          fontWeight: FontWeight.w600,
                          letterSpacing: -1.2.r,
                          height: 1.3,
                          color: Colors.black,
                        ),
                      ),
                    ),
            ),

            // Membre depuis (fade out)
            if (memberOpacity > 0)
              Positioned(
                left: 0,
                right: 0,
                top: memberY,
                child: Opacity(
                  opacity: memberOpacity,
                  child: Center(
                    child: isLoading
                        ? ShimmerBox(
                            width: 130.w,
                            height: 20.h,
                            borderRadius: 4.r,
                          )
                        : Text(
                            memberSince,
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w400,
                              letterSpacing: -0.42.r,
                              height: 1.4,
                              color: const Color(0xFF5E5E5E),
                            ),
                          ),
                  ),
                ),
              ),
          ],
        ),
      );
    });
  }

  Widget _buildAvatar(double size, double t) {
    final double editButtonOpacity = (1 - t * 3).clamp(0.0, 1.0);
    final double editButtonScale = (1 - t * 2).clamp(0.0, 1.0);
    final profileService = Get.find<ProfileImageService>();

    return GestureDetector(
      onTap: editButtonOpacity > 0.5 ? () => controller.pickProfileImage() : null,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Obx(() {
            final imagePath = profileService.profileImagePath.value;
            final hasImage = imagePath != null && 
                             imagePath.isNotEmpty && 
                             File(imagePath).existsSync();

            return ClipOval(
              child: hasImage
                  ? Image.file(
                      File(imagePath),
                      width: size,
                      height: size,
                      fit: BoxFit.cover,
                    )
                  : Container(
                      width: size,
                      height: size,
                      color: const Color(0xFFE8E8E8),
                      child: Icon(
                        Icons.person,
                        size: size * 0.5,
                        color: const Color(0xFFB0B0B0),
                      ),
                    ),
            );
          }),

          // Bouton edit/add
          if (editButtonOpacity > 0)
            Positioned(
              right: -2.r,
              bottom: -2.r,
              child: Transform.scale(
                scale: editButtonScale,
                child: Opacity(
                  opacity: editButtonOpacity,
                  child: Container(
                    height: 31.r,
                    width: 31.r,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: ClientTheme.primaryColor,
                    ),
                    child: Center(
                      child: Image.asset(
                        Assets.profilIconsEditProfilImage,
                        width: 16.r,
                        height: 16.r,
                      ),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
