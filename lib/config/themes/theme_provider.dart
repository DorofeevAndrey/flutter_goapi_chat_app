import 'package:flutter/material.dart';

import 'dark_mode.dart';
import 'light_mode.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeData _themeData;

  ThemeProvider({required Brightness systemBrightness})
    : _themeData = systemBrightness == Brightness.dark ? darkMode : lightMode;

  ThemeData get themeData => _themeData;

  bool get isDarkMode => _themeData == darkMode;

  set themeData(ThemeData themeData) {
    _themeData = themeData;
    notifyListeners();
  }

  void toggleTheme() {
    _themeData = _themeData == lightMode ? darkMode : lightMode;
    notifyListeners();
  }
}
