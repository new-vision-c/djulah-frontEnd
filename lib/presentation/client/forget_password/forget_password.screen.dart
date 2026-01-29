import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';

import '../../../infrastructure/theme/client_theme.dart';
import '../../components/buttons/primary_button.widget.dart';
import 'controllers/forget_password.controller.dart';

class ForgetPasswordScreen extends GetView<ForgetPasswordController> {
  const ForgetPasswordScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        minimum: EdgeInsets.only(
          left: 16.r, right: 16.r, top: 64.r,bottom: 20.r ),
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
            //TODO: NE MARCHE PAS
          },
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
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
                  Text(
                    "Mot de Passe Oublié",
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
                    "Indiquez votre numéro ou email, on vous envoie un code de réinitialisation.",
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
                ],
              ),
              Flexible(
                fit: FlexFit.loose,
                child: SizedBox(
                  height: 327.r,
                ),
              ),
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
            ],
          ),
        ),
      ),
    );
  }
}
