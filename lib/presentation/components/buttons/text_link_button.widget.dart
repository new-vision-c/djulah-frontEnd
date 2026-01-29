import 'package:djulah/infrastructure/theme/client_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TextLinkButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final Color? textColor;
  final double? width;
  final double? height;
  final double? fontSize;
  final FontWeight? fontWeight;
  final bool underline;

  const TextLinkButton({
    super.key,
    required this.text,
    this.onPressed,
    this.textColor,
    this.width,
    this.height,
    this.fontSize,
    this.fontWeight,
    this.underline = true,
  });

  @override
  Widget build(BuildContext context) {
    final color = textColor ?? ClientTheme.primaryColor;

    return SizedBox(
      height: height ?? 16.h,
      child: TextButton(
        onPressed: onPressed,
        style: ButtonStyle(
          overlayColor:
          MaterialStateProperty.all(Colors.transparent),
          splashFactory: NoSplash.splashFactory,
          padding: MaterialStateProperty.all(
            EdgeInsets.zero,
          ),
          minimumSize:
          MaterialStateProperty.all(const Size(0, 0)),
          tapTargetSize:
          MaterialTapTargetSize.shrinkWrap,
        ),
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: color,
            decoration:
            underline ? TextDecoration.underline : TextDecoration.none,
            decorationColor: underline ? color : null,
            decorationThickness: underline ? 1.0 : null,
            letterSpacing: -0.36,
            fontSize: fontSize ?? 12.r,
            height: 16.r / 12.r,
            fontFamily: "Geist",
            fontWeight: fontWeight ?? FontWeight.w400,
          ),
        ),
      ),
    );
  }
}
