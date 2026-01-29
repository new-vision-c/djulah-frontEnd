import 'package:djulah/infrastructure/theme/client_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PrimaryButton extends StatelessWidget {
  final String text;
  final String? cheminIcon;
  final VoidCallback? onPressed;
  final Color? backgroundColor;
  final Color? textColor;
  final double? width;
  final double? height;
  final double? fontSize;
  final FontWeight? fontWeight;
  final double? borderRadius;
  
  // Gestion des états
  final bool isLoading;
  final String? loadingText;
  final Widget? loadingWidget;
  final bool isEnabled;
  final Color? activeColor;
  final Color? disabledColor;

  const PrimaryButton({
    super.key,
    required this.text,
    this.onPressed,
    this.backgroundColor,
    this.textColor,
    this.width,
    this.height,
    this.fontSize,
    this.fontWeight,
    this.borderRadius,
    this.cheminIcon,
    this.isLoading = false,
    this.loadingText,
    this.loadingWidget,
    this.isEnabled = true,
    this.activeColor,
    this.disabledColor,
  });

  @override
  Widget build(BuildContext context) {
    // Si backgroundColor est fourni, on utilise le comportement simple (un seul état)
    if (backgroundColor != null) {
      return SizedBox(
        width: width ?? double.infinity,
        height: height ?? 48.h,
        child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: backgroundColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(borderRadius ?? 8.r),
            ),
            elevation: 0,
            padding: EdgeInsets.symmetric(
              vertical: 12.h,
              horizontal: 14.w,
            ),
          ),
          child: Row(
            spacing: 8.r,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if(cheminIcon != null)
                Image.asset(cheminIcon!, height: 20.r, width: 20.r),
              Text(
                text,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: textColor ?? Colors.white,
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

    // Gestion des états (actif, désactivé, loading)
    final bool isButtonEnabled = isEnabled && !isLoading;
    final Color buttonColor = !isEnabled || isLoading
        ? (disabledColor ?? ClientTheme.buttonDisabledColor)
        : (activeColor ?? ClientTheme.primaryColor);
    final Color textButtonColor = !isEnabled || isLoading
        ? ClientTheme.textDisabledColor
        : (textColor ?? Colors.white);

    return SizedBox(
      width: width ?? double.infinity,
      height: height ?? 48.h,
      child: ElevatedButton(
        onPressed: isButtonEnabled ? onPressed : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: buttonColor,
          foregroundColor: textButtonColor,
          disabledBackgroundColor: buttonColor,
          disabledForegroundColor: textButtonColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius ?? 8.r),
          ),
          elevation: 0,
          padding: EdgeInsets.symmetric(
            vertical: 12.h,
            horizontal: 14.w,
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
            ] else ...[
              if(cheminIcon != null)
                Image.asset(cheminIcon!, height: 20.r, width: 20.r),
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
