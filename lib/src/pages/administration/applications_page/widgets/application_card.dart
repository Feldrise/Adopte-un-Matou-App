import 'package:adopte_un_matou/models/application.dart';
import 'package:adopte_un_matou/src/pages/administration/applications_page/view_application_page/view_application_page.dart';
import 'package:adopte_un_matou/src/provider/controller/cats_controller.dart';
import 'package:adopte_un_matou/src/provider/controller/users_controller.dart';
import 'package:adopte_un_matou/theme/palette.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class ApplicationCard extends ConsumerWidget {
  const ApplicationCard({
    Key? key,
    required this.application
  }) : super(key: key);

  final Application application;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        border: Border.all(
          color: Palette.colorGrey3,
          width: 1,
        ),
        borderRadius: BorderRadius.circular(11)
      ),
      child: ref.watch(usersControllerProvider).users.when(
        data: (data) => Row(
          children: [
            Flexible(
              flex: 15,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(45),
                child: Container(
                  color: const Color(0xffc7c7c7),
                  height: 70,
                  width: 70,
                ),
              ),
            ),
            const SizedBox(width: 24),
            Flexible(
              flex: 70,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(data[application.userId]?.fullName ?? "Unknown user"),
                  const SizedBox(height: 12,),
                  Flexible(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildInfo("Etape", ApplicationStep.detailed[application.step] ?? "Unknown"),
                        Flexible(child: Container(width: 1, height: 48, color: Palette.colorGrey3,),),
                        // const SizedBox(width: 32,),
                        _buildInfo("Date", DateFormat("dd/MM/yyyy").format(application.date)),
                        Flexible(child: Container(width: 1, height: 48, color: Palette.colorGrey3,),),
                        // const SizedBox(width: 32,),
                        _buildInfo("Chat", ref.watch(catsControllerProvider).cats.asData?.value[application.catId]?.name ?? "Chat inconnue"),
                      ],
                    )
                  )
                ],
              ),
            ),
            Flexible(
              flex: 15,
              child: _buildButtons(context),
            )
          ],
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => const Center(child: Text("Impossible de charger l'utilisateur de cette candidature"),)
      )
    );
  }

  Widget _buildInfo(String title, String value) {
    return Flexible(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Flexible(child: Text(title),),
          const SizedBox(height: 4,),
          Flexible(
            child: Text(value, style: const TextStyle(fontSize: 12.0),)
          )
        ],
      ),
    );
  }

  Widget _buildButtons(BuildContext context) {
    return Wrap(
      children: [
        IconButton(
          padding: EdgeInsets.zero,
          iconSize: 20,
          icon: const Icon(FeatherIcons.eye),
          onPressed: () async {
            await Navigator.of(context).push<dynamic>(
              MaterialPageRoute<dynamic>(
                builder: (context) => ViewApplicationPage(applicationId: application.id!)
              )
            );
          },
        ),
        // const SizedBox(width: 4,),
        IconButton(
          padding: EdgeInsets.zero,
          iconSize: 20,
          icon: const Icon(FeatherIcons.trash2),
          onPressed: () {},
        )
      ],
    );
  }
}