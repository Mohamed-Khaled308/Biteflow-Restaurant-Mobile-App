import 'package:flutter/material.dart';
import 'package:biteflow/constants/theme_constants.dart';

const InputDecorationTheme lightInputDecorationTheme = InputDecorationTheme(
  fillColor: ThemeConstants.lightGreyColor,
  filled: true,
  hintStyle: TextStyle(color: ThemeConstants.greyColor),
  border: outlineInputBorder,
  enabledBorder: outlineInputBorder,
  focusedBorder: focusedOutlineInputBorder,
  errorBorder: errorOutlineInputBorder,
);

const InputDecorationTheme darkInputDecorationTheme = InputDecorationTheme(
  fillColor: ThemeConstants.darkGreyColor,
  filled: true,
  hintStyle: TextStyle(color: ThemeConstants.whileColor40),
  border: outlineInputBorder,
  enabledBorder: outlineInputBorder,
  focusedBorder: focusedOutlineInputBorder,
  errorBorder: errorOutlineInputBorder,
);

const OutlineInputBorder outlineInputBorder = OutlineInputBorder(
  borderRadius:
      BorderRadius.all(Radius.circular(ThemeConstants.defaultBorderRadious)),
  borderSide: BorderSide(
    color: Colors.transparent,
  ),
);

const OutlineInputBorder focusedOutlineInputBorder = OutlineInputBorder(
  borderRadius:
      BorderRadius.all(Radius.circular(ThemeConstants.defaultBorderRadious)),
  borderSide: BorderSide(color: ThemeConstants.darkGreyColor),
);

const OutlineInputBorder errorOutlineInputBorder = OutlineInputBorder(
  borderRadius:
      BorderRadius.all(Radius.circular(ThemeConstants.defaultBorderRadious)),
  borderSide: BorderSide(
    color: ThemeConstants.errorColor,
  ),
);

OutlineInputBorder secodaryOutlineInputBorder(BuildContext context) {
  return OutlineInputBorder(
    borderRadius: const BorderRadius.all(
        Radius.circular(ThemeConstants.defaultBorderRadious)),
    borderSide: BorderSide(
      color: Theme.of(context).textTheme.bodyLarge!.color!.withOpacity(0.15),
    ),
  );
}
