import 'package:adopte_un_matou/src/pages/administration/applications_page/widgets/application_card.dart';
import 'package:adopte_un_matou/src/provider/controller/applications_controller.dart';
import 'package:adopte_un_matou/src/shared/widgets/general/am_app_bar.dart';
import 'package:adopte_un_matou/src/shared/widgets/general/am_status_message.dart';
import 'package:adopte_un_matou/src/utils/screen_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ApplicationsPage extends ConsumerWidget {
  const ApplicationsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: const AmAppBar(
        title: Text("Gérer les candidatures"),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: ScreenUtils.instance.horizontalPadding, vertical: 0.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text("Liste des demandes", style: Theme.of(context).textTheme.headline3,),
            const SizedBox(height: 16,),
            Flexible(
              child:  ref.watch(applicationsControllerProvider).applicationsList.when(
                data: (data) => ListView(
                  shrinkWrap: true,
                  children: [
                    for (final application in data)
                      ApplicationCard(application: application),
                  ], 
                ),
                loading: () => const Center(child: CircularProgressIndicator(),),
                error: (error, stackTrace) => AmStatusMessage(
                  title: "Impossible de charger la liste",
                  message: "La liste des candidatures ne peut pas être chargé : $stackTrace",
                )
              )
            ),
          ],
        ),
      ),
    );
  }
}