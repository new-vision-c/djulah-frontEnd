import 'package:djulah/infrastructure/navigation/route_names.dart';
import 'package:djulah/infrastructure/theme/client_theme.dart';
import 'package:djulah/presentation/components/buttons/primary_button.widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import 'package:get/get.dart';

import '../../../app/config/app_config.dart';
import 'controllers/inscription.controller.dart';

class InscriptionScreen extends GetView<InscriptionController> {
  const InscriptionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body:  SafeArea(
        minimum: EdgeInsets.only( left: 16.r, right:16.r),
      child: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: NotificationListener<ScrollNotification>(
            onNotification: (notification) {
              if (notification is ScrollUpdateNotification) {
                return true;
              }
              return false;
            },
            child: ListView(
              controller: controller.scrollController,
              padding: EdgeInsets.only( top:40.r,bottom: 28.r + MediaQuery.of(context).viewInsets.bottom),
              physics: ScrollPhysics(),
              children: [
                Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    GestureDetector(
                      onTap: () {
                        if(Get.key.currentState!.canPop()){
                          controller.startAnimation.value=false;
                          Get.back();
                        }
                        else{
                          Get.toNamed(RouteNames.clientSplashScreenCustom);                        }
                      },
                      child: Hero(
                        tag: "logo",
                        child: Image(
                          image: AssetImage("assets/images/client/logo djulah.png"),
                          height: 48.r,
                          width: 48.r,
                        ),
                      ),
                    ),
                  ],
                ),
                Obx(() {
                  return AnimatedOpacity(
                    duration: const Duration(milliseconds: 200),
                    curve: Curves.easeInOut,
                    opacity: controller.startAnimation.value ? 1.0 : 0.0,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(height: 20.r),
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          spacing: 8.r,
                          children: [
                            Text(
                              'auth.welcome'.tr,
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                fontSize: 24.r,
                                fontStyle: FontStyle.normal,
                                fontWeight: FontWeight.w600,
                                letterSpacing: -1.2,
                                height: 32.r / 24.r,
                                color: Colors.black,
                              ),
                            ),
                            Text(
                              'auth.signupSubtitle'.tr,
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
                          ],
                        ),
                        SizedBox(height: 24.r),
                        PrimaryButton(
                          text: 'auth.continueWithGoogle'.tr,
                          backgroundColor: ClientTheme.inputBackgroundColor,
                          textColor: Colors.black,
                          fontWeight: FontWeight.w500,
                          cheminIcon: "assets/images/client/Logos_google.png",
                        ),
                        SizedBox(height: 20.r),
                        PrimaryButton(
                          text: 'auth.continueWithApple'.tr,
                          backgroundColor: ClientTheme.inputBackgroundColor,
                          textColor: Colors.black,
                          fontWeight: FontWeight.w500,
                          cheminIcon: "assets/images/client/Logos_apple.png",
                        ),
                        SizedBox(height: 28.r),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            SizedBox(width: 97.5.r, child: Divider()),
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
                            SizedBox(width: 97.5.r, child: Divider()),
                          ],
                        ),
                        SizedBox(height: 28.r),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          spacing: 8.r,
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
                            Obx(() {
                              return TextField(
                                scrollPadding: EdgeInsets.zero,
                                controller: controller.emailController,
                                onChanged: (email) =>
                                controller.email.value = email,
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
                                  suffixIcon: Padding(
                                    padding:  EdgeInsets.all(10.r),
                                    child: AnimatedSwitcher(
                                      duration: const Duration(milliseconds: 200),
                                      transitionBuilder: (child, anim) =>
                                          FadeTransition(
                                              opacity: anim, child: child),
                                      child: controller.email.value.isEmpty
                                          ? Icon(
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
                                      fontSize: 12.sp
                                  ),
                                  focusedErrorBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8.r),
                                    borderSide: BorderSide(
                                      color: ClientTheme.errorColor,
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
                          spacing: 8.r,
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
                            TextField(
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
                                    color:   controller.name.value.isNotEmpty?ClientTheme.primaryColor:Colors.black,
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
                                hintText: 'auth.usernamePlaceholder'.tr,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 28.r),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          spacing: 8.r,
                          children: [
                            Text(
                              'auth.password'.tr,
                              style: TextStyle(
                                fontSize: 16.r,
                                fontStyle: FontStyle.normal,
                                fontWeight: FontWeight.w500,
                                letterSpacing: -0.8,
                                height: 20.r / 16.r,
                                color: Colors.black,
                              ),
                            ),
                            Obx(() {
                              return TextField(
                                scrollPadding: EdgeInsets.zero,
                                controller: controller.passwordController,
                                obscureText: !controller.isPasswordVisible.value,
                                onChanged: (password) =>
                                controller.password.value = password,
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
                                  errorText: controller.password.isEmpty
                                      ? null
                                      : controller.password.value.length < 8
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
                                      controller.isPasswordVisible.value =
                                      !controller.isPasswordVisible.value;
                                    },
                                    child: Container(
                                      padding: EdgeInsets.all(18.r),
                                      child: SvgPicture.asset(
                                        "assets/images/client/eye.svg",
                                        fit: BoxFit.cover,
                                        color: controller.isPasswordVisible.value
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
                        SizedBox(height: 70.r,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          spacing: 5.r,
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
                        )
            
                      ],
                    ),
                  );
                }),
              ],
            ),
          ),
        ),
      )
    );
  }
}


