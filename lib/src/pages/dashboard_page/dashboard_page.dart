import 'package:adopte_un_matou/models/page_item.dart';
import 'package:adopte_un_matou/src/pages/administration/admin_main_page/admin_main_page.dart';
import 'package:adopte_un_matou/src/pages/dashboard_page/manage_adoptions_page/manage_adoptions_page.dart';
import 'package:adopte_un_matou/src/pages/dashboard_page/widgets/dashboard_card.dart';
import 'package:adopte_un_matou/src/providers/user_store.dart';
import 'package:adopte_un_matou/src/utils/screen_utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({
    Key? key,
    required this.onPageChanged,
    required this.pageItems,
  }) : super(key: key);

  final Function(PageItem) onPageChanged;
  final Map<AdminPages, PageItem> pageItems;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              text: "Gérer les adoptions",
              catImage: "cat7", 
              onTap: () async {
                await Navigator.of(context).push(
                  MaterialPageRoute( 
                    builder: (context) => ManageAdoptionsPage(pageItems: pageItems, onPageChanged: onPageChanged)
                  )
                );
              },
            ),
            DashboardCard(
              text: "Gérer les utilisateurs",
              catImage: "cat9", 
              onTap: () {},
            ),
            DashboardCard(
              text: "Gérer les documents",
              catImage: "cat10", 
              onTap: () {},
            ),
            DashboardCard(
              text: "Gérer mon profil",
              catImage: "cat1", 
              onTap: () {},
            ),
            DashboardCard(
              text: "Supprimer mon compte",
              catImage: "cat2", 
              onTap: () {},
            ),
            DashboardCard(
              text: "Se déconnecter",
              catImage: "cat11", 
              onTap: () {
                Provider.of<UserStore>(context, listen: false).logout();
              },
            ),
          ],
        ),
      ),
    );
  }
}