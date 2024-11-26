import 'package:flutter/material.dart';

import 'package:biteflow/core/constants/theme_constants.dart';

ElevatedButtonThemeData elevatedButtonThemeData = ElevatedButtonThemeData(
  style: ElevatedButton.styleFrom(
    padding: const EdgeInsets.all(ThemeConstants.defaultPadding),
    backgroundColor: ThemeConstants.primaryColor,
    foregroundColor: Colors.white,
    // minimumSize: const Size(double.infinity, 32),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(ThemeConstants.defaultBorderRadious)),
    ),
  ),
);

OutlinedButtonThemeData outlinedButtonTheme(
    {Color borderColor = ThemeConstants.blackColor10}) {
  return OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      padding: const EdgeInsets.all(ThemeConstants.defaultPadding),
      // minimumSize: const Size(double.infinity, 32),
      foregroundColor: ThemeConstants.primaryColor,
      side: BorderSide(width: 1.5, color: borderColor),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(ThemeConstants.defaultBorderRadious)),
      ),
    ),
  );
}

final textButtonThemeData = TextButtonThemeData(
  style: TextButton.styleFrom(foregroundColor: ThemeConstants.primaryColor),
);
