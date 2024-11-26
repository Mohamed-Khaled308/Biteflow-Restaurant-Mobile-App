import 'package:flutter/material.dart';
import 'package:biteflow/core/constants/theme_constants.dart';

const AppBarTheme appBarLightTheme = AppBarTheme(
  backgroundColor: Colors.white,
  elevation: 0,
  iconTheme: IconThemeData(color: ThemeConstants.blackColor),
  titleTextStyle: TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    color: ThemeConstants.blackColor,
  ),
);

const AppBarTheme appBarDarkTheme = AppBarTheme(
  backgroundColor: ThemeConstants.blackColor,
  elevation: 0,
  iconTheme: IconThemeData(color: Colors.white),
  titleTextStyle: TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    color: Colors.white,
  ),
);

ScrollbarThemeData scrollbarThemeData = ScrollbarThemeData(
  trackColor: WidgetStateProperty .all(ThemeConstants.primaryColor),
);

DataTableThemeData dataTableLightThemeData = DataTableThemeData(
  columnSpacing: 24,
  headingRowColor: WidgetStateProperty .all(Colors.black12),
  decoration: BoxDecoration(
    borderRadius: const BorderRadius.all(Radius.circular(ThemeConstants.defaultBorderRadious)),
    border: Border.all(color: Colors.black12),
  ),
  dataTextStyle: const TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    color: ThemeConstants.blackColor,
  ),
);

DataTableThemeData dataTableDarkThemeData = DataTableThemeData(
  columnSpacing: 24,
  headingRowColor: WidgetStateProperty .all(Colors.white10),
  decoration: BoxDecoration(
    borderRadius: const BorderRadius.all(Radius.circular(ThemeConstants.defaultBorderRadious)),
    border: Border.all(color: Colors.white10),
  ),
  dataTextStyle: const TextStyle(
    fontWeight: FontWeight.w500,
    color: Colors.white,
    fontSize: 12,
  ),
);
