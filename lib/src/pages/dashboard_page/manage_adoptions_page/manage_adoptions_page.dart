import 'package:adopte_un_matou/models/page_item.dart';
import 'package:adopte_un_matou/src/pages/administration/admin_main_page/admin_main_page.dart';
import 'package:adopte_un_matou/src/pages/dashboard_page/widgets/dashboard_card.dart';
import 'package:adopte_un_matou/src/shared/widgets/general/am_app_bar.dart';
import 'package:adopte_un_matou/src/utils/screen_utils.dart';
import 'package:flutter/material.dart';

class ManageAdoptionsPage extends StatelessWidget {
  const ManageAdoptionsPage({
    Key? key,
    required this.pageItems,
    required this.onPageChanged
  }) : super(key: key);

  final Function(PageItem) onPageChanged;

  final Map<AdminPages, PageItem> pageItems;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AmAppBar(title: Text("Gérer les adoptions")),
        body: Padding(
        padding: EdgeInsets.symmetric(vertical: 32, horizontal: ScreenUtils.instance.horizontalPadding),
        child: GridView(
          gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 500,
            crossAxisSpacing: 16,
            mainAxisExtent: 250,
            mainAxisSpacing: 16
          ),
          children: [
            DashboardCard(
              text: "Gérer les chats à l'adoption",
              catImage: "cat12", 
              onTap: () => onPageChanged(pageItems[AdminPages.adoption]!)
            ),
            DashboardCard(
              text: "Gérer les chats adoptés",
              catImage: "cat13", 
              onTap: () => onPageChanged(pageItems[AdminPages.adoptedCat]!)
            ),
            DashboardCard(
              text: "Gérer les candidatures",
              catImage: "cat14", 
              onTap: () => onPageChanged(pageItems[AdminPages.applications]!)
            ),
          ]
        )
      ),
    );
  }
}