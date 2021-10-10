import 'package:adopte_un_matou/models/user.dart';
import 'package:adopte_un_matou/services/authentication_service.dart';
import 'package:adopte_un_matou/src/provider/controller/states/user_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final userControllerProvider = StateNotifierProvider.autoDispose<UserController, UserState>((ref) {
  return UserController(const UserState(user: null));
});

class UserController extends StateNotifier<UserState> {
  UserController(UserState state): super(state);
  
  Future loadFromSettings() async {
    final User? user = await AuthenticationService.instance.getLoggedUser();

    state = state.copyWidth(user: user, loadedAtStartup: true);
  }
  void loginUser(User? loggedUser) {
    state = state.copyWidth(user: loggedUser, loadedAtStartup: true);
  }

  Future logout() async {
    await AuthenticationService.instance.logoutUser();
    state = state.copyWidth(user: null, loadedAtStartup: true);
  }

}