import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import '../../app/config/app_config.dart';
import '../../infrastructure/theme/client_theme.dart';

/// Widget réutilisable pour les champs de mot de passe
/// Compatible avec la validation backend qui exige au moins 2 types de caractères différents
class PasswordField extends StatelessWidget {
  final TextEditingController controller;
  final RxBool isPasswordVisible;
  final RxString passwordValue;
  final String? label;
  final String? hintText;
  final Function(String)? onChanged;
  final bool showValidation;
  final bool validateComplexity;

  const PasswordField({
    super.key,
    required this.controller,
    required this.isPasswordVisible,
    required this.passwordValue,
    this.label,
    this.hintText,
    this.onChanged,
    this.showValidation = true,
    this.validateComplexity = true,
  });

  /// Valide la complexité du mot de passe selon les règles du backend
  /// Doit contenir au moins 2 types de caractères différents parmi:
  /// - minuscules (a-z)
  /// - majuscules (A-Z)
  /// - chiffres (0-9)
  /// - caractères spéciaux
  static String? validatePassword(String password, {
    bool checkComplexity = true,
    int minLength = 8,
  }) {
    if (password.isEmpty) {
      return null;
    }

    // Vérifier la longueur minimale
    if (password.length < minLength) {
      return 'validation.passwordMinLength'.trParams({
        'count': minLength.toString(),
      });
    }

    // Vérifier la complexité (au moins 2 types de caractères)
    if (checkComplexity) {
      int typeCount = 0;

      // Vérifier présence de minuscules
      if (RegExp(r'[a-z]').hasMatch(password)) {
        typeCount++;
      }

      // Vérifier présence de majuscules
      if (RegExp(r'[A-Z]').hasMatch(password)) {
        typeCount++;
      }

      // Vérifier présence de chiffres
      if (RegExp(r'[0-9]').hasMatch(password)) {
        typeCount++;
      }

      // Vérifier présence de caractères spéciaux
      if (RegExp(r'[!@#$%^&*(),.?":{}|<>_\-+=\[\]\\\/;`~]').hasMatch(password)) {
        typeCount++;
      }

      if (typeCount < 2) {
        return 'validation.passwordComplexity'.tr;
      }
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      spacing: 8.r,
      children: [
        if (label != null)
          Text(
            label!,
            style: TextStyle(
              fontSize: 16.r,
              fontStyle: FontStyle.normal,
              fontWeight: FontWeight.w500,
              letterSpacing: -0.8.r,
              height: 20.r / 16.r,
              color: Colors.black,
            ),
          ),
        Obx(() {
          return TextField(
            scrollPadding: EdgeInsets.zero,
            controller: controller,
            obscureText: !isPasswordVisible.value,
            onChanged: (password) {
              passwordValue.value = password;
              onChanged?.call(password);
            },
            keyboardType: TextInputType.text,
            style: TextStyle(
              fontSize: 16.r,
              fontStyle: FontStyle.normal,
              fontWeight: FontWeight.w400,
              letterSpacing: -0.48.r,
              height: 20.r / 24.r,
              color: Colors.black,
            ),
            decoration: InputDecoration(
              hintStyle: TextStyle(
                color: ClientTheme.textTertiaryColor,
                fontSize: 16.r,
                fontStyle: FontStyle.normal,
                fontWeight: FontWeight.w400,
                letterSpacing: -0.48.r,
                height: 20.r / 24.r,
              ),
              contentPadding: EdgeInsets.all(8.r),
              errorText: showValidation
                  ? validatePassword(
                      passwordValue.value,
                      checkComplexity: validateComplexity,
                      minLength: AppConfig.limitCharPassword.value,
                    )
                  : null,
              filled: true,
              errorStyle: TextStyle(
                color: ClientTheme.errorColor,
                fontSize: 12.sp,
              ),
              errorMaxLines: 3,
              suffixIcon: GestureDetector(
                onTap: () {
                  isPasswordVisible.value = !isPasswordVisible.value;
                },
                child: Container(
                  padding: EdgeInsets.all(18.r),
                  child: SvgPicture.asset(
                    "assets/images/client/eye.svg",
                    fit: BoxFit.cover,
                    color: isPasswordVisible.value
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
              hintText: hintText ?? 'auth.passwordPlaceholder'.tr,
            ),
          );
        }),
      ],
    );
  }
}
