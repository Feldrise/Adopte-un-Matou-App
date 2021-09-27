import 'package:adopte_un_matou/models/page_item.dart';
import 'package:adopte_un_matou/presentation/a_u_m_icons_icons.dart';
import 'package:adopte_un_matou/src/pages/administration/adoption_management_page/adoption_management_page.dart';
import 'package:adopte_un_matou/src/pages/dashboard_page/dashboard_page.dart';
import 'package:adopte_un_matou/src/pages/main_page/main_page.dart';
import 'package:adopte_un_matou/src/utils/app_manager.dart';
import 'package:flutter/material.dart';

class AdminMainPage extends StatelessWidget {
  final List<Widget> pages = [
    ClipRect(
      child: Navigator(
        key: AppManager.instance.dashboardKey,
        onGenerateRoute: (route) => MaterialPageRoute<dynamic>(
          settings: route,
          builder: (context) => const DashboardPage()
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

  final List<PageItem> pageItems = const [
    PageItem(
      index: 0,
      title: "Dashboard",
      icon: Icons.dashboard
    ),
    PageItem(
      index: 1,
      title: "Gérer les chats à l'adoption",
      icon: AUMIcons.cat
    )
  ];

  @override
  Widget build(BuildContext context) {
    return MainPage(
      pageItems: pageItems, 
      pages: pages
    );
  }
}