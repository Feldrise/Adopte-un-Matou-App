import 'package:adopte_un_matou/models/application.dart';
import 'package:adopte_un_matou/services/applications_service.dart';
import 'package:adopte_un_matou/src/provider/states/applications_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final applicationsControllerProvider = StateNotifierProvider<ApplicationsController, ApplicationsState>((ref) {
  return ApplicationsController(
    const ApplicationsState(
      applications: AsyncValue.loading(),
      userApplication: AsyncValue.loading(),
    )
  );
});

class ApplicationsController extends StateNotifier<ApplicationsState> {
  ApplicationsController(ApplicationsState state) : super(state);

  Future loadData({String? authenticationHeader, bool refresh = false}) async {
    if (state.applications.asData != null && !refresh) return;

    state = state.copyWith(applications: const AsyncValue.loading());

    try {
      Map<String, Application> applications = await ApplicationsService.instance.getApplications(authorization: authenticationHeader);

      state = state.copyWith(
        applications: AsyncValue.data(applications)
      );
    }
    on Exception catch(e) {
      state = state.copyWith(
        applications: AsyncValue.error(e)
      );
    }
  }

  Future loadUserApplicationData(String userId, {String? authenticationHeader, bool refresh = false}) async {
    if (state.userApplication.asData != null && !refresh) return;

    state = state.copyWith(userApplication: const AsyncValue.loading());

    try {
      Application? application = await ApplicationsService.instance.getUserApplication(userId, authorization: authenticationHeader);

      state = state.copyWith(
        userApplication: AsyncValue.data(application)
      );
    }
    on Exception catch(e) {
      state = state.copyWith(
       userApplication: AsyncValue.error(e)
      );
    }
  }


  void updateApplication(Application application) {
    if (application.id == null) return;

    state.applications.asData!.value[application.id!] = application;
    state = state.copyWith(
      applications: state.applications
    );
  }

}