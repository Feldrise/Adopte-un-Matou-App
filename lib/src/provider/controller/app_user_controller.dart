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

    state = state.copyWith(user: user, loadedAtStartup: true);
  }
  void loginUser(User? loggedUser) {
    state = state.copyWith(user: loggedUser, loadedAtStartup: true);
  }

  Future logout() async {
    await AuthenticationService.instance.logoutUser();
    state = state.copyWith(user: null, loadedAtStartup: true);
  }

  void updateUser(User user) {
    if (user.id == null) return;

    state = state.copyWith(
      user: user
    );
  }

}