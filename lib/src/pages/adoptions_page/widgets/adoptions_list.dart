import 'package:adopte_un_matou/models/cat.dart';
import 'package:adopte_un_matou/presentation/a_u_m_icons_icons.dart';
import 'package:adopte_un_matou/src/pages/view_cat_page/view_cat_page.dart';
import 'package:adopte_un_matou/src/shared/widgets/cards/cat_card.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';

class AdoptionsList extends StatelessWidget {
  const AdoptionsList({
    Key? key,
    required this.editMode,
    required this.cats
  }) : super(key: key);

  final bool editMode;
  final List<Cat> cats;

  @override
  Widget build(BuildContext context) {
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
      children: [
        for (final cat in cats) 
          CatCard(cat: cat),
        
        if (editMode) 
          _buildAddButton(context)
      ], 
    );
  }

  Widget _buildAddButton(BuildContext context) {
    const borderRadius = 11.0;

    return InkWell(
      onTap: () async => _addCatPressed(context),
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
          "Appuyez sur le crayon pour ajouter des chats à l'adoption",
          textAlign: TextAlign.center,
        )
      ],
    );
  }

  Future _addCatPressed(BuildContext context) async {
    // final Cat tempDemoCat = Cat("superId",
    //   name: "Jack",
    //   age: "7 mois",
    //   genre: "Mal",
    //   price: 160,
    //   location: "Rennes",
    //   description: "Jack est un super chat tout mignon !",
    //   properties: []
    // );

    await Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => const ViewCatPage(canEdit: true,))
    );
  }
}