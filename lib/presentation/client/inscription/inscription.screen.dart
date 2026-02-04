import 'package:djulah/infrastructure/navigation/route_names.dart';
import 'package:djulah/infrastructure/theme/client_theme.dart';
import 'package:djulah/presentation/components/buttons/primary_button.widget.dart';
import 'package:djulah/presentation/components/password_field.widget.dart';
import 'package:djulah/presentation/client/components/social_auth_buttons.dart';
import 'package:djulah/presentation/client/components/auth_collapsible_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';

import 'controllers/inscription.controller.dart';

class InscriptionScreen extends GetView<InscriptionController> {
  const InscriptionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.white,
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: CustomScrollView(
          controller: controller.scrollController,
          physics: const BouncingScrollPhysics(),
          slivers: [
            AuthCollapsibleHeader(
              title: 'auth.welcome'.tr,
              subtitle: 'auth.signupSubtitle'.tr,
              startAnimation: controller.startAnimation,
              onLogoTap: () {
                if (Get.key.currentState!.canPop()) {
                  controller.startAnimation.value = false;
                  Get.back();
                } else {
                  Get.toNamed(RouteNames.clientSplashScreenCustom);
                }
              },
            ),
            SliverPadding(
              padding: EdgeInsets.symmetric(horizontal: 16.r),
              sliver: SliverToBoxAdapter(
                child: Obx(() {
                  return AnimatedOpacity(
                    duration: const Duration(milliseconds: 200),
                    curve: Curves.easeInOut,
                    opacity: controller.startAnimation.value ? 1.0 : 0.0,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(height: 24.r),
                        Obx(() => SocialAuthButtons(
                          onGooglePressed: controller.onGoogleSignIn,
                          onApplePressed: controller.onAppleSignIn,
                          isLoading: controller.isGoogleLoading.value,
                          loadingProvider: controller.loadingProvider.value,
                        )),
                        
                        SizedBox(height: 28.r),
                        
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            SizedBox(width: 97.5.r, child: const Divider()),
                            Text(
                              'auth.orContinueWithEmail'.tr,
                              style: TextStyle(
                                color: ClientTheme.textSecondaryColor,
                                height: 16.r / 12.r,
                                fontWeight: FontWeight.w400,
                                fontStyle: FontStyle.normal,
                                letterSpacing: -0.36.r,
                                fontSize: 12.r,
                              ),
                            ),
                            SizedBox(width: 97.5.r, child: const Divider()),
                          ],
                        ),
                        
                        SizedBox(height: 28.r),
                        
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'auth.email'.tr,
                              style: TextStyle(
                                fontSize: 16.r,
                                fontStyle: FontStyle.normal,
                                fontWeight: FontWeight.w500,
                                letterSpacing: -0.8,
                                height: 20.r / 16.r,
                                color: Colors.black,
                              ),
                            ),
                            SizedBox(height: 8.r),
                            Obx(() {
                              return TextField(
                                scrollPadding: EdgeInsets.zero,
                                controller: controller.emailController,
                                onChanged: (email) => controller.email.value = email,
                                keyboardType: TextInputType.emailAddress,
                                style: TextStyle(
                                  fontSize: 16.r,
                                  fontStyle: FontStyle.normal,
                                  fontWeight: FontWeight.w400,
                                  letterSpacing: -0.48,
                                  height: 20.r / 24.r,
                                  color: Colors.black,
                                ),
                                decoration: InputDecoration(
                                  hintStyle: TextStyle(
                                    color: ClientTheme.textTertiaryColor,
                                    fontSize: 16.r,
                                    fontStyle: FontStyle.normal,
                                    fontWeight: FontWeight.w400,
                                    letterSpacing: -0.48,
                                    height: 20.r / 24.r,
                                  ),
                                  contentPadding: EdgeInsets.all(8.r),
                                  filled: true,
                                  suffixIcon: Padding(
                                    padding: EdgeInsets.all(10.r),
                                    child: AnimatedSwitcher(
                                      duration: const Duration(milliseconds: 200),
                                      transitionBuilder: (child, anim) =>
                                          FadeTransition(opacity: anim, child: child),
                                      child: controller.email.value.isEmpty
                                          ? const Icon(
                                              Icons.mark_email_read_rounded,
                                              color: Colors.black,
                                            )
                                          : GetUtils.isEmail(controller.email.value)
                                              ? const Icon(
                                                  Icons.check_circle,
                                                  key: ValueKey('ok'),
                                                  color: ClientTheme.primaryColor,
                                                )
                                              : const Icon(
                                                  Icons.error_outline,
                                                  key: ValueKey('err'),
                                                  color: ClientTheme.errorColor,
                                                ),
                                    ),
                                  ),
                                  errorText: controller.email.isEmpty
                                      ? null
                                      : !GetUtils.isEmail(controller.email.value)
                                          ? 'validation.emailInvalid'.tr
                                          : null,
                                  errorStyle: TextStyle(
                                    color: ClientTheme.errorColor,
                                    fontSize: 12.sp,
                                  ),
                                  focusedErrorBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8.r),
                                    borderSide: const BorderSide(
                                      color: ClientTheme.errorColor,
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8.r),
                                    borderSide: const BorderSide(
                                      color: ClientTheme.primaryColor,
                                    ),
                                  ),
                                  fillColor: ClientTheme.inputBackgroundColor,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8.r),
                                    borderSide: BorderSide.none,
                                  ),
                                  hintText: 'auth.emailPlaceholder'.tr,
                                ),
                              );
                            }),
                          ],
                        ),
                        
                        SizedBox(height: 28.r),
                        
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'auth.username'.tr,
                              style: TextStyle(
                                fontSize: 16.r,
                                fontStyle: FontStyle.normal,
                                fontWeight: FontWeight.w500,
                                letterSpacing: -0.8,
                                height: 20.r / 16.r,
                                color: Colors.black,
                              ),
                            ),
                            SizedBox(height: 8.r),
                            Obx(() => TextField(
                              scrollPadding: EdgeInsets.zero,
                              controller: controller.nameController,
                              onChanged: (name) => controller.name.value = name,
                              keyboardType: TextInputType.text,
                              style: TextStyle(
                                fontSize: 16.r,
                                fontStyle: FontStyle.normal,
                                fontWeight: FontWeight.w400,
                                letterSpacing: -0.48,
                                height: 20.r / 24.r,
                                color: Colors.black,
                              ),
                              decoration: InputDecoration(
                                hintStyle: TextStyle(
                                  color: ClientTheme.textTertiaryColor,
                                  fontSize: 16.r,
                                  fontStyle: FontStyle.normal,
                                  fontWeight: FontWeight.w400,
                                  letterSpacing: -0.48,
                                  height: 20.r / 24.r,
                                ),
                                contentPadding: EdgeInsets.all(8.r),
                                filled: true,
                                suffixIcon: Container(
                                  padding: EdgeInsets.all(10.r),
                                  child: Icon(
                                    Icons.person_pin,
                                    color: controller.name.value.isNotEmpty
                                        ? ClientTheme.primaryColor
                                        : Colors.black,
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8.r),
                                  borderSide: const BorderSide(
                                    color: ClientTheme.primaryColor,
                                  ),
                                ),
                                fillColor: ClientTheme.inputBackgroundColor,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8.r),
                                  borderSide: BorderSide.none,
                                ),
                                hintText: 'auth.usernamePlaceholder'.tr,
                              ),
                            )),
                          ],
                        ),
                        
                        SizedBox(height: 28.r),
                        
                        // Champ mot de passe
                        PasswordField(
                          controller: controller.passwordController,
                          isPasswordVisible: controller.isPasswordVisible,
                          passwordValue: controller.password,
                          label: 'auth.password'.tr,
                          hintText: 'auth.passwordPlaceholder'.tr,
                          onChanged: (password) {
                            controller.password.value = password;
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
                              await controller.goToVerificationEmail();
                            },
                          );
                        }),
                        
                        SizedBox(height: 60.r),
                        
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              'auth.alreadyHaveAccount'.tr,
                              style: TextStyle(
                                color: ClientTheme.textSecondaryColor,
                                fontSize: 12.r,
                                fontStyle: FontStyle.normal,
                                fontWeight: FontWeight.w400,
                                letterSpacing: -0.36,
                                height: 16.r / 12.r,
                              ),
                            ),
                            SizedBox(width: 5.r),
                            GestureDetector(
                              onTap: () => Get.toNamed(RouteNames.clientLogin),
                              child: Text(
                                'auth.login'.tr,
                                style: TextStyle(
                                  color: ClientTheme.primaryColor,
                                  fontSize: 12.r,
                                  fontStyle: FontStyle.normal,
                                  fontWeight: FontWeight.w400,
                                  letterSpacing: -0.36,
                                  height: 16.r / 12.r,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 28.r + MediaQuery.of(context).viewInsets.bottom*0.2),
                      ],
                    ),
                  );
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }
}


