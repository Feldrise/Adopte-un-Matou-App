import 'package:adopte_un_matou/models/user.dart';
import 'package:adopte_un_matou/services/authentication_service.dart';
import 'package:flutter/material.dart';

class UserStore with ChangeNotifier {
  User? _user;

  Future<User?> get loggedUser async {
    return _user ??= await AuthenticationService.instance.getLoggedUser();
  }

  void loginUser(User loggedUser) {
    _user = loggedUser;

    notifyListeners();
  }

  Future logout() async {
    await AuthenticationService.instance.logoutUser();
    _user = null;

    notifyListeners();
  }

  User? get user => _user;

  String? get id => (_user != null) ? _user!.id : null;
  String get authenticationHeader => (_user != null) ? _user!.authenticationHeader : "Invalid";
}