import 'package:adopte_un_matou/models/user.dart';
import 'package:adopte_un_matou/services/authentication_service.dart';
import 'package:adopte_un_matou/src/provider/states/app_user_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final appUserControllerProvider = StateNotifierProvider.autoDispose<AppUserController, AppUserState>((ref) {
  return AppUserController(const AppUserState(user: null));
});

class AppUserController extends StateNotifier<AppUserState> {
  AppUserController(AppUserState state): super(state);
  
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