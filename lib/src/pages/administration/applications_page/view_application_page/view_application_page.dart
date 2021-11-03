import 'package:adopte_un_matou/models/application.dart';
import 'package:adopte_un_matou/models/user.dart';
import 'package:adopte_un_matou/services/applications_service.dart';
import 'package:adopte_un_matou/src/pages/administration/applications_page/view_application_page/widgets/application_step_dialog.dart';
import 'package:adopte_un_matou/src/provider/controller/app_user_controller.dart';
import 'package:adopte_un_matou/src/provider/controller/users_controller.dart';
import 'package:adopte_un_matou/src/shared/forms/application_form.dart';
import 'package:adopte_un_matou/src/shared/widgets/general/am_app_bar.dart';
import 'package:adopte_un_matou/src/shared/widgets/general/am_status_message.dart';
import 'package:adopte_un_matou/src/utils/screen_utils.dart';
import 'package:adopte_un_matou/theme/palette.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class ViewApplicationPage extends ConsumerStatefulWidget {
  const ViewApplicationPage({
    Key? key,
    required this.applicationId
  }) : super(key: key);

  final String applicationId;

  @override
  ConsumerState<ViewApplicationPage> createState() => _ViewApplicationPageState();
}

class _ViewApplicationPageState extends ConsumerState<ViewApplicationPage> {
  bool _isEditing = false;
  
  Application? _application;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AmAppBar(
        title: const Text("Voir une candidature"),
        actions: [
            IconButton(
              icon: const Icon(FeatherIcons.edit2),
              color: Theme.of(context).primaryColor,
              onPressed: _isEditing ? null : () {
                setState(() {
                  _isEditing = true;
                });
              },
            )
        ],
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(vertical: 32, horizontal: ScreenUtils.instance.horizontalPadding),
        child: _application == null ? FutureBuilder(
          future: ApplicationsService.instance.getApplication(
            widget.applicationId,
            authorization: ref.watch(appUserControllerProvider).user?.authenticationHeader
          ),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasError) {
                return AmStatusMessage(
                  title: "Erreur de chargement",
                  message: "La candidature n'a pas pu être chargé : ${snapshot.error}",
                );
              }

              _application = snapshot.data as Application;
              return _buildContent();
            }

            return const Center(child: CircularProgressIndicator(),);
          },
        ) : _buildContent(),
      ),
    );
  }

  Widget _buildContent() {
    final User applicationUser = ref.watch(usersControllerProvider).users.asData!.value[_application!.userId]!;

    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildHeader(applicationUser),
          const SizedBox(height: 16,),
          Flexible(
            child: ApplicationForm(
              application: _application!,
              user: applicationUser,
              isEditing: _isEditing,
            ),
          ),
        ],
      )
    );
  }

  Widget _buildHeader(User applicationUser) {
    return Flexible(
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(46),
            child: Container(
              width: 92,
              height: 92,
              color: Palette.colorGrey3,
            ),
          ),
          const SizedBox(width: 16,),
          Flexible(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Flexible(child: Text(applicationUser.fullName, style: Theme.of(context).textTheme.headline3,)),
                const SizedBox(height: 8,),
                Flexible(
                  child: Wrap(
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      Text(
                        "${ApplicationStep.detailed[_application!.step]!} - ${DateFormat('dd/MM/yyyy').format(_application!.date)}", 
                        style: Theme.of(context).textTheme.headline4,
                      ),
                      if (_isEditing)
                        IconButton(
                          icon: const Icon(FeatherIcons.edit2, size: 16,),
                          iconSize: 16,
                          padding: EdgeInsets.zero,
                          onPressed: () async {
                            final String? newStep = await showDialog(
                              context: context, 
                              builder: (context) => ApplicationStepDialog(initialStep: _application!.step,
                              )
                            );

                            if (newStep != null) {
                              setState(() {
                                _application = _application!.copyWith(
                                  step: newStep
                                );
                              });
                            }
                          },
                        )
                    ],
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}