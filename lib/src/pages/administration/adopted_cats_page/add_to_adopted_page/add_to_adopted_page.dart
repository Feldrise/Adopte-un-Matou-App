import 'package:adopte_un_matou/src/pages/administration/adopted_cats_page/add_to_adopted_page/widgets/add_to_adopted_card.dart';
import 'package:adopte_un_matou/src/provider/controller/cats_controller.dart';
import 'package:adopte_un_matou/src/shared/widgets/general/am_app_bar.dart';
import 'package:adopte_un_matou/src/shared/widgets/general/am_status_message.dart';
import 'package:adopte_un_matou/src/utils/screen_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AddToAdoptedPage extends ConsumerWidget {
  const AddToAdoptedPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: const AmAppBar(
        title: Text("Ajouter un chat adopté"),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: ScreenUtils.instance.horizontalPadding),
        child: ref.watch(catsControllerProvider).catsToAdopte.when(
          data: (data) => ListView(
            shrinkWrap: true,
            children: [
              for (final cat in data) ...{
                AddToAdoptedCart(cat: cat),
                const SizedBox(height: 16,)
              }
            ],
          ),
          loading: (previous) => const Center(child: CircularProgressIndicator(),),
          error: (error, stackTrace, previous) => Center(
            child: AmStatusMessage(
              title: "Erreur de chargement",
              message: "Impossible de charger les chats à adopter : $error",
            ),
          )
        ),
      ),
    );
  }
}