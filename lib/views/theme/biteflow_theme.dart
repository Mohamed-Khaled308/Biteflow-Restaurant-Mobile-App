import 'package:flutter/material.dart';
import 'package:biteflow/views/theme/button_theme.dart';
import 'package:biteflow/views/theme/input_decoration_theme.dart';
import 'package:biteflow/core/constants/theme_constants.dart';
import 'checkbox_themedata.dart';
import 'theme_data.dart';

class BiteflowTheme {
  static ThemeData lightTheme(BuildContext context) {
    return ThemeData(
      brightness: Brightness.light,
      fontFamily: 'Plus Jakarta',
      primarySwatch: ThemeConstants.primaryMaterialColor,
      primaryColor: ThemeConstants.primaryColor,
      scaffoldBackgroundColor: Colors.white,
      iconTheme: const IconThemeData(color: ThemeConstants.blackColor),
      textTheme: const TextTheme(
        bodyMedium: TextStyle(color: ThemeConstants.blackColor40),
      ),
      elevatedButtonTheme: elevatedButtonThemeData,
      textButtonTheme: textButtonThemeData,
      outlinedButtonTheme: outlinedButtonTheme(),
      inputDecorationTheme: lightInputDecorationTheme,
      checkboxTheme: checkboxThemeData.copyWith(
        side: const BorderSide(color: ThemeConstants.blackColor40),
      ),
      appBarTheme: appBarLightTheme,
      scrollbarTheme: scrollbarThemeData,
      dataTableTheme: dataTableLightThemeData,
    );
  }

  // Dark theme is inclided in the Full template
}
