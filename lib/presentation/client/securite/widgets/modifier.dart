import 'package:djulah/presentation/client/securite/controllers/securite.controller.dart';
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
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      spacing: 8.r,
                      children: [
                        Text(
                          "Mot de passe actuel",
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontStyle: FontStyle.normal,
                            fontWeight: FontWeight.w500,
                            letterSpacing: -0.8.r,
                            height: 20.sp / 16.sp,
                            color: Colors.black,
                          ),
                        ),
                        Obx(() {
                          return TextField(
                            scrollPadding: EdgeInsets.zero,
                            controller: controller.currentPasswordController,
                            obscureText: !controller.isCurrentPasswordVisible.value,
                            onChanged: (password) =>
                            controller.currentPassword.value = password,
                            keyboardType: TextInputType.text,
                            style: TextStyle(
                              fontSize: 16.sp,
                              fontStyle: FontStyle.normal,
                              fontWeight: FontWeight.w400,
                              letterSpacing: -0.48.r,
                              height: 20.sp / 24.sp,
                              color: Colors.black,
                            ),
                            decoration: InputDecoration(
                              hintStyle: TextStyle(
                                color: ClientTheme.textTertiaryColor,
                                fontSize: 16.sp,
                                fontStyle: FontStyle.normal,
                                fontWeight: FontWeight.w400,
                                letterSpacing: -0.48.r,
                                height: 20.sp / 24.sp,
        
                              ),
                              contentPadding: EdgeInsets.all(8.r),
                              errorText: controller.currentPassword.isEmpty
                                  ? null
                                  : controller.currentPassword.value.length < 8
                                  ? 'validation.passwordMinLength'.trParams({
                                'count': AppConfig.limitCharPassword.value.toString()
                              })
                                  : null,
                              filled: true,
                              errorStyle: TextStyle(
                                  color: ClientTheme.errorColor,
                                  fontSize: 12.sp
                              ),
                              suffixIcon: GestureDetector(
                                onTap: () {
                                  controller.isCurrentPasswordVisible.value =
                                  !controller.isCurrentPasswordVisible.value;
                                },
                                child: Container(
                                  padding: EdgeInsets.all(18.r),
                                  child: SvgPicture.asset(
                                    "assets/images/client/eye.svg",
                                    fit: BoxFit.cover,
                                    color: controller.isCurrentPasswordVisible.value
                                        ? ClientTheme.primaryColor
                                        : Colors.black,
                                    alignment: AlignmentGeometry.center,
        
                                  ),
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.r),
                                borderSide: BorderSide(
                                  color: ClientTheme.primaryColor,
                                ),
                              ),
                              fillColor: ClientTheme.inputBackgroundColor,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.r),
                                borderSide: BorderSide.none,
                              ),
                              hintText: 'auth.passwordPlaceholder'.tr,
                            ),
                          );
                        }),
                      ],
                    ),
                    SizedBox(height: 28.r),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      spacing: 8.r,
                      children: [
                        Text(
                          "Nouveau mot de passe",
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontStyle: FontStyle.normal,
                            fontWeight: FontWeight.w500,
                            letterSpacing: -0.8.r,
                            height: 20.sp / 16.sp,
                            color: Colors.black,
                          ),
                        ),
                        Obx(() {
                          return TextField(
                            scrollPadding: EdgeInsets.zero,
                            controller: controller.newPasswordController,
                            obscureText: !controller.isNewPasswordVisible.value,
                            onChanged: (password) =>
                            controller.newPassword.value = password,
                            keyboardType: TextInputType.text,
                            style: TextStyle(
                              fontSize: 16.sp,
                              fontStyle: FontStyle.normal,
                              fontWeight: FontWeight.w400,
                              letterSpacing: -0.48.r,
                              height: 20.sp / 24.sp,
                              color: Colors.black,
                            ),
                            decoration: InputDecoration(
                              hintStyle: TextStyle(
                                color: ClientTheme.textTertiaryColor,
                                fontSize: 16.sp,
                                fontStyle: FontStyle.normal,
                                fontWeight: FontWeight.w400,
                                letterSpacing: -0.48.r,
                                height: 20.sp / 24.sp,
        
                              ),
                              contentPadding: EdgeInsets.all(8.r),
                              errorText: controller.newPassword.isEmpty
                                  ? null
                                  : controller.newPassword.value.length < 8
                                  ? 'validation.passwordMinLength'.trParams({
                                'count': AppConfig.limitCharPassword.value.toString()
                              })
                                  : null,
                              filled: true,
                              errorStyle: TextStyle(
                                  color: ClientTheme.errorColor,
                                  fontSize: 12.sp
                              ),
                              suffixIcon: GestureDetector(
                                onTap: () {
                                  controller.isNewPasswordVisible.value =
                                  !controller.isNewPasswordVisible.value;
                                },
                                child: Container(
                                  padding: EdgeInsets.all(18.r),
                                  child: SvgPicture.asset(
                                    "assets/images/client/eye.svg",
                                    fit: BoxFit.cover,
                                    color: controller.isNewPasswordVisible.value
                                        ? ClientTheme.primaryColor
                                        : Colors.black,
                                    alignment: AlignmentGeometry.center,
        
                                  ),
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.r),
                                borderSide: BorderSide(
                                  color: ClientTheme.primaryColor,
                                ),
                              ),
                              fillColor: ClientTheme.inputBackgroundColor,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.r),
                                borderSide: BorderSide.none,
                              ),
                              hintText: "Entrer un mot de passe",
                            ),
                          );
                        }),
                      ],
                    ),
                    SizedBox(height: 28.r),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      spacing: 8.r,
                      children: [
                        Text(
                          "Confirm password",
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontStyle: FontStyle.normal,
                            fontWeight: FontWeight.w500,
                            letterSpacing: -0.8.r,
                            height: 20.sp / 16.sp,
                            color: Colors.black,
                          ),
                        ),
                        Obx(() {
                          return TextField(
                            scrollPadding: EdgeInsets.zero,
                            controller: controller.confirmPasswordController,
                            obscureText: !controller.isConfirmPasswordVisible.value,
                            onChanged: (password) =>
                            controller.confirmPassword.value = password,
                            keyboardType: TextInputType.text,
                            style: TextStyle(
                              fontSize: 16.sp,
                              fontStyle: FontStyle.normal,
                              fontWeight: FontWeight.w400,
                              letterSpacing: -0.48.r,
                              height: 20.sp / 24.sp,
                              color: Colors.black,
                            ),
                            decoration: InputDecoration(
                              hintStyle: TextStyle(
                                color: ClientTheme.textTertiaryColor,
                                fontSize: 16.sp,
                                fontStyle: FontStyle.normal,
                                fontWeight: FontWeight.w400,
                                letterSpacing: -0.48.r,
                                height: 20.sp / 24.sp,
        
                              ),
                              contentPadding: EdgeInsets.all(8.r),
                              errorText: controller.confirmPassword.isEmpty
                                  ? null
                                  : controller.confirmPassword.value.length < 8
                                  ? 'validation.passwordMinLength'.trParams({
                                'count': AppConfig.limitCharPassword.value.toString()
                              })
                                  :  !(controller.confirmPassword.value == controller.newPassword.value)
                                  ? "les 02 champs doivent etre les meme"
                                  : null,
                              filled: true,
                              errorStyle: TextStyle(
                                  color: ClientTheme.errorColor,
                                  fontSize: 12.sp
                              ),
                              suffixIcon: GestureDetector(
                                onTap: () {
                                  controller.isConfirmPasswordVisible.value =
                                  !controller.isConfirmPasswordVisible.value;
                                },
                                child: Container(
                                  padding: EdgeInsets.all(18.r),
                                  child: SvgPicture.asset(
                                    "assets/images/client/eye.svg",
                                    fit: BoxFit.cover,
                                    color: controller.isConfirmPasswordVisible.value
                                        ? ClientTheme.primaryColor
                                        : Colors.black,
                                    alignment: AlignmentGeometry.center,
        
                                  ),
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.r),
                                borderSide: BorderSide(
                                  color: ClientTheme.primaryColor,
                                ),
                              ),
                              fillColor: ClientTheme.inputBackgroundColor,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.r),
                                borderSide: BorderSide.none,
                              ),
                              hintText: "Confirmer le nouveau mot de passe",
                            ),
                          );
                        }),
        
                      ],
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
