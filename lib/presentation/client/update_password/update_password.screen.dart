import 'package:djulah/presentation/components/buttons/primary_button.widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:get/get.dart';

import '../../../app/config/app_config.dart';
import '../../../infrastructure/theme/client_theme.dart';
import 'controllers/update_password.controller.dart';

class UpdatePasswordScreen extends GetView<UpdatePasswordController> {
  const UpdatePasswordScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: SafeArea(
        minimum: EdgeInsets.only(
          left: 16.r, right: 16.r, top: 64.r,bottom: 20.r ),
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: Column(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      GestureDetector(
                        onTap: (){
                          FocusScope.of(context).unfocus();
                          Get.back();
                        },
                        child: Icon(
                          Icons.arrow_back,
                          color: Colors.black,
                          size: 30.r,
                        ),
                      )
                    ],
                  ),
                  SizedBox(height: 16.r,),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Choisissez un nouveau mot de passe.",
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
                      SizedBox(height: 8.r,),
                      Text(
                        "description en attente",
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
                  SizedBox(height: 40.r,),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    spacing: 8.r,
                    children: [
                      Text(
                        "Nouveau mot de passe",
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
                          controller: controller.newPasswordController,
                          obscureText: !controller.isPasswordVisible.value,
                          onChanged: (password) =>
                          controller.newPassword.value = password,
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
                          controller: controller.confirmPasswordController,
                          obscureText: !controller.isPasswordVisible.value,
                          onChanged: (password) =>
                          controller.confirmPassword.value = password,
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
                            hintText: "Confirmer le nouveau mot de passe",
                          ),
                        );
                      }),

                    ],
                  ),
                ],
              ),
              Flexible(
                fit: FlexFit.loose,
                child: SizedBox(
                  height: 200.r,
                ),
              ),
              Obx(() {
                return PrimaryButton(
                  text: 'common.next'.tr,
                  isEnabled: controller.isFormValid,
                  disabledColor: ClientTheme.buttonDisabledColor,
                  onPressed: () async {
                    FocusScope.of(context).unfocus();
                    await controller.goToSuccessPage();
                  },
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}
