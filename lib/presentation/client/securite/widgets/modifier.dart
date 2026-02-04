import 'package:djulah/presentation/client/securite/controllers/securite.controller.dart';
import 'package:djulah/presentation/components/password_field.widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import '../../../../app/config/app_config.dart';
import '../../../../infrastructure/theme/client_theme.dart';
import '../../../components/buttons/primary_button.widget.dart';
import '../../components/app_bar.dart';

class ModifierScreen extends StatelessWidget {
  final controller = Get.find<SecuriteController>();

  ModifierScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            AppBarCustom(title: "Modifier"),
            SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.only(top: 20.h, right: 16.r, left: 16.r),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    PasswordField(
                      controller: controller.currentPasswordController,
                      isPasswordVisible: controller.isCurrentPasswordVisible,
                      passwordValue: controller.currentPassword,
                      label: "Mot de passe actuel",
                      hintText: 'auth.passwordPlaceholder'.tr,
                      validateComplexity: false,
                      onChanged: (password) {
                        controller.currentPassword.value = password;
                      },
                    ),
                    SizedBox(height: 28.r),
                    PasswordField(
                      controller: controller.newPasswordController,
                      isPasswordVisible: controller.isNewPasswordVisible,
                      passwordValue: controller.newPassword,
                      label: "Nouveau mot de passe",
                      hintText: "Entrer un mot de passe",
                      onChanged: (password) {
                        controller.newPassword.value = password;
                      },
                    ),
                    SizedBox(height: 28.r),
                    PasswordField(
                      controller: controller.confirmPasswordController,
                      isPasswordVisible: controller.isConfirmPasswordVisible,
                      passwordValue: controller.confirmPassword,
                      label: "Confirm password",
                      hintText: "Confirmer le nouveau mot de passe",
                      onChanged: (password) {
                        controller.confirmPassword.value = password;
                      },
                    ),
                    SizedBox(height: 28.r),
                    Obx(() {
                      return PrimaryButton(
                        text: 'common.next'.tr,
                        isEnabled: controller.isFormValid,
                        disabledColor: ClientTheme.buttonDisabledColor,
                        onPressed: () async {
                          FocusScope.of(context).unfocus();
                          await controller.enregistrer();
                        },
                      );
                    }),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
