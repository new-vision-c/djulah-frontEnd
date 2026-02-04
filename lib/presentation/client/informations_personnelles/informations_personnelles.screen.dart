import 'package:djulah/presentation/client/components/profil_avatar.dart';
import 'package:djulah/presentation/components/buttons/secondary_button.widget.dart';
import 'package:djulah/presentation/components/shimmer_box.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';

import '../components/app_bar.dart';
import 'controllers/informations_personnelles.controller.dart';

class InformationsPersonnellesScreen
    extends GetView<InformationsPersonnellesController> {
  const InformationsPersonnellesScreen({super.key});
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            AppBarCustom(title: "Information personnelles"),
            Expanded(
              child: Container(
                padding: EdgeInsets.only(top: 20.h, right: 16.r, left: 16.r),
                color: const Color(0xFFF3F3F3),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(horizontal: 20.r, vertical: 28.r),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16.r),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Center(
                            child: Column(
                              children: [
                                ProfilAvatar(
                                  size: 96.r,
                                  showEditButton: true,
                                ),
                                SizedBox(height: 8.h),
                                Text(
                                  "Appuyez pour modifier la photo",
                                  style: TextStyle(
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.w400,
                                    color: const Color(0xFF8E8E8E),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 18.h),
                          Text(
                            "Nom d'utilisateur",
                            style: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w600,
                              letterSpacing: -0.8.r,
                              height: 20.sp / 16.sp,
                              color: Colors.black,
                            ),
                          ),
                          SizedBox(height: 4.h),
                          _buildUserNameField(),
                          SizedBox(height: 20.h),
                          Text(
                            "Email",
                            style: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w600,
                              letterSpacing: -0.8.r,
                              height: 20.sp / 16.sp,
                              color: Colors.black,
                            ),
                          ),
                          SizedBox(height: 4.h),
                          _buildEmailField(),
                        ],
                      ),
                    ),
                    _buildActionButtons(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Champ nom d'utilisateur avec shimmer ou valeur par défaut
  Widget _buildUserNameField() {
    return Obx(() {
      // Mode édition
      if (controller.isEditMode.value) {
        return TextField(
          controller: controller.fullnameController,
          decoration: InputDecoration(
            hintText: 'Entrez votre nom',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.r),
            ),
            contentPadding: EdgeInsets.symmetric(
              horizontal: 12.r,
              vertical: 8.r,
            ),
          ),
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.w500,
            color: const Color(0xFF5E5E5E),
          ),
        );
      }

      // Chargement : shimmer
      if (controller.isLoading.value) {
        return ShimmerBox(
          width: 150.w,
          height: 20.h,
          borderRadius: 4.r,
        );
      }

      // Affichage : valeur ou "Inconnu" par défaut
      final displayName = controller.userName.value.isNotEmpty 
          ? controller.userName.value 
          : 'Inconnu';
      
      return Text(
        displayName,
        style: TextStyle(
          fontSize: 16.sp,
          fontWeight: FontWeight.w500,
          letterSpacing: -0.48.r,
          height: 20.sp / 16.sp,
          color: const Color(0xFF5E5E5E),
        ),
      );
    });
  }

  /// Champ email avec shimmer ou valeur par défaut
  Widget _buildEmailField() {
    return Obx(() {
      // Chargement : shimmer
      if (controller.isLoading.value) {
        return ShimmerBox(
          width: 200.w,
          height: 20.h,
          borderRadius: 4.r,
        );
      }

      // Affichage : valeur ou "Non renseigné" par défaut
      final displayEmail = controller.userEmail.value.isNotEmpty 
          ? controller.userEmail.value 
          : 'Non renseigné';
      
      return Text(
        displayEmail,
        style: TextStyle(
          fontSize: 16.sp,
          fontWeight: FontWeight.w500,
          letterSpacing: -0.48.r,
          height: 20.sp / 16.sp,
          color: const Color(0xFF5E5E5E),
        ),
      );
    });
  }

  /// Boutons d'action (Modifier / Annuler + Sauvegarder)
  Widget _buildActionButtons() {
    return Obx(() {
      if (controller.isEditMode.value) {
        return Row(
          children: [
            Expanded(
              child: SecondaryButton(
                onPressed: controller.isUpdating.value 
                    ? null 
                    : controller.cancelEditing,
                text: "Annuler",
                textColor: Colors.grey,
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: SecondaryButton(
                onPressed: controller.isUpdating.value ? null : null,
                text: controller.isUpdating.value ? "..." : "Sauvegarder",
                textColor: Colors.black,
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        );
      }
      return SecondaryButton(
        onPressed: controller.startEditing,
        text: "Modifier",
        textColor: Colors.black,
        fontSize: 16.sp,
        fontWeight: FontWeight.w600,
      );
    });
  }
}
