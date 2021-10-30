import 'package:adopte_un_matou/models/application.dart';
import 'package:adopte_un_matou/services/applications_service.dart';
import 'package:adopte_un_matou/src/provider/states/applications_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final applicationsControllerProvider = StateNotifierProvider.autoDispose<ApplicationsController, ApplicationsState>((ref) {
  return ApplicationsController(
    const ApplicationsState(applications: AsyncValue.loading())
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
        applications: AsyncValue.error(e, previous: state.applications.asData)
      );
    }
  }
}