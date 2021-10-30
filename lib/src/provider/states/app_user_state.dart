import 'package:adopte_un_matou/models/user.dart';
import 'package:flutter/material.dart';

@immutable
class AppUserState {
  final bool loadedAtStartup;
  final User? user;

  const AppUserState({
    this.user,
    this.loadedAtStartup = false
  });

  AppUserState copyWidth({
    User? user,
    bool? loadedAtStartup,
  }) {
    if (this.user != null) {
      return AppUserState(
        user: user != null ? this.user!.copyWith(
          id: user.id,
          firstName: user.firstName,
          lastName: user.lastName,
          email: user.email,
          role: user.role,
        ) : user,
        loadedAtStartup: loadedAtStartup ?? this.loadedAtStartup
      );
    }

    return AppUserState(
      user: user ?? this.user,
      loadedAtStartup: loadedAtStartup ?? this.loadedAtStartup
    );
  }
}