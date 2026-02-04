import 'package:djulah/app/config/app_config.dart';
import 'package:djulah/app/services/profile_cache_service.dart';
import 'package:djulah/datas/local_storage/app_storage.dart';
import 'package:djulah/generated/assets.dart';
import 'package:djulah/infrastructure/navigation/route_names.dart';
import 'package:djulah/presentation/client/components/option.dart';
import 'package:djulah/presentation/client/components/profil_avatar.dart';
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
        _sectionTitle('profil_screen.customize'.tr),
        SizedBox(height: 16.h),
        Option(
          title: 'profil_screen.personal_info'.tr,
          imagePath: Assets.profilIconsUser,
          onTap: () => Get.toNamed(RouteNames.clientInformationsPersonnelles),
        ),
        SizedBox(height: 16.h),
        Option(
          title: 'profil_screen.history'.tr,
          imagePath: Assets.profilIconsListRestart,
          onTap: () => Get.toNamed(RouteNames.clientHistorique),
        ),
        SizedBox(height: 28.h),
        _sectionTitle('profil_screen.accessibility'.tr),
        SizedBox(height: 16.h),
        Option(
          title: 'profil_screen.settings'.tr,
          imagePath: Assets.profilIconsUser,
          onTap: () => Get.toNamed(RouteNames.clientParametres),
        ),
        SizedBox(height: 28.h),
        _sectionTitle('profil_screen.privacy'.tr),
        SizedBox(height: 16.h),
        Option(
          title: 'profil_screen.terms'.tr,
          imagePath: Assets.profilIconsBookText,
          onTap: () => Get.toNamed(RouteNames.clientTermesUtilisation),
        ),
        SizedBox(height: 16.h),
        Option(
          title: 'profil_screen.privacy_policy'.tr,
          imagePath: Assets.profilIconsShieldAlert,
          onTap: () => Get.toNamed(RouteNames.clientPolitiqueConfidentialite),
        ),
        SizedBox(height: 16.h),
        Option(
          title: 'profil_screen.data_usage'.tr,
          imagePath: Assets.profilIconsDatabase,
          onTap: () => Get.toNamed(RouteNames.clientUtilisationDonnees),
        ),
        SizedBox(height: 28.h),
        Option(
          title: 'profil_screen.logout'.tr,
          isLogouted: true,
          imagePath: Assets.profilIconsLogOut,
          onTap: () => _logout(),
        ),
        SizedBox(height: 32.h),
      ],
    );
  }
  
  /// Déconnexion : supprime les tokens et redirige vers login
  Future<void> _logout() async {
    AppConfig.showLoading(message: 'loading.logout'.tr);
    
    try {
      // Supprimer tous les tokens
      final storage = Get.find<AppStorage>();
      await storage.clearAuth();
      
      // Vider le cache du profil
      if (Get.isRegistered<ProfileCacheService>()) {
        Get.find<ProfileCacheService>().clearCache();
      }
      
      // Rediriger vers login
      Get.offAllNamed(RouteNames.clientLogin);
    } finally {
      AppConfig.hideLoading();
    }
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
      
      // Calcul des opacités/scales pour le bouton d'édition
      final double editButtonOpacity = (1 - t * 3).clamp(0.0, 1.0);
      final double editButtonScale = (1 - t * 2).clamp(0.0, 1.0);

      return Container(
        color: Colors.white,
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Avatar - ProfilAvatar gère déjà le shimmer et l'image locale
            Positioned(
              left: avatarX,
              top: avatarY,
              child: SizedBox(
                width: avatarSize,
                height: avatarSize,
                child: ProfilAvatar(
                  size: avatarSize,
                  showEditButton: true,
                  editButtonOpacity: editButtonOpacity,
                  editButtonScale: editButtonScale,
                  onTap: editButtonOpacity > 0.5 
                      ? () => controller.pickProfileImage() 
                      : null,
                ),
              ),
            ),

            // Nom - affiche la valeur par défaut si en chargement
            Positioned(
              left: nameCollapsedX * t,
              right: 16.r * t,
              top: nameY,
              child: Align(
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

            // Membre depuis (fade out) - affiche la valeur par défaut
            if (memberOpacity > 0)
              Positioned(
                left: 0,
                right: 0,
                top: memberY,
                child: Opacity(
                  opacity: memberOpacity,
                  child: Center(
                    child: Text(
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
}