

import 'package:biteflow/viewmodels/base_model.dart';
import 'package:flutter/material.dart';

class ModeViewModel extends BaseModel {

ThemeMode _themeMode = ThemeMode.system;
ThemeMode get themeMode => _themeMode;

void toggleThemeMode() {
  _themeMode = _themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
  notifyListeners();
}
}
