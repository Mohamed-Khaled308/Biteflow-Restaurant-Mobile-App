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
      primarySwatch: ThemeConstants.blackText,
      primaryColor: ThemeConstants.primaryColor,
      secondaryHeaderColor: Colors.black,
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
  static ThemeData darkTheme(BuildContext context) {
    return ThemeData(
      brightness: Brightness.dark,
      fontFamily: 'Plus Jakarta',
      primarySwatch: ThemeConstants.whiteText,
      primaryColor: ThemeConstants.primaryColorDark,
      secondaryHeaderColor: Colors.white,
      scaffoldBackgroundColor: ThemeConstants.blackColor,
      iconTheme: const IconThemeData(color: ThemeConstants.whiteColor),
      textTheme: const TextTheme(
        bodyMedium: TextStyle(color: ThemeConstants.whiteColor40),
      ),
      elevatedButtonTheme: elevatedButtonThemeData,
      textButtonTheme: textButtonThemeData,
      outlinedButtonTheme: outlinedButtonTheme(),
      inputDecorationTheme: darkInputDecorationTheme,
      checkboxTheme: checkboxThemeData.copyWith(
        side: const BorderSide(color: ThemeConstants.whiteColor40),
      ),
      appBarTheme: appBarDarkTheme,
      scrollbarTheme: scrollbarThemeData,
      dataTableTheme: dataTableDarkThemeData,
    );
  }


}
