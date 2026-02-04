import 'package:flutter/material.dart';

class ClientTheme {
  static const Color primaryColor = Color(0xFF1EABE2);
  static const Color secondaryColor = Color(0xFFFFF800);
  static const Color backgroundColor = Colors.white;
  static const Color errorColor = Colors.red;
  static const Color textPrimaryColor = Colors.black;
  static const Color shadowColor = Color(0x40000000); // rgba(0, 0, 0, 0.25)

  static const Color pinInputBackground = Color(0xFFE8E8E8);
  static const Color pinInputDotColor = Colors.black;
  static const Color pinInputDotBorder = Colors.black;
  
  static const Color textSecondaryColor = Color(0xFF4B4B4B);
  static const Color textTertiaryColor = Color(0xFF5E5E5E);
  static const Color textDisabledColor = Color(0xFFA6A6A6);
  
  static const Color inputBackgroundColor = Color(0xFFF3F3F3);
  static const Color inputBorderColor = Colors.transparent;
  
  static const Color buttonDisabledColor = Color(0xFFF3F3F3);
  
  static ThemeData get lightTheme {
    return ThemeData(
      fontFamily: "Geist",
      primaryColor: primaryColor,

      scaffoldBackgroundColor: backgroundColor,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryColor,
        brightness: Brightness.light,
        primary: primaryColor,
      ),
      useMaterial3: true,
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      primaryColor: Colors.blue,
      colorScheme: ColorScheme.fromSeed(
        seedColor: Colors.blue,
        brightness: Brightness.dark,
      ),
    );
  }
}