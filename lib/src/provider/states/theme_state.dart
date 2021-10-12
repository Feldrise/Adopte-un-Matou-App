import 'package:flutter/material.dart';

@immutable
class ThemeState {
  final ThemeMode theme;
  final bool loadedAtStartup;

  const ThemeState({
    this.theme = ThemeMode.light,
    this.loadedAtStartup = false
  });

  ThemeState copyWidth({
    ThemeMode? theme,
    bool? loadedAtStartup
  }) {
    return ThemeState(
      theme: theme ?? this.theme,
      loadedAtStartup:  loadedAtStartup ?? this.loadedAtStartup
    );
  }
}