import 'package:djulah/infrastructure/theme/client_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SecondaryButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final Color? textColor;
  final double? width;
  final Widget? icon;
  final double? height;
  final double? fontSize;
  final FontWeight? fontWeight;
  final double? borderRadius;
  
  // Gestion des états (comme PrimaryButton)
  final bool isLoading;
  final String? loadingText;
  final Widget? loadingWidget;
  final bool isEnabled;
  final Color? activeColor;
  final Color? disabledColor;

  const SecondaryButton({
    super.key,
    required this.text,
    this.onPressed,
    this.textColor,
    this.width,
    this.height,
    this.fontSize,
    this.fontWeight,
    this.icon,
    this.borderRadius,
    this.isLoading = false,
    this.loadingText,
    this.loadingWidget,
    this.isEnabled = true,
    this.activeColor,
    this.disabledColor,
  });

  @override
  Widget build(BuildContext context) {
    final bool isButtonEnabled = isEnabled && !isLoading;
    final Color textButtonColor = !isEnabled || isLoading
        ? (disabledColor ?? ClientTheme.textDisabledColor)
        : (textColor ?? activeColor ?? ClientTheme.textPrimaryColor);

    return SizedBox(
      width: width ?? double.infinity,
      height: height ?? 48.h,
      child: TextButton(
        onPressed: isButtonEnabled ? onPressed : null,
        style: TextButton.styleFrom(
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius ?? 8.r),
          ),
          padding: EdgeInsets.symmetric(
            vertical: 12.r,
            horizontal: 14.r,
          ),
        ),
        child: Row(
          spacing: 8.r,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (isLoading) ...[
              loadingWidget ??
                  SizedBox(
                    width: 20.r,
                    height: 20.r,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(textButtonColor),
                    ),
                  ),
            ],
            if(!isLoading && icon != null) ...[
              icon!,
            ],
            Text(
              isLoading && loadingText != null ? loadingText! : text,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: textButtonColor,
                letterSpacing: -0.8,
                fontSize: fontSize ?? 16.r,
                height: 20.r / 16.r,
                fontFamily: "Geist",
                fontWeight: fontWeight ?? FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
