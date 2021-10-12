import 'package:adopte_un_matou/src/provider/states/theme_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final themeControllerProvider = StateNotifierProvider.autoDispose<ThemeController, ThemeState>((ref) {
  return ThemeController(const ThemeState());
});

class ThemeController extends StateNotifier<ThemeState> {
  ThemeController(ThemeState state) : super(state);

  Future loadThemeFromSettings() async {
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    final themeMode = preferences.getBool("theme_isDark") ?? false ? ThemeMode.dark : ThemeMode.light;

    
    state = state.copyWidth(theme: themeMode, loadedAtStartup: true);
  }

  Future toggleTheme() async {
    final SharedPreferences preferences = await SharedPreferences.getInstance();

    final themeMode = state.theme == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
    preferences.setBool("theme_isDark", themeMode == ThemeMode.dark);

    state = state.copyWidth(theme: themeMode);
  }


}