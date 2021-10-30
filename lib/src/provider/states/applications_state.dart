import 'package:adopte_un_matou/models/application.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

@immutable
class ApplicationsState {
  final AsyncValue<Map<String, Application>> applications;

  AsyncValue<List<Application>> get applicationsList {
    return applications.when(
      data: (data) {
        return AsyncValue.data(data.values.toList());
      },
      loading: (previous) => const AsyncValue.loading(),
      error: (error, stackTrace, previous) => AsyncValue.error(error, stackTrace: stackTrace)
    );
  }

  const ApplicationsState({
    required this.applications,
  });

  ApplicationsState copyWith({
    AsyncValue<Map<String, Application>>? applications,
  }) {
    return ApplicationsState(applications: applications ?? this.applications);
  }
}