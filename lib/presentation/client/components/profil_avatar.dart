import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../app/services/profile_cache_service.dart';
import '../../../app/services/profile_image_service.dart';
import '../../../generated/assets.dart';
import '../../../infrastructure/theme/client_theme.dart';
import '../../components/shimmer_box.dart';

class ProfilAvatar extends StatelessWidget {
  final double? size;
  
  final bool showEditButton;
  
  final double editButtonOpacity;
  
  final double editButtonScale;
  
  final VoidCallback? onTap;

  const ProfilAvatar({
    super.key,
    this.size,
    this.showEditButton = true,
    this.editButtonOpacity = 1.0,
    this.editButtonScale = 1.0,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final avatarSize = size ?? 96.r;
    
    return GestureDetector(
      onTap: onTap ?? (showEditButton && editButtonOpacity > 0.5 ? _pickImage : null),
      child: SizedBox.square(
        dimension: avatarSize,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            _buildAvatarImage(avatarSize),
            if (showEditButton && editButtonOpacity > 0)
              _buildEditButton(avatarSize),
          ],
        ),
      ),
    );
  }
  
  Widget _buildAvatarImage(double avatarSize) {
    final profileService = Get.find<ProfileImageService>();
    
    return Obx(() {
      if (profileService.isUploading.value) {
        return ShimmerBox(
          width: avatarSize,
          height: avatarSize,
          shape: BoxShape.circle,
        );
      }
      
      final localImagePath = profileService.profileImagePath.value;
      final hasLocalImage = localImagePath != null && 
                            localImagePath.isNotEmpty && 
                            File(localImagePath).existsSync();
      
      if (hasLocalImage) {
        return ClipOval(
          child: Image.file(
            File(localImagePath),
            width: avatarSize,
            height: avatarSize,
            fit: BoxFit.cover,
          ),
        );
      }
      
      String? remoteAvatarUrl;
      if (Get.isRegistered<ProfileCacheService>()) {
        remoteAvatarUrl = Get.find<ProfileCacheService>().user?.avatar;
      }
      
      if (remoteAvatarUrl != null && remoteAvatarUrl.isNotEmpty) {
        return ClipOval(
          child: Image.network(
            remoteAvatarUrl,
            width: avatarSize,
            height: avatarSize,
            fit: BoxFit.cover,
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) return child;
              return ShimmerBox(
                width: avatarSize,
                height: avatarSize,
                shape: BoxShape.circle,
              );
            },
            errorBuilder: (context, error, stackTrace) => _buildPlaceholder(avatarSize),
          ),
        );
      }
      
      return _buildPlaceholder(avatarSize);
    });
  }
  
  Widget _buildPlaceholder(double avatarSize) {
    return ClipOval(
      child: Container(
        width: avatarSize,
        height: avatarSize,
        color: const Color(0xFFE8E8E8),
        child: Icon(
          Icons.person,
          size: avatarSize * 0.5,
          color: const Color(0xFFB0B0B0),
        ),
      ),
    );
  }
  
  Widget _buildEditButton(double avatarSize) {
    final buttonSize = avatarSize > 60 ? 31.r : 24.r;
    final iconSize = avatarSize > 60 ? 16.r : 12.r;
    
    return Positioned(
      right: -2.r,
      bottom: -2.r,
      child: Transform.scale(
        scale: editButtonScale,
        child: Opacity(
          opacity: editButtonOpacity,
          child: Container(
            height: buttonSize,
            width: buttonSize,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: ClientTheme.primaryColor,
            ),
            child: Center(
              child: Image.asset(
                Assets.profilIconsEditProfilImage,
                width: iconSize,
                height: iconSize,
              ),
            ),
          ),
        ),
      ),
    );
  }
  
  void _pickImage() {
    if (Get.isRegistered<ProfileImageService>()) {
      Get.find<ProfileImageService>().pickImageFromCamera();
    }
  }
}