
import 'package:adopte_un_matou/models/user.dart';
import 'package:adopte_un_matou/services/users_service.dart';
import 'package:adopte_un_matou/src/provider/states/users_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final usersControllerProvider = StateNotifierProvider<UsersController, UsersState>((ref) {
  return UsersController(
    const UsersState(users: AsyncValue.loading())
  );
});

class UsersController extends StateNotifier<UsersState> {
  UsersController(UsersState state) : super(state);

  Future loadData({String? authenticationHeader, bool shouldIncludeSensitiveInfo = false, bool refresh = false}) async {
    if (state.users.asData != null && !refresh) return;

    state = state.copyWith(users: const AsyncValue.loading());

    try {
      Map<String, User> users = await UsersService.instance.getUsers(authorization: authenticationHeader, shouldIncludeSensitiveInfo: shouldIncludeSensitiveInfo);

      state = state.copyWith(
        users: AsyncValue.data(users)
      );
    }
    on Exception catch(e) {
      state = state.copyWith(
        users: AsyncValue.error(e)
      );
    }
  }

  void updateUser(User user) {
    if (user.id == null) return;

    state.users.asData!.value[user.id!] = user;
    state = state.copyWith(
      users: state.users
    );
  }

}