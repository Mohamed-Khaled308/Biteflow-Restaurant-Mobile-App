import 'package:flutter/material.dart';

class ThemeConstants {
  static const grandisExtendedFont = 'Grandis Extended';

  static const Color primaryColor = Color(0xFFFF4444);
  static const Color primaryColorDark = Color(0xFF5D2E2E);

  // e.g. primaryMaterialColor.shade100
  static const MaterialColor primaryMaterialColor =
      MaterialColor(0xFFC62828, <int, Color>{
    50: Color(0xFFFFEBEE), // Very light pink-red
    100: Color(0xFFFFCDD2), // Light pink-red
    200: Color(0xFFEF9A9A), // Soft rosy red
    300: Color(0xFFE57373), // Mellow red
    400: Color(0xFFEF5350), // Vibrant mid-red
    500: Color(0xFFC62828), // Base ruby red
    600: Color(0xFFB71C1C), // Deep ruby red
    700: Color(0xFF8B0000), // Dark crimson red
    800: Color(0xFF7F0000), // Deeper ruby red
    900: Color(0xFF6B0000), // Darkest ruby red
  });

  static const MaterialColor whiteText = MaterialColor(0xFFFFFFFF, <int, Color>{
    50: Color(0xFFFFFAFA), // Slightly off-white
    100: Color(0xFFFFF5F5), // Very light white-gray
    200: Color(0xFFFFF0F0), // Softer white
    300: Color(0xFFFFEBEB), // Mellow white
    400: Color(0xFFFFE5E5), // Warm white
    500: Color(0xFFFFFFFF), // Pure white
    600: Color(0xFFFAFAFA), // Slightly muted white
    700: Color(0xFFF5F5F5), // Muted white
    800: Color(0xFFEFEFEF), // Soft grayish-white
    900: Color(0xFFE0E0E0), // Light gray
  });

  static const MaterialColor blackText = MaterialColor(0xFF000000, <int, Color>{
    50: Color(0xFFFAFAFA), // Very light gray
    100: Color(0xFFF5F5F5), // Light gray
    200: Color(0xFFEEEEEE), // Softer gray
    300: Color(0xFFE0E0E0), // Mellow gray
    400: Color(0xFFBDBDBD), // Mid gray
    500: Color(0xFF000000), // Pure black
    600: Color(0xFF212121), // Very dark gray
    700: Color(0xFF121212), // Near black
    800: Color(0xFF0D0D0D), // Almost black
    900: Color(0xFF000000), // Pure black
  });

  static const Color secondaryColor = Color(0xFF6D7434); // Olive Green

  static const Color blackColor = Color(0xFF16161E);
  static const Color blackColor80 = Color(0xFF45454B);
  static const Color blackColor60 = Color(0xFF737378);
  static const Color blackColor40 = Color(0xFFA2A2A5);
  static const Color blackColor20 = Color(0xFFD0D0D2);
  static const Color blackColor10 = Color(0xFFE8E8E9);
  static const Color blackColor5 = Color(0xFFF3F3F4);

  static const Color whiteColor = Colors.white;
  static const Color whiteColor80 = Color(0xFFCCCCCC);
  static const Color whiteColor60 = Color(0xFF999999);
  static const Color whiteColor40 = Color(0xFF666666);
  static const Color whiteColor20 = Color(0xFF333333);
  static const Color whiteColor10 = Color(0xFF191919);
  static const Color whiteColor5 = Color(0xFF0D0D0D);

  static const Color greyColor = Color(0xFFB8B5C3);
  static const Color lightGreyColor = Color(0xFFF8F8F9);
  static const Color darkGreyColor = Color(0xFF1C1C25);

  static const Color successColor = Color(0xFF2ED573);
  static const Color warningColor = Color(0xFFFFBE21);
  static const Color errorColor = Color(0xFFEA5B5B);

  static const Color blueColor = Colors.blue;

  static const double defaultPadding = 20.0;
  static const double defaultBorderRadious = 12.0;
}
