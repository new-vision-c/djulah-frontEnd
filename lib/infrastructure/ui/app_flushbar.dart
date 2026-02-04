import 'package:another_flushbar/flushbar.dart';
import 'package:djulah/infrastructure/theme/client_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../shared/app_enums.dart';

class AppFlushBar {
  static void show(
    BuildContext context, {
    required String message,
    required MessageType type,
    String title = "",
  }) {
    // Retirer le focus avant d'afficher pour éviter que le clavier s'ouvre
    FocusManager.instance.primaryFocus?.unfocus();

    IconData icon;
    Color background;

    switch (type) {
      case MessageType.success:
        icon = FontAwesomeIcons.circleCheck;
        background = Colors.green;
        break;
      case MessageType.error:
        icon = FontAwesomeIcons.circleExclamation;
        background = ClientTheme.errorColor;
        break;
      case MessageType.warning:
        icon = FontAwesomeIcons.triangleExclamation;
        background = Colors.orange;
        break;
      case MessageType.info:
        icon = FontAwesomeIcons.circleInfo;
        background = Colors.blue;
        break;
    }

    Flushbar(
      message: message,
      title: title.isNotEmpty ? title : null,
      titleSize: title.isNotEmpty ? 13.sp : null,
      titleColor: Colors.white,
      icon: Icon(icon, size: 22, color: Colors.white),
      margin: const EdgeInsets.all(12),
      borderRadius: BorderRadius.circular(12),
      duration: const Duration(seconds: 6),
      backgroundColor: background,
      flushbarPosition: FlushbarPosition.BOTTOM,
      animationDuration: const Duration(milliseconds: 500),
      messageColor: Colors.white,
      messageSize: 11.sp,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
    ).show(context);
  }
}
