import 'package:adopte_un_matou/src/pages/administration/adopted_cats_page/add_to_adopted_page/add_to_adopted_page.dart';
import 'package:adopte_un_matou/src/pages/administration/adopted_cats_page/adopted_cats_page.dart';
import 'package:adopte_un_matou/src/provider/controller/cats_controller.dart';
import 'package:adopte_un_matou/src/shared/widgets/cards/cat_card.dart';
import 'package:adopte_un_matou/src/shared/widgets/general/am_status_message.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AdoptedList extends ConsumerWidget {
  const AdoptedList({
    Key? key,
    required this.editMode,
  }) : super(key: key);

  final bool editMode;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ref.watch(catsControllerProvider).adoptedCats.when(
      data: (cats) {
        if (cats.isEmpty && !editMode) {
          return _buildEmptyWidget();
        } 

        return GridView(
          gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 210,
            crossAxisSpacing: 16,
            mainAxisExtent: 250,
            mainAxisSpacing: 16
          ),
          primary: false,
          children: [
            for (final cat in cats) 
              CatCard(cat: cat),
            
            if (editMode) 
              _buildAddButton(context, ref)
          ], 
        );
      },
      loading: (data) => const Center(child: CircularProgressIndicator(),),
      error: (error, stackTrace, data) => AmStatusMessage(
        title: "Erreur",
        message: "Une erreur est survenue : $error"
      )
    );
  }

  Widget _buildAddButton(BuildContext context, WidgetRef ref) {
    const borderRadius = 11.0;

    return InkWell(
      onTap: () async => _addCatPressed(context, ref),
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColor.withOpacity(0.2),
          borderRadius: BorderRadius.circular(borderRadius)
        ),
        padding: const EdgeInsets.all(1.0),
        child: DottedBorder(
          color: Theme.of(context).primaryColor,
          strokeWidth: 1,
          radius: const Radius.circular(borderRadius),
          dashPattern: const [10, 5],
          customPath: (size) {
            return Path()
              ..moveTo(borderRadius, 0)
              ..lineTo(size.width - borderRadius, 0)
              ..arcToPoint(Offset(size.width, borderRadius), radius: const Radius.circular(borderRadius))
              ..lineTo(size.width, size.height - borderRadius)
              ..arcToPoint(Offset(size.width - borderRadius, size.height), radius: const Radius.circular(borderRadius))
              ..lineTo(borderRadius, size.height)
              ..arcToPoint(Offset(0, size.height - borderRadius), radius: const Radius.circular(borderRadius))
              ..lineTo(0, borderRadius)
              ..arcToPoint(const Offset(borderRadius, 0), radius: const Radius.circular(borderRadius));
          },
          child: Center(
            child: Icon(
              FeatherIcons.plusCircle, 
              color: Theme.of(context).primaryColor.withOpacity(0.5),
              size: 52,
            ),
          )
        ),
      ),
    );
  }

  Widget _buildEmptyWidget() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Image.asset(
          "assets/icons/dayflowCat.png",
          height: 125,
        ),
        const SizedBox(height: 16,),
        const Text(
          "Appuyez sur le crayon pour ajouter des chats à adopter",
          textAlign: TextAlign.center,
        )
      ],
    );
  }

  Future _addCatPressed(BuildContext context, WidgetRef ref) async {
    await Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => const AddToAdoptedPage())
    );
  }
}