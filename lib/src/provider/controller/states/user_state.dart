import 'package:adopte_un_matou/models/user.dart';
import 'package:flutter/material.dart';

@immutable
class UserState {
  final bool loadedAtStartup;
  final User? user;

  const UserState({
    this.user,
    this.loadedAtStartup = false
  });

  UserState copyWidth({
    User? user,
    bool? loadedAtStartup,
  }) {
    if (this.user != null) {
      return UserState(
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

    return UserState(
      user: user ?? this.user,
      loadedAtStartup: loadedAtStartup ?? this.loadedAtStartup
    );
  }
}