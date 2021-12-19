
import 'package:adopte_un_matou/models/user.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

@immutable
class UsersState {
  final AsyncValue<Map<String, User>> users;

  AsyncValue<List<User>> get usersList {
    return users.when(
      data: (data) {
        return AsyncValue.data(data.values.toList());
      },
      loading: () => const AsyncValue.loading(),
      error: (error, stackTrace) => AsyncValue.error(error, stackTrace: stackTrace)
    );
  }

  const UsersState({
    required this.users,
  });

  UsersState copyWith({
    AsyncValue<Map<String, User>>? users,
  }) {
    return UsersState(users: users ?? this.users);
  }
}