import 'package:adopte_un_matou/models/page_item.dart';
import 'package:adopte_un_matou/presentation/a_u_m_icons_icons.dart';
import 'package:adopte_un_matou/src/pages/administration/adoption_management_page/adoption_management_page.dart';
import 'package:adopte_un_matou/src/pages/dashboard_page/dashboard_page.dart';
import 'package:adopte_un_matou/src/pages/main_page/main_page.dart';
import 'package:adopte_un_matou/src/utils/app_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';

enum AdminPages { dashboard, adoption, adoptedCat }

class AdminMainPage extends StatelessWidget {
  final GlobalKey<MainPageState> mainPageKey = GlobalKey<MainPageState>();

  @override
  Widget build(BuildContext context) {
    const Map<AdminPages, PageItem> pageItems = {
      AdminPages.dashboard: PageItem(
        index: 0,
        title: "Dashboard",
        icon: FeatherIcons.layers
      ),
      AdminPages.adoption: PageItem(
        index: 1,
        title: "Gérer les chats à l'adoption",
        icon: AUMIcons.cat
      )
    };

    final List<Widget> pages = [
      ClipRect(
        child: Navigator(
          key: AppManager.instance.dashboardKey,
          onGenerateRoute: (route) => MaterialPageRoute<dynamic>(
            settings: route,
            builder: (context) => DashboardPage(
              pageItems: pageItems,
              onPageChanged: (pageItem) {
                mainPageKey.currentState!.selectPage(pageItem);
              },
            )
          ),
        ),
      ),
      ClipRect(
        child: Navigator(
          key: AppManager.instance.adoptionManagementKey,
          onGenerateRoute: (route) => MaterialPageRoute<dynamic>(
            settings: route,
            builder: (context) => const AdoptionManagementPage()
          ),
        ),
      )
    ];

    return MainPage(
      key: mainPageKey,
      pageItems: pageItems.values.toList(), 
      pages: pages
    );
  }
}