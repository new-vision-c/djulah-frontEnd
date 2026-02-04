import 'package:djulah/presentation/components/buttons/primary_button.widget.dart';
import 'package:djulah/presentation/components/password_field.widget.dart';
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
    return Scaffold(
      backgroundColor: Colors.white,
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
                  PasswordField(
                    controller: controller.newPasswordController,
                    isPasswordVisible: controller.isPasswordVisible,
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
                    isPasswordVisible: controller.isPasswordVisible,
                    passwordValue: controller.confirmPassword,
                    label: "Confirm password",
                    hintText: "Confirmer le nouveau mot de passe",
                    onChanged: (password) {
                      controller.confirmPassword.value = password;
                    },
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
