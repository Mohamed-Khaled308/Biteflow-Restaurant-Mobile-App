import 'package:flutter/material.dart';
import 'package:biteflow/core/constants/theme_constants.dart';

CheckboxThemeData checkboxThemeData = CheckboxThemeData(
  checkColor: WidgetStateProperty.all(Colors.white),
  shape: const RoundedRectangleBorder(
    borderRadius: BorderRadius.all(
      Radius.circular(ThemeConstants.defaultBorderRadious / 2),
    ),
  ),
  side: const BorderSide(color: ThemeConstants.whiteColor40),
);
