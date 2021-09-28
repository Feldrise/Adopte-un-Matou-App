import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AppManager {
  AppManager._privateConstructor();

  static final AppManager instance = AppManager._privateConstructor();

  final GlobalKey<NavigatorState> appNavigatorKey = GlobalKey<NavigatorState>();
  final GlobalKey<ScaffoldState> drawerKey = GlobalKey<ScaffoldState>();

  final GlobalKey<NavigatorState> profileKey = GlobalKey<NavigatorState>();

  final GlobalKey<NavigatorState> dashboardKey = GlobalKey<NavigatorState>();

  final GlobalKey<NavigatorState> adoptionManagementKey = GlobalKey<NavigatorState>();
  final GlobalKey<NavigatorState> adoptedKey = GlobalKey<NavigatorState>();
  final GlobalKey<NavigatorState> applicationsKey = GlobalKey<NavigatorState>();
  final GlobalKey<NavigatorState> usersKey = GlobalKey<NavigatorState>();
  final GlobalKey<NavigatorState> documentsKey = GlobalKey<NavigatorState>();

  // Because we are calling this from the main widget we have to check
  // nested navigators status.
  Future<bool?> showCloseAppConfirmation(BuildContext context) {
    if (profileKey.currentState != null && profileKey.currentState!.canPop()) {
      profileKey.currentState!.pop();
      return Future.value(false);
    }

    if (dashboardKey.currentState != null && dashboardKey.currentState!.canPop()) {
      dashboardKey.currentState!.pop();
      return Future.value(false);
    }

    if (adoptionManagementKey.currentState != null && adoptionManagementKey.currentState!.canPop()) {
      adoptionManagementKey.currentState!.pop();
      return Future.value(false);
    }

    if (adoptedKey.currentState != null && adoptedKey.currentState!.canPop()) {
      adoptedKey.currentState!.pop();
      return Future.value(false);
    }

    if (usersKey.currentState != null && usersKey.currentState!.canPop()) {
      adoptedKey.currentState!.pop();
      return Future.value(false);
    }

    if (documentsKey.currentState != null && documentsKey.currentState!.canPop()) {
      documentsKey.currentState!.pop();
      return Future.value(false);
    }

    if (appNavigatorKey.currentState!.canPop()) {
      appNavigatorKey.currentState!.pop();
      return Future.value(false);
    }

    // We show the close app confirmation dialog
    return showDialog<bool?>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmation'),
        content: const Text("Etes vous sur de vouloir quitter l'application ?"),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Non'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Oui'),
          ),
        ],
      ),
    );
  }
}