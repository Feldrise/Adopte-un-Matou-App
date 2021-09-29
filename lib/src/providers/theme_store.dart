import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeStore with ChangeNotifier {
  ThemeMode themeMode = ThemeMode.light;

  Future toggleTheme() async {
    final SharedPreferences preferences = await SharedPreferences.getInstance();

    themeMode = themeMode == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
    preferences.setBool("theme_isDark", themeMode == ThemeMode.dark);

    notifyListeners();
  }

  Future getThemeFromPreferences() async {
    final SharedPreferences preferences = await SharedPreferences.getInstance();

    themeMode = preferences.getBool("theme_isDark") ?? false ? ThemeMode.dark : ThemeMode.light;
  }
}